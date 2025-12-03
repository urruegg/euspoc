#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Verify Managed Identity registration in Dataverse as Application User

.DESCRIPTION
    Checks if the Web API Managed Identity is registered as an Application User
    in Dataverse and verifies assigned security roles.

.EXAMPLE
    .\verify-dataverse-app-user.ps1
#>

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verify Dataverse Application User" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$webAppName = "ernaehrungundsportapisit"
$resourceGroup = "ernaehrungundsportsit"
$dataverseUrl = "https://ernaehrungundsportdev.crm4.dynamics.com"

# Step 1: Get Managed Identity
Write-Host "Step 1: Getting Managed Identity details..." -ForegroundColor Yellow
try {
    $identity = az webapp identity show `
        --resource-group $resourceGroup `
        --name $webAppName | ConvertFrom-Json
    
    $principalId = $identity.principalId
    $enterpriseApp = az ad sp show --id $principalId | ConvertFrom-Json
    $applicationId = $enterpriseApp.appId
    
    Write-Host "  [OK] Managed Identity found" -ForegroundColor Green
    Write-Host "     Principal ID: $principalId" -ForegroundColor Gray
    Write-Host "     Application ID: $applicationId" -ForegroundColor Gray
    Write-Host "     Display Name: $($enterpriseApp.displayName)" -ForegroundColor Gray
    Write-Host ""
}
catch {
    Write-Host "  [ERROR] Failed to get Managed Identity: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Get Dataverse Access Token
Write-Host "Step 2: Getting Dataverse access token..." -ForegroundColor Yellow
try {
    $tokenResponse = az account get-access-token --resource $dataverseUrl | ConvertFrom-Json
    $accessToken = $tokenResponse.accessToken
    Write-Host "  [OK] Access token acquired" -ForegroundColor Green
    Write-Host ""
}
catch {
    Write-Host "  [ERROR] Failed to get access token: $_" -ForegroundColor Red
    Write-Host "     Make sure you're logged in: az login" -ForegroundColor Yellow
    exit 1
}

# Step 3: Query Application Users
Write-Host "Step 3: Querying Dataverse for Application User..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $accessToken"
        "Accept" = "application/json"
        "OData-MaxVersion" = "4.0"
        "OData-Version" = "4.0"
    }
    
    # Query systemusers for application users with matching applicationid
    $filter = "applicationid eq $applicationId"
    $select = "systemuserid,fullname,applicationid,isdisabled,accessmode,businessunitid"
    $queryUrl = "$dataverseUrl/api/data/v9.2/systemusers?`$filter=$filter`&`$select=$select"
    
    Write-Host "  Query URL: $queryUrl" -ForegroundColor Gray
    
    $response = Invoke-RestMethod -Uri $queryUrl -Method Get -Headers $headers -ContentType "application/json"
    
    if ($response.value -and $response.value.Count -gt 0) {
        $appUser = $response.value[0]
        Write-Host "  [OK] Application User FOUND in Dataverse!" -ForegroundColor Green
        Write-Host "     User ID: $($appUser.systemuserid)" -ForegroundColor Gray
        Write-Host "     Full Name: $($appUser.fullname)" -ForegroundColor Gray
        Write-Host "     Application ID: $($appUser.applicationid)" -ForegroundColor Gray
        Write-Host "     Is Disabled: $($appUser.isdisabled)" -ForegroundColor Gray
        Write-Host "     Access Mode: $($appUser.accessmode)" -ForegroundColor Gray
        Write-Host "     Business Unit ID: $($appUser.businessunitid)" -ForegroundColor Gray
        Write-Host ""
        
        $systemUserId = $appUser.systemuserid
    }
    else {
        Write-Host "  [ERROR] Application User NOT FOUND in Dataverse" -ForegroundColor Red
        Write-Host "     The Managed Identity is not registered as an Application User" -ForegroundColor Yellow
        Write-Host "     Please run the registration steps in register-managed-identity-dataverse.ps1" -ForegroundColor Yellow
        Write-Host ""
        exit 1
    }
}
catch {
    Write-Host "  [ERROR] Failed to query Application Users: $_" -ForegroundColor Red
    Write-Host "     Error details: $($_.Exception.Message)" -ForegroundColor Yellow
    exit 1
}

