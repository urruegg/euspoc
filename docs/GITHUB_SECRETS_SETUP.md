# GitHub Secrets Setup for Azure Federated Identity

This document describes how to set up GitHub repository secrets for deploying the PCF control solution using Azure CLI with federated identity credentials (OIDC).

## Overview

The deployment workflow uses Azure Federated Identity to authenticate GitHub Actions to Azure without storing long-lived credentials. This requires:
1. An Azure AD App Registration with federated credentials
2. GitHub repository secrets configured
3. RBAC permissions on the Dataverse environment

## Required Information

### Azure Subscription & Tenant
- **AZURE_SUBSCRIPTION_ID**: `f25df720-ac20-4b05-bb0c-525bc33a6d40`
- **AZURE_TENANT_ID**: `9183a0dc-b45d-4487-b246-54d6782d8f33`
- **Primary Domain**: `teamruegg.com`
- **Work Account**: `urs.ruegg@teamruegg.com`

### Dataverse Environment (SIT)
- **DATAVERSE_URL_SIT**: Your SIT environment URL (e.g., `https://org-sit.crm4.dynamics.com`)

## Setup Steps

### 1. Create Azure AD App Registration

```powershell
# Login to Azure
az login --tenant 9183a0dc-b45d-4487-b246-54d6782d8f33

# Create App Registration
az ad app create --display-name "GitHub Actions - euspoc Deployment"
```

Note the `appId` from the output - this is your **AZURE_CLIENT_ID**.

### 2. Create Service Principal

```powershell
# Create service principal for the app
az ad sp create --id <AZURE_CLIENT_ID>
```

### 3. Configure Federated Credentials

Create a federated credential that trusts GitHub Actions:

```powershell
az ad app federated-credential create \
  --id <AZURE_CLIENT_ID> \
  --parameters '{
    "name": "GitHub-urruegg-euspoc-main",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:urruegg/euspoc:ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'
```

**Important**: The `subject` must match your repository and branch exactly:
- Format: `repo:<owner>/<repo>:ref:refs/heads/<branch>`
- Example: `repo:urruegg/euspoc:ref:refs/heads/main`

### 4. Grant Dataverse Permissions

The service principal needs access to your Dataverse environment:

1. Go to Power Platform Admin Center: https://admin.powerplatform.microsoft.com
2. Select your SIT environment
3. Go to **Settings** → **Users + permissions** → **Application users**
4. Click **+ New app user**
5. Select your app registration
6. Assign security roles:
   - **System Administrator** (for deployment)
   - Or create a custom role with solution import permissions

### 5. Configure GitHub Repository Secrets

Go to your GitHub repository: **Settings** → **Secrets and variables** → **Actions**

Add the following **Repository Secrets**:

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `AZURE_CLIENT_ID` | `<appId from step 1>` | Application (client) ID |
| `AZURE_TENANT_ID` | `9183a0dc-b45d-4487-b246-54d6782d8f33` | Tenant ID (teamruegg.com) |
| `AZURE_SUBSCRIPTION_ID` | `f25df720-ac20-4b05-bb0c-525bc33a6d40` | Subscription ID |
| `DATAVERSE_URL_SIT` | `https://<org-sit>.crm4.dynamics.com` | SIT environment URL |

**Note**: You do NOT need `AZURE_CLIENT_SECRET` when using federated credentials.

### 6. Verify Configuration

Test the setup by running the deployment workflow:

```powershell
# Trigger deployment workflow
gh workflow run "deploy-to-sit.yml" -f run_id=19925884839
```

The workflow will:
1. Authenticate to Azure using federated credentials
2. Get an access token for Dataverse API
3. Check current solution version
4. Import the solution package

## Troubleshooting

### Error: "AADSTS70021: No matching federated identity record found"
- Verify the `subject` in federated credential matches your repo exactly
- Check that the workflow is running from the `main` branch
- Ensure the app ID in the credential matches `AZURE_CLIENT_ID`

### Error: "AADSTS50105: The signed in user is not assigned to a role"
- Grant the service principal permissions in Dataverse (step 4)
- Wait a few minutes for permissions to propagate

### Error: "401 Unauthorized" when calling Dataverse API
- Verify `DATAVERSE_URL_SIT` is correct
- Ensure the app user has been created in Dataverse
- Check that the environment URL doesn't have trailing slash

## Workflow File Changes

The `deploy-to-sit.yml` workflow now uses:

```yaml
- name: Azure Login
  uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    enable-AzPSSession: false
```

This provides Azure CLI authentication for:
- Getting Dataverse API access tokens
- Potential future Azure resource operations

## Security Considerations

✅ **Advantages of Federated Identity**:
- No long-lived secrets stored in GitHub
- Automatic credential rotation
- Scoped to specific repository and branch
- Auditable through Azure AD logs

✅ **Best Practices**:
- Use separate app registrations for SIT and PROD
- Limit federated credentials to specific branches
- Review app permissions regularly
- Monitor deployment logs for unauthorized access

## References

- [Azure AD Workload Identity Federation](https://learn.microsoft.com/azure/active-directory/workload-identities/workload-identity-federation)
- [GitHub Actions Azure Login](https://github.com/Azure/login#login-with-openid-connect-oidc-recommended)
- [Power Platform Admin Center](https://admin.powerplatform.microsoft.com)
