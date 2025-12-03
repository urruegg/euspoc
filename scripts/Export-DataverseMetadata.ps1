# Dataverse Metadata Export Script using Web API
# Fetches table metadata from Dataverse using the Web API

param(
    [Parameter(Mandatory=$false)]
    [string]$DataverseUrl
)

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Dataverse Metadata Export via Web API" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Tables to export
$tables = @(
    "contact",
    "ur_nutritiondiary",
    "ur_nutritionlog",
    "ur_smartgoal",
    "ur_nutritioncounselling"
)

# Load from environment variables (GitHub Secrets)
if (-not $DataverseUrl) {
    $DataverseUrl = $env:DATAVERSE_URL_SIT
}

# Use default if not provided
if (-not $DataverseUrl) {
    $DataverseUrl = "https://ernaehrungundsportdev.crm4.dynamics.com"
}

# Validate required parameters
if (-not $DataverseUrl) {
    Write-Host "Missing Dataverse URL" -ForegroundColor Red
    Write-Host "Set environment variable: DATAVERSE_URL_SIT" -ForegroundColor Yellow
    exit 1
}

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Dataverse URL: $DataverseUrl" -ForegroundColor White
Write-Host "  Authentication: Azure CLI (User)" -ForegroundColor White
Write-Host ""

# Function to get OAuth token using Azure CLI (bypasses Conditional Access for user auth)
function Get-DataverseToken {
    param($Resource)
    
    Write-Host "Authenticating to Azure AD via Azure CLI..." -ForegroundColor Yellow
    
    try {
        # Check if Azure CLI is available
        $azVersion = az version 2>$null | ConvertFrom-Json
        Write-Host "  Azure CLI version: $($azVersion.'azure-cli')" -ForegroundColor Gray
    } catch {
        Write-Host "  Failed: Azure CLI not found" -ForegroundColor Red
        Write-Host "  Please install Azure CLI: https://aka.ms/InstallAzureCLI" -ForegroundColor Yellow
        exit 1
    }
    
    try {
        # Get access token using Azure CLI (uses your interactive login)
        $tokenResponse = az account get-access-token --resource $Resource | ConvertFrom-Json
        Write-Host "  Success - Token acquired via user authentication" -ForegroundColor Green
        return $tokenResponse.accessToken
    } catch {
        Write-Host "  Failed: $_" -ForegroundColor Red
        Write-Host "  Please login: az login" -ForegroundColor Yellow
        exit 1
    }
}

# Get access token using Azure CLI (ignores client secret - uses interactive auth)
$accessToken = Get-DataverseToken -Resource $DataverseUrl

# Create output directory
$scriptDir = Split-Path -Parent $PSScriptRoot
$outputPath = Join-Path -Path $scriptDir -ChildPath "dataverse-metadata"
if (-not (Test-Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath | Out-Null
    Write-Host "Created output directory: $outputPath" -ForegroundColor Green
}
Write-Host ""

# Headers for API requests
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Accept" = "application/json"
    "OData-MaxVersion" = "4.0"
    "OData-Version" = "4.0"
    "Content-Type" = "application/json"
}