# Step 4: Query Security Roles
Write-Host "Step 4: Querying assigned security roles..." -ForegroundColor Yellow
try {
    # Query systemuserroles_association to get role assignments
    $expand = "roleid(`$select=roleid,name,businessunitid)"
    $rolesQueryUrl = "$dataverseUrl/api/data/v9.2/systemusers($systemUserId)/systemuserroles_association?`$select=roleid`&`$expand=$expand"
    
    $rolesResponse = Invoke-RestMethod -Uri $rolesQueryUrl -Method Get -Headers $headers -ContentType "application/json"
    
    if ($rolesResponse.value -and $rolesResponse.value.Count -gt 0) {
        Write-Host "  [OK] Security Roles assigned ($($rolesResponse.value.Count) total):" -ForegroundColor Green
        
        $hasSystemAdmin = $false
        $hasImpersonation = $false
        
        foreach ($role in $rolesResponse.value) {
            Write-Host "     - $($role.name) (ID: $($role.roleid))" -ForegroundColor Cyan
            
            if ($role.name -eq "System Administrator") {
                $hasSystemAdmin = $true
            }
        }
        
        Write-Host ""
        
        # Check for System Administrator role
        if ($hasSystemAdmin) {
            Write-Host "  [OK] System Administrator role is assigned" -ForegroundColor Green
            Write-Host "     This role includes 'Act on Behalf of Another User' privilege" -ForegroundColor Gray
            Write-Host ""
        }
        else {
            Write-Host "  [WARNING] System Administrator role NOT assigned" -ForegroundColor Yellow
            Write-Host "     Checking for custom role with impersonation privilege..." -ForegroundColor Yellow
            Write-Host ""
            
            # For custom roles, we'd need to check roleprivileges, but that's complex
            Write-Host "  [INFO] To verify impersonation privilege in custom roles:" -ForegroundColor Cyan
            Write-Host "     1. Go to Power Platform Admin Center" -ForegroundColor Gray
            Write-Host "     2. Settings -> Security -> Security Roles" -ForegroundColor Gray
            Write-Host "     3. Check each role for 'Act on Behalf of Another User' privilege" -ForegroundColor Gray
            Write-Host ""
        }
    }
    else {
        Write-Host "  [WARNING] NO security roles assigned!" -ForegroundColor Yellow
        Write-Host "     The Application User exists but has no permissions" -ForegroundColor Yellow
        Write-Host "     Please assign the 'System Administrator' role or a custom role with required privileges" -ForegroundColor Yellow
        Write-Host ""
    }
}
catch {
    Write-Host "  [ERROR] Failed to query security roles: $_" -ForegroundColor Red
    Write-Host "     Error details: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Step 5: Test Impersonation Privilege
Write-Host "Step 5: Testing impersonation capability..." -ForegroundColor Yellow
try {
    # Try to query with MSCRMCallerID header (this will work if impersonation privilege exists)
    # We'll use a dummy contact ID just to test if the header is accepted
    $testContactId = "00000000-0000-0000-0000-000000000000"
    
    $testHeaders = $headers.Clone()
    $testHeaders["MSCRMCallerID"] = $testContactId
    
    # Query systemusers with impersonation header (should return 401/403 if no privilege)
    $testUrl = "$dataverseUrl/api/data/v9.2/systemusers?`$top=1`&`$select=systemuserid"
    
    try {
        $testResponse = Invoke-RestMethod -Uri $testUrl -Method Get -Headers $testHeaders -ContentType "application/json"
        Write-Host "  [OK] Impersonation header accepted!" -ForegroundColor Green
        Write-Host "     The Application User has 'Act on Behalf of Another User' privilege" -ForegroundColor Gray
        Write-Host ""
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 401 -or $statusCode -eq 403) {
            Write-Host "  [ERROR] Impersonation NOT allowed (Status: $statusCode)" -ForegroundColor Red
            Write-Host "     The Application User lacks 'Act on Behalf of Another User' privilege" -ForegroundColor Yellow
            Write-Host "     Please assign System Administrator role or grant the privilege manually" -ForegroundColor Yellow
            Write-Host ""
        }
        else {
            Write-Host "  [WARNING] Unexpected error testing impersonation: $statusCode" -ForegroundColor Yellow
            Write-Host "     Error: $($_.Exception.Message)" -ForegroundColor Gray
            Write-Host ""
        }
    }
}
catch {
    Write-Host "  [WARNING] Could not test impersonation: $_" -ForegroundColor Yellow
}

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verification Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Managed Identity: " -NoNewline -ForegroundColor Yellow
Write-Host "$($enterpriseApp.displayName)" -ForegroundColor Cyan
Write-Host "Application ID: " -NoNewline -ForegroundColor Yellow
Write-Host "$applicationId" -ForegroundColor Cyan

if ($systemUserId) {
    Write-Host "Dataverse User ID: " -NoNewline -ForegroundColor Yellow
    Write-Host "$systemUserId" -ForegroundColor Cyan
    Write-Host "Registration Status: " -NoNewline -ForegroundColor Yellow
    Write-Host "[REGISTERED]" -ForegroundColor Green
    
    if ($hasSystemAdmin) {
        Write-Host "System Admin Role: " -NoNewline -ForegroundColor Yellow
        Write-Host "[ASSIGNED]" -ForegroundColor Green
        Write-Host "Impersonation Ready: " -NoNewline -ForegroundColor Yellow
        Write-Host "[YES]" -ForegroundColor Green
        Write-Host ""
        
        Write-Host "Configuration Complete! Ready to test API." -ForegroundColor Green
        Write-Host "Next step: Run .\test-smart-goals-direct.ps1" -ForegroundColor Cyan
        Write-Host ""
    }
    else {
        Write-Host "System Admin Role: " -NoNewline -ForegroundColor Yellow
        Write-Host "[NOT ASSIGNED]" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Action Required: Assign System Administrator role in Power Platform Admin Center" -ForegroundColor Yellow
        Write-Host ""
    }
}
else {
    Write-Host "Registration Status: " -NoNewline -ForegroundColor Yellow
    Write-Host "[NOT REGISTERED]" -ForegroundColor Red
    Write-Host ""
    Write-Host "Action Required: Complete registration steps from register-managed-identity-dataverse.ps1" -ForegroundColor Yellow
    Write-Host ""
}

