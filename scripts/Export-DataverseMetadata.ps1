# Dataverse Metadata Export Script
# This script exports metadata for custom tables to document the data model

param(
    [string]$Environment = "SIT"
)

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Dataverse Metadata Export Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Define tables to export
$tables = @(
    "contact",
    "ur_nutritiondiary",
    "ur_nutritionlog",
    "ur_smartgoal",
    "ur_nutritioncounseling"
)

# Get authenticated profile
Write-Host "Checking PAC CLI authentication..." -ForegroundColor Yellow
$authList = pac auth list
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Not authenticated. Please run:" -ForegroundColor Red
    Write-Host "pac auth create --url <DATAVERSE_URL> --applicationId <CLIENT_ID> --clientSecret <SECRET>" -ForegroundColor White
    exit 1
}

Write-Host "Authenticated successfully!" -ForegroundColor Green
Write-Host ""

# Create output directory
$outputDir = ".\dataverse-metadata"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
    Write-Host "Created output directory: $outputDir" -ForegroundColor Green
}

# Export metadata for each table
foreach ($table in $tables) {
    Write-Host "Exporting metadata for: $table" -ForegroundColor Yellow
    
    $outputFile = Join-Path $outputDir "$table-metadata.json"
    
    try {
        # Get table metadata using PAC CLI
        $metadata = pac entity show --logicalName $table --json 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            $metadata | Out-File -FilePath $outputFile -Encoding UTF8
            Write-Host "  ✓ Exported to: $outputFile" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Failed to export $table" -ForegroundColor Red
            Write-Host "    Error: $metadata" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ✗ Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Generating Markdown Documentation" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Generate markdown documentation
$markdownFile = Join-Path $outputDir "table-documentation.md"
$markdown = @"
# Dataverse Tables - Detailed Metadata

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

---

"@

foreach ($table in $tables) {
    $jsonFile = Join-Path $outputDir "$table-metadata.json"
    
    if (Test-Path $jsonFile) {
        Write-Host "Processing: $table" -ForegroundColor Yellow
        
        try {
            $data = Get-Content $jsonFile -Raw | ConvertFrom-Json
            
            $markdown += @"

## Table: $($data.LogicalName)

**Display Name**: $($data.DisplayName.UserLocalizedLabel.Label)
**Schema Name**: $($data.SchemaName)
**Table Type**: $($data.TableType)
**Primary Key**: $($data.PrimaryIdAttribute)
**Primary Name**: $($data.PrimaryNameAttribute)

### Attributes

| Logical Name | Display Name | Type | Required | Description |
|--------------|--------------|------|----------|-------------|

"@
            
            foreach ($attribute in $data.Attributes) {
                if ($attribute.LogicalName -notmatch "^(createdon|modifiedon|createdby|modifiedby|versionnumber|ownerid|owningbusinessunit|statecode|statuscode)") {
                    $displayName = if ($attribute.DisplayName.UserLocalizedLabel) { $attribute.DisplayName.UserLocalizedLabel.Label } else { "N/A" }
                    $description = if ($attribute.Description.UserLocalizedLabel) { $attribute.Description.UserLocalizedLabel.Label } else { "N/A" }
                    $required = if ($attribute.RequiredLevel.Value -eq "ApplicationRequired" -or $attribute.RequiredLevel.Value -eq "SystemRequired") { "Yes" } else { "No" }
                    
                    $markdown += "| ``$($attribute.LogicalName)`` | $displayName | $($attribute.AttributeType) | $required | $description |`n"
                }
            }
            
            $markdown += "`n---`n"
            
        } catch {
            Write-Host "  ✗ Error processing $table : $_" -ForegroundColor Red
        }
    }
}

$markdown | Out-File -FilePath $markdownFile -Encoding UTF8
Write-Host "✓ Documentation generated: $markdownFile" -ForegroundColor Green

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Export Complete!" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Output directory: $outputDir" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review the generated JSON files for detailed metadata" -ForegroundColor White
Write-Host "2. Check table-documentation.md for formatted documentation" -ForegroundColor White
Write-Host "3. Update DATAVERSE.md with the relevant information" -ForegroundColor White
