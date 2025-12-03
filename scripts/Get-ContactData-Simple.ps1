#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Fetches real data from Dataverse and saves as JSON files.

.DESCRIPTION
    Simple script that retrieves data from Dataverse and saves raw JSON responses per entity type.
    Uses Azure CLI authentication to bypass Conditional Access policies.

.PARAMETER ContactId
    The contact ID to fetch data for.

.EXAMPLE
    .\Get-ContactData-Simple.ps1 -ContactId "1860f1d6-0af2-ef11-be1f-000d3ab2b425"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ContactId,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputDir = ".\dataverse-data"
)

$ErrorActionPreference = "Stop"

# Ensure output directory exists
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

Write-Host "Fetching data for Contact ID: $ContactId" -ForegroundColor Cyan

# Get access token using Azure CLI
Write-Host "Getting access token..." -ForegroundColor Yellow
$token = az account get-access-token --resource=https://ernaehrungundsportdev.crm4.dynamics.com --query accessToken -o tsv

if (-not $token) {
    throw "Failed to get access token. Please run 'az login' first."
}

$headers = @{
    "Authorization" = "Bearer $token"
    "Accept" = "application/json"
    "OData-MaxVersion" = "4.0"
    "OData-Version" = "4.0"
}

$baseUrl = "https://ernaehrungundsportdev.crm4.dynamics.com/api/data/v9.2"

# Fetch Contact data
Write-Host "Fetching contact data..." -ForegroundColor Yellow
$contactUrl = "$baseUrl/contacts($ContactId)?`$select=contactid,firstname,lastname,fullname,emailaddress1,telephone1,mobilephone,birthdate,gendercode"
try {
    $contactResponse = Invoke-RestMethod -Uri $contactUrl -Headers $headers -Method Get
    $contactResponse | ConvertTo-Json -Depth 10 | Out-File "$OutputDir\contact_$ContactId.json" -Encoding UTF8
    Write-Host "[OK] Contact data saved to: contact_$ContactId.json" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to fetch contact: $_" -ForegroundColor Red
}

# Fetch NutritionCounselling records for this contact
Write-Host "Fetching nutrition counselling records..." -ForegroundColor Yellow
$counsellingFilter = "`$filter=_ur_member_value eq $ContactId"
$counsellingUrl = '{0}/ur_nutritioncounsellings?{1}' -f $baseUrl, $counsellingFilter
try {
    $counsellingResponse = Invoke-RestMethod -Uri $counsellingUrl -Headers $headers -Method Get
    $counsellingResponse.value | ConvertTo-Json -Depth 10 | Out-File "$OutputDir\nutritioncounselling_$ContactId.json" -Encoding UTF8
    Write-Host "[OK] Nutrition counselling data saved to: nutritioncounselling_$ContactId.json" -ForegroundColor Green
    Write-Host "  Found $($counsellingResponse.value.Count) counselling record(s)" -ForegroundColor Gray
} catch {
    Write-Host "[ERROR] Failed to fetch nutrition counselling: $_" -ForegroundColor Red
}

# Fetch NutritionDiary records for this contact
Write-Host "Fetching nutrition diary records..." -ForegroundColor Yellow
$diaryFilter = "`$filter=_ur_member_value eq $ContactId"
$diaryUrl = '{0}/ur_nutritiondiaries?{1}' -f $baseUrl, $diaryFilter
try {
    $diaryResponse = Invoke-RestMethod -Uri $diaryUrl -Headers $headers -Method Get
    $diaryResponse.value | ConvertTo-Json -Depth 10 | Out-File "$OutputDir\nutritiondiary_$ContactId.json" -Encoding UTF8
    Write-Host "[OK] Nutrition diary data saved to: nutritiondiary_$ContactId.json" -ForegroundColor Green
    Write-Host "  Found $($diaryResponse.value.Count) diary record(s)" -ForegroundColor Gray
} catch {
    Write-Host "[ERROR] Failed to fetch nutrition diary: $_" -ForegroundColor Red
}

# Fetch NutritionLog records for this contact
Write-Host "Fetching nutrition log records..." -ForegroundColor Yellow
$logFilter = "`$filter=_ur_member_value eq $ContactId"
$logUrl = '{0}/ur_nutritionlogs?{1}' -f $baseUrl, $logFilter
try {
    $logResponse = Invoke-RestMethod -Uri $logUrl -Headers $headers -Method Get
    $logResponse.value | ConvertTo-Json -Depth 10 | Out-File "$OutputDir\nutritionlog_$ContactId.json" -Encoding UTF8
    Write-Host "[OK] Nutrition log data saved to: nutritionlog_$ContactId.json" -ForegroundColor Green
    Write-Host "  Found $($logResponse.value.Count) log record(s)" -ForegroundColor Gray
} catch {
    Write-Host "[ERROR] Failed to fetch nutrition log: $_" -ForegroundColor Red
}

# Fetch SmartGoal records for this contact
Write-Host "Fetching SMART goal records..." -ForegroundColor Yellow
$goalFilter = "`$filter=_regardingobjectid_value eq $ContactId"
$goalSelect = "`$select=activityid,subject,description,scheduledstart,scheduledend,statecode,statuscode,prioritycode"
$goalUrl = '{0}/ur_smartgoals?{1}&{2}' -f $baseUrl, $goalFilter, $goalSelect
try {
    $goalResponse = Invoke-RestMethod -Uri $goalUrl -Headers $headers -Method Get
    $goalResponse.value | ConvertTo-Json -Depth 10 | Out-File "$OutputDir\smartgoal_$ContactId.json" -Encoding UTF8
    Write-Host "[OK] SMART goal data saved to: smartgoal_$ContactId.json" -ForegroundColor Green
    Write-Host "  Found $($goalResponse.value.Count) goal record(s)" -ForegroundColor Gray
} catch {
    Write-Host "[ERROR] Failed to fetch SMART goals: $_" -ForegroundColor Red
}

Write-Host "`n[OK] Data export completed! Files saved to: $OutputDir" -ForegroundColor Green