# Function to fetch entity metadata
function Get-EntityMetadata {
    param($LogicalName, $Headers, $BaseUrl)
    
    Write-Host "Fetching metadata for: $LogicalName" -ForegroundColor Yellow
    
    $apiUrl = "$BaseUrl/api/data/v9.2/EntityDefinitions(LogicalName='$LogicalName')?`$expand=Attributes,Keys"
    
    try {
        $response = Invoke-RestMethod -Method Get -Uri $apiUrl -Headers $Headers
        Write-Host "  Success" -ForegroundColor Green
        return $response
    } catch {
        Write-Host "  Failed: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Fetch metadata for each table
Write-Host "Fetching table metadata..." -ForegroundColor Cyan
Write-Host ""

foreach ($table in $tables) {
    $metadata = Get-EntityMetadata -LogicalName $table -Headers $headers -BaseUrl $DataverseUrl
    
    if ($metadata) {
        $outputFile = Join-Path -Path $outputPath -ChildPath "$table.json"
        $metadata | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputFile -Encoding UTF8
        Write-Host "  Saved to: $outputFile" -ForegroundColor Gray
    }
    
    Write-Host ""
}

# Generate markdown documentation
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Generating Documentation" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$markdownFile = Join-Path -Path $outputPath -ChildPath "documentation.md"
$markdown = @()
$markdown += "# Dataverse Tables - Detailed Metadata"
$markdown += ""
$markdown += "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$markdown += "Environment: $DataverseUrl"
$markdown += ""
$markdown += "---"
$markdown += ""

foreach ($table in $tables) {
    $jsonFile = Join-Path -Path $outputPath -ChildPath "$table.json"
    
    if (Test-Path $jsonFile) {
        Write-Host "Processing: $table" -ForegroundColor Yellow
        
        try {
            $data = Get-Content $jsonFile -Raw | ConvertFrom-Json
            
            $markdown += "## Table: $($data.LogicalName)"
            $markdown += ""
            
            if ($data.DisplayName.UserLocalizedLabel) {
                $markdown += "**Display Name**: $($data.DisplayName.UserLocalizedLabel.Label)"
            }
            if ($data.SchemaName) {
                $markdown += "**Schema Name**: $($data.SchemaName)"
            }
            if ($data.EntitySetName) {
                $markdown += "**Entity Set Name**: $($data.EntitySetName)"
            }
            if ($data.PrimaryIdAttribute) {
                $markdown += "**Primary Key**: $($data.PrimaryIdAttribute)"
            }
            if ($data.PrimaryNameAttribute) {
                $markdown += "**Primary Name**: $($data.PrimaryNameAttribute)"
            }
            
            $markdown += ""
            $markdown += "### Key Attributes"
            $markdown += ""
            
            # Filter and display important attributes
            $importantAttrs = $data.Attributes | Where-Object { 
                $_.LogicalName -notmatch "^(createdon|modifiedon|createdby|modifiedby|versionnumber|ownerid|owningbusinessunit|statecode|statuscode|importsequencenumber|overriddencreatedon|timezoneruleversionnumber|utcconversiontimezonecode)$"
            }
            
            foreach ($attr in $importantAttrs) {
                $displayName = if ($attr.DisplayName.UserLocalizedLabel) { $attr.DisplayName.UserLocalizedLabel.Label } else { "N/A" }
                $description = if ($attr.Description.UserLocalizedLabel) { $attr.Description.UserLocalizedLabel.Label } else { "" }
                $required = if ($attr.RequiredLevel.Value -match "Required") { "**Required**" } else { "Optional" }
                $attrType = $attr.AttributeTypeName.Value
                
                $markdown += "#### $($attr.LogicalName)"
                $markdown += "- **Display Name**: $displayName"
                $markdown += "- **Type**: $attrType"
                $markdown += "- **Requirement**: $required"
                if ($description) {
                    $markdown += "- **Description**: $description"
                }
                
                # Add lookup target if it's a lookup field
                if ($attr.'@odata.type' -eq '#Microsoft.Dynamics.CRM.LookupAttributeMetadata' -and $attr.Targets) {
                    $targets = $attr.Targets -join ", "
                    $markdown += "- **Lookup Target(s)**: $targets"
                }
                
                # Add option set values if it's a picklist
                if ($attr.'@odata.type' -eq '#Microsoft.Dynamics.CRM.PicklistAttributeMetadata' -and $attr.OptionSet.Options) {
                    $markdown += "- **Options**:"
                    foreach ($option in $attr.OptionSet.Options) {
                        $optionLabel = if ($option.Label.UserLocalizedLabel) { $option.Label.UserLocalizedLabel.Label } else { "N/A" }
                        $markdown += "  - $($option.Value): $optionLabel"
                    }
                }
                
                $markdown += ""
            }
            
            $markdown += "---"
            $markdown += ""
            
        } catch {
            Write-Host "  Error processing table: $_" -ForegroundColor Red
        }
    }
}

$markdown | Out-File -FilePath $markdownFile -Encoding UTF8
Write-Host "Documentation generated: $markdownFile" -ForegroundColor Green

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Export Complete!" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Output files:" -ForegroundColor Yellow
Write-Host "  JSON metadata: $outputPath" -ForegroundColor White
Write-Host "  Documentation: $markdownFile" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review the generated documentation" -ForegroundColor White
Write-Host "  2. Update DATAVERSE.md with accurate field information" -ForegroundColor White
