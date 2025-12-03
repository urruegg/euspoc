# Dataverse Scripts

This directory contains scripts for Dataverse metadata export and data retrieval.

## Get-ContactData-Simple.ps1

**NEW** - PowerShell script for fetching real production data from Dataverse.

### Purpose
Retrieve actual contact and related nutrition data for testing and realistic mock data generation.

### Usage

```powershell
.\scripts\Get-ContactData-Simple.ps1 -ContactId "1860f1d6-0af2-ef11-be1f-000d3ab2b425"
```

### Features
- ✅ Azure CLI authentication (bypasses Conditional Access policies)
- ✅ Fetches 5 entity types in a single execution
- ✅ Saves raw JSON responses per entity
- ✅ Uses correct OData filter syntax for Dataverse Web API

### Entity Types Fetched

1. **Contact** - Demographics (name, birthdate, gender)
2. **Nutrition Counselling** (`ur_nutritioncounselling`) - BMR, TDEE, weight, activity level
3. **Nutrition Diary** (`ur_nutritiondiary`) - Food diary entries
4. **Nutrition Log** (`ur_nutritionlog`) - Nutrition tracking logs
5. **SMART Goals** (`ur_smartgoal`) - Related goals

### Output Location

`./dataverse-data/` directory:
- `contact_<ContactId>.json`
- `nutritioncounselling_<ContactId>.json`
- `nutritiondiary_<ContactId>.json`
- `nutritionlog_<ContactId>.json`
- `smartgoal_<ContactId>.json`

### Latest Execution (Dec 3, 2025)

```
Contact: Urs Rüegg (58M)
Weight: 91 kg
BMR: 2184 kcal
TDEE: 2839 kcal
Activity: LightlyActive (315810001)

Records Found:
- 1 counselling session
- 1 nutrition diary
- 8 nutrition logs
- 0 SMART goals
```

---

## Export-DataverseMetadata.ps1

PowerShell script that exports table metadata from Dataverse using OAuth authentication and the Web API.

### Prerequisites

Required GitHub Secrets / Environment Variables:
- `DATAVERSE_URL_SIT` - Dataverse environment URL
- `DATAVERSE_CLIENT_ID_SIT` - Azure AD App Registration Client ID  
- `DATAVERSE_CLIENT_SECRET_SIT` - Azure AD App Registration Client Secret
- `DATAVERSE_TENANT_ID_SIT` - Azure AD Tenant ID

### Usage

**Via GitHub Actions (Recommended):**

Due to Conditional Access policies, running via GitHub Actions is recommended:

1. Go to https://github.com/urruegg/euspoc/actions
2. Select "Export Dataverse Metadata" workflow
3. Click "Run workflow" button
4. Wait for completion and review the committed metadata files

**Local Execution (may be blocked by Conditional Access):**

```powershell
$env:DATAVERSE_URL_SIT = "https://ernaehrungundsportdev.crm4.dynamics.com"
$env:DATAVERSE_CLIENT_ID_SIT = "3d3b3321-c407-4097-b32c-099229918877"
$env:DATAVERSE_TENANT_ID_SIT = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$env:DATAVERSE_CLIENT_SECRET_SIT = "<your-secret>"
.\scripts\Export-DataverseMetadata.ps1
```

### Output

The script generates the following files in the `dataverse-metadata/` directory:

- **JSON files**: Raw metadata for each table (e.g., `contact-metadata.json`)
- **table-documentation.md**: Formatted markdown documentation with table structures

### Tables Exported

1. `contact` - Standard contact table
2. `ur_nutritiondiary` - Nutrition diary entries
3. `ur_nutritionlog` - Nutrition assessment logs
4. `ur_smartgoal` - SMART goals tracking
5. `ur_nutritioncounseling` - Counseling sessions

### Example Output

The script will:
1. ✓ Authenticate with Dataverse
2. ✓ Export metadata for each table as JSON
3. ✓ Generate formatted markdown documentation
4. ✓ Display summary and next steps

### Updating DATAVERSE.md

After running the script:

1. Review `dataverse-metadata/table-documentation.md`
2. Extract relevant field information
3. Update the main `DATAVERSE.md` with accurate metadata
4. Commit changes to repository

### Troubleshooting

**Error: "Not authenticated"**
- Run `pac auth list` to check authentication
- Create new auth profile using commands above

**Error: "Table not found"**
- Verify table logical names are correct
- Ensure you have permissions to read table metadata

**Error: "pac command not found"**
- Install Power Platform CLI: https://aka.ms/PowerAppsCLI
- Restart PowerShell after installation

### Notes

- The `dataverse-metadata/` folder is git-ignored
- Run this script periodically to keep documentation in sync
- Use in CI/CD pipelines for automated documentation updates
