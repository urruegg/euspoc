# Dataverse Metadata Export Scripts

This directory contains scripts to extract and document metadata from Dataverse tables.

## Export-DataverseMetadata.ps1

PowerShell script that exports table metadata from Dataverse and generates documentation.

### Prerequisites

- Power Platform CLI (PAC CLI) installed
- Authenticated to a Dataverse environment

### Authentication

Before running the script, authenticate using one of these methods:

**Using Service Principal (Recommended for CI/CD):**
```powershell
pac auth create --url https://ernaehrungundsportdev.crm4.dynamics.com/ `
  --applicationId 3d3b3321-c407-4097-b32c-099229918877 `
  --clientSecret <SECRET>
```

**Using Interactive Login:**
```powershell
pac auth create --url https://ernaehrungundsportdev.crm4.dynamics.com/
```

### Usage

```powershell
# Run the script
.\scripts\Export-DataverseMetadata.ps1

# Or specify environment parameter
.\scripts\Export-DataverseMetadata.ps1 -Environment "SIT"
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
