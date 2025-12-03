# Dataverse Configuration and Data Model

This document contains Dataverse-specific information for the Nutrition & Sport Counselling PCF Control project.

## Table of Contents
- [Environment Configuration](#environment-configuration)
- [GitHub Secrets](#github-secrets)
- [Data Model](#data-model)
- [Authentication](#authentication)
- [Deployment](#deployment)

## Environment Configuration

### SIT (System Integration Testing) Environment

- **Environment URL**: `https://ernaehrungundsportdev.crm4.dynamics.com/`
- **Region**: Europe (CRM4)
- **Purpose**: Development and testing environment

## GitHub Secrets

The following secrets are configured in the GitHub repository for automated deployments:

| Secret Name | Environment | Value | Description |
|-------------|-------------|-------|-------------|
| `DATAVERSE_CLIENT_ID_SIT` | SIT | `3d3b3321-c407-4097-b32c-099229918877` | Dataverse application user for SIT org |
| `DATAVERSE_CLIENT_SECRET_SIT` | SIT | _Stored securely in GitHub_ | OAuth secret for the SIT Dataverse app user |
| `DATAVERSE_URL_SIT` | SIT | `https://ernaehrungundsportdev.crm4.dynamics.com/` | Base URL for SIT org |

### Using GitHub Secrets in Workflows

```yaml
- name: Authenticate to Dataverse
  run: |
    pac auth create --url ${{ secrets.DATAVERSE_URL_SIT }} `
      --applicationId ${{ secrets.DATAVERSE_CLIENT_ID_SIT }} `
      --clientSecret ${{ secrets.DATAVERSE_CLIENT_SECRET_SIT }}
```

## Data Model

The PCF Control integrates with the following Dataverse tables:

### Core Tables

#### 1. **contact**
Standard Dataverse table for client information.

**Key Fields Used:**
- `contactid` - Primary key
- `fullname` - Client full name
- `emailaddress1` - Primary email
- `telephone1` - Primary phone

**Purpose**: Stores basic client information for counselling sessions.

---

#### 2. **ur_nutritiondiary**
Custom table for tracking daily nutrition entries.

**Logical Name**: `ur_nutritiondiary`  
**Display Name**: Nutrition Diary

**Key Fields:**
- `ur_nutritiondiaryid` - Primary key (GUID)
- `ur_name` - Diary entry name/title
- `ur_date` - Date of entry (DateTime)
- `ur_contact` - Lookup to Contact (Many-to-One)
- `ur_meals` - Meal details (Multi-line Text)
- `ur_totalcalories` - Total calories (Whole Number)
- `ur_notes` - Additional notes (Multi-line Text)

**Purpose**: Daily food diary and meal tracking for clients.

---

#### 3. **ur_nutritionlog**
Custom table for logging nutrition assessments and recommendations.

**Logical Name**: `ur_nutritionlog`  
**Display Name**: Nutrition Log

**Key Fields:**
- `ur_nutritionlogid` - Primary key (GUID)
- `ur_name` - Log entry name
- `ur_logdate` - Date of nutrition assessment (DateTime)
- `ur_contact` - Lookup to Contact (Many-to-One)
- `ur_assessment` - Nutrition assessment details (Multi-line Text)
- `ur_recommendations` - Nutritionist recommendations (Multi-line Text)
- `ur_nutritioncounseling` - Lookup to Nutrition Counseling session (Many-to-One)

**Purpose**: Professional nutrition assessment logs and recommendations.

---

#### 4. **ur_smartgoal**
Custom table for SMART goals tracking.

**Logical Name**: `ur_smartgoal`  
**Display Name**: SMART Goal

**Key Fields:**
- `ur_smartgoalid` - Primary key (GUID)
- `ur_name` - Goal name
- `ur_contact` - Lookup to Contact (Many-to-One)
- `ur_specific` - Specific goal description (Multi-line Text)
- `ur_measurable` - Measurable criteria (Multi-line Text)
- `ur_achievable` - Achievable assessment (Multi-line Text)
- `ur_relevant` - Relevance description (Multi-line Text)
- `ur_timebound` - Time-bound deadline (DateTime)
- `ur_status` - Goal status (Option Set)
  - Values: Not Started (0), In Progress (1), Completed (2), On Hold (3)
- `ur_progress` - Progress percentage (Whole Number, 0-100)
- `ur_nutritioncounseling` - Lookup to Nutrition Counseling session (Many-to-One)

**Purpose**: Track client SMART goals for nutrition and fitness.

---

#### 5. **ur_nutritioncounseling**
Custom table for counselling sessions.

**Logical Name**: `ur_nutritioncounseling`  
**Display Name**: Nutrition Counseling

**Key Fields:**
- `ur_nutritioncounselingid` - Primary key (GUID)
- `ur_name` - Session name/identifier
- `ur_sessiondate` - Date of counseling session (DateTime)
- `ur_contact` - Lookup to Contact (Many-to-One)
- `ur_nutritionnotes` - Nutrition counselling notes (Multi-line Text)
- `ur_exercisenotes` - Exercise counselling notes (Multi-line Text)
- `ur_sessiongoals` - Goals set during session (Multi-line Text)
- `ur_nextsessiondate` - Next scheduled session (DateTime)
- `ur_sessionstatus` - Session status (Option Set)
  - Values: Scheduled (0), Completed (1), Cancelled (2), No Show (3)
- `ur_counselor` - Lookup to User (counselor/nutritionist)

**Purpose**: Core table for counselling session management used by the PCF Control.

---

### Entity Relationships

```
contact (1) ──→ (N) ur_nutritioncounseling
contact (1) ──→ (N) ur_nutritiondiary
contact (1) ──→ (N) ur_nutritionlog
contact (1) ──→ (N) ur_smartgoal

ur_nutritioncounseling (1) ──→ (N) ur_nutritionlog
ur_nutritioncounseling (1) ──→ (N) ur_smartgoal
```

## PCF Control Integration

### Control Property Binding

The `NutritionCounsellingControl` is designed to be bound to fields in the `ur_nutritioncounseling` table:

**Primary Binding:**
- Bind to a text field (e.g., `ur_name` or custom field)
- Control captures and stores JSON-formatted counselling data

**Data Structure Stored:**
```json
{
  "nutrition": "Detailed nutrition notes...",
  "exercise": "Exercise recommendations...",
  "goals": "Client goals...",
  "timestamp": "2025-12-03T12:00:00Z"
}
```

### Form Integration

Add the PCF Control to the `ur_nutritioncounseling` form:
1. Open the Nutrition Counseling form editor
2. Select a text field for control binding
3. Add "Nutrition Counselling Control"
4. Configure client name lookup from `ur_contact` field

## Authentication

### Service Principal Setup

The application is registered in Azure AD with the following configuration:

- **Application (Client) ID**: `3d3b3321-c407-4097-b32c-099229918877`
- **Authentication Type**: Client Credentials (OAuth 2.0)
- **Permissions**: Dataverse API access

### Power Platform CLI Authentication

```powershell
# Authenticate using service principal
pac auth create `
  --url https://ernaehrungundsportdev.crm4.dynamics.com/ `
  --applicationId 3d3b3321-c407-4097-b32c-099229918877 `
  --clientSecret <SECRET_VALUE>

# Verify authentication
pac auth list

# Select profile if multiple exist
pac auth select --index 1
```

## Deployment

### Manual Deployment

```powershell
# 1. Authenticate
pac auth create --url https://ernaehrungundsportdev.crm4.dynamics.com/ `
  --applicationId 3d3b3321-c407-4097-b32c-099229918877 `
  --clientSecret <SECRET>

# 2. Create solution
pac solution init --publisher-name EUSolutions --publisher-prefix eus

# 3. Add control reference
pac solution add-reference --path .

# 4. Build solution (requires MSBuild)
msbuild /t:build /restore

# 5. Deploy to environment
pac solution import --path bin\Debug\EUSolutions.zip
```

### CI/CD Pipeline

See `.github/workflows/deploy-to-dataverse.yml` for automated deployment configuration.

## Security Roles

Ensure the following security roles have access to custom tables:

- **Nutrition Counselor**: Full CRUD on `ur_nutritioncounseling`, `ur_nutritionlog`, `ur_smartgoal`
- **Client (Basic User)**: Read on own `ur_nutritiondiary` records
- **System Administrator**: Full access to all tables

## Best Practices

1. **Data Validation**: Validate JSON data before storing in Dataverse fields
2. **Field Length**: Ensure text fields have sufficient length for JSON storage (use Multi-line Text)
3. **Relationships**: Maintain referential integrity between tables
4. **Security**: Use column-level security for sensitive health information
5. **Audit**: Enable auditing on counselling-related tables for compliance

## Troubleshooting

### Common Issues

**Issue**: Authentication fails with "AADSTS7000215: Invalid client secret"
- **Solution**: Regenerate client secret and update GitHub secret

**Issue**: Solution import fails
- **Solution**: Verify publisher prefix matches existing solutions

**Issue**: PCF Control not visible in form editor
- **Solution**: Clear browser cache and republish the form

## Additional Resources

- [Power Apps Component Framework Documentation](https://learn.microsoft.com/power-apps/developer/component-framework/)
- [Dataverse Web API Reference](https://learn.microsoft.com/power-apps/developer/data-platform/webapi/reference)
- [GitHub Actions for Power Platform](https://github.com/marketplace/actions/powerplatform-actions)

---

**Last Updated**: December 3, 2025  
**Maintainer**: Development Team
