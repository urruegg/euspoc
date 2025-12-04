# Solution Deployment Plan - PCF Controls to Dataverse

**Document Version:** 1.0  
**Date:** December 4, 2025  
**Status:** Planning  
**Owner:** Ernährung & Sport Development Team

---

## Executive Summary

This document outlines the plan to establish solution artifacts in the project for deploying PCF custom controls to the Dataverse environment using the existing `ernaehrungundsportcomponents` solution.

---

## Current Dataverse Solution Details

### Solution Information

| Property | Value |
|----------|-------|
| **Solution ID** | `003365f4-dfd0-f011-8544-000d3ab24072` |
| **Unique Name** | `ernaehrungundsportcomponents` |
| **Friendly Name** | Ernährung & Sport Components |
| **Description** | Ernährung & Sport solution for custom build controls |
| **Version** | `0.0.0.1` |
| **Is Managed** | `false` (unmanaged solution) |
| **Created In** | Dataverse SIT Environment |

### Publisher Information

| Property | Value |
|----------|-------|
| **Publisher ID** | `8cd163f3-6b7a-4226-88b6-fa68356e47fe` |
| **Unique Name** | `ursruegg` |
| **Friendly Name** | ursruegg |
| **Customization Prefix** | `ur` |

**Note**: The `ur` prefix matches the custom table naming convention already in use (ur_nutritioncounselling, ur_smartgoal, etc.)

---

## Project Structure Plan

### Current State
```
euspoc/
├── src/
│   └── NutritionCounsellingControl/
│       ├── index.ts
│       ├── NutritionSportApp.tsx
│       ├── ControlManifest.Input.xml
│       ├── components/
│       ├── services/
│       ├── types/
│       └── mocks/
├── package.json
├── pcfconfig.json
└── tsconfig.json
```

### Target State
```
euspoc/
├── src/
│   └── NutritionCounsellingControl/
│       └── ... (existing PCF control)
├── solution/
│   ├── Other/
│   │   ├── Solution.xml
│   │   └── Customizations.xml
│   ├── PluginAssemblies/
│   ├── WebResources/
│   ├── Workflows/
│   └── ernaehrungundsportcomponents.cdsproj
├── package.json
├── pcfconfig.json
└── tsconfig.json
```

---

## Implementation Plan

### Phase 1: Initialize Solution Project (30 min)

**Goal**: Create solution project structure using Power Platform CLI

**Tasks**:

1. **Create solution project**
   ```powershell
   # Navigate to project root
   cd c:\Users\urruegg\source\urruegg\euspoc
   
   # Initialize solution project
   pac solution init `
     --publisher-name ursruegg `
     --publisher-prefix ur `
     --outputDirectory solution
   ```

2. **Add PCF control reference to solution**
   ```powershell
   # Add control reference
   pac solution add-reference `
     --path src\NutritionCounsellingControl
   ```

3. **Verify solution structure**
   - Check `solution/` directory created
   - Verify `Other/Solution.xml` contains correct metadata
   - Confirm `ernaehrungundsportcomponents.cdsproj` exists

**Expected Output**:
- `solution/` directory with CDS project structure
- Solution XML files with publisher metadata
- Control reference added to solution

---

### Phase 2: Configure Solution Metadata (15 min)

**Goal**: Align solution metadata with existing Dataverse solution

**Tasks**:

1. **Update Solution.xml**
   - Set `UniqueName` to `ernaehrungundsportcomponents`
   - Set `LocalizedName` to `Ernährung & Sport Components`
   - Set `Version` to `0.0.0.2` (increment from current `0.0.0.1`)
   - Set `Description` to match Dataverse

2. **Configure publisher in cdsproj**
   - Verify `PublisherName` = `ursruegg`
   - Verify `PublisherPrefix` = `ur`

3. **Update project file**
   - Set `SolutionPackageType` to `Unmanaged` (matches Dataverse)
   - Configure build output path

**Files to Modify**:
- `solution/Other/Solution.xml`
- `solution/ernaehrungundsportcomponents.cdsproj`

---

### Phase 3: Build Solution Package (20 min)

**Goal**: Build solution ZIP package for deployment

**Tasks**:

1. **Install MSBuild dependencies**
   ```powershell
   # Ensure .NET SDK is installed
   dotnet --version
   
   # Install Power Platform Build Tools (if not present)
   # Via Visual Studio Installer or standalone
   ```

2. **Build solution**
   ```powershell
   # From project root
   cd solution
   
   # Restore and build
   msbuild /t:restore
   msbuild /p:Configuration=Release
   
   # Or use dotnet
   dotnet build --configuration Release
   ```

3. **Verify output**
   - Check `solution/bin/Release/` for ZIP file
   - Verify ZIP contains control DLL and manifest
   - Validate ZIP structure

**Expected Output**:
- `solution/bin/Release/ernaehrungundsportcomponents.zip`
- Size: ~3-5 MB (includes React bundle)

---

### Phase 4: Test Local Deployment (30 min)

**Goal**: Deploy to Dataverse SIT environment and verify

**Tasks**:

1. **Authenticate to Dataverse**
   ```powershell
   # Using service principal
   pac auth create `
     --url https://ernaehrungundsportdev.crm4.dynamics.com/ `
     --applicationId 3d3b3321-c407-4097-b32c-099229918877 `
     --clientSecret $env:DATAVERSE_CLIENT_SECRET_SIT
   
   # Verify authentication
   pac auth list
   ```

2. **Import solution**
   ```powershell
   # Import to environment
   pac solution import `
     --path solution/bin/Release/ernaehrungundsportcomponents.zip `
     --async `
     --force-overwrite
   
   # Monitor import status
   pac solution list
   ```

3. **Verify in Dataverse**
   - Open https://ernaehrungundsportdev.crm4.dynamics.com
   - Navigate to Solutions
   - Confirm `ernaehrungundsportcomponents` version updated to `0.0.0.2`
   - Check control listed in solution components

4. **Test control on form**
   - Open `ur_nutritioncounselling` form editor
   - Add NutritionCounsellingControl to form
   - Save and publish form
   - Test control in runtime

**Success Criteria**:
- Solution imports without errors
- Version increments to `0.0.0.2`
- Control appears in form editor
- Control renders correctly on form

---

### Phase 5: Automate CI/CD Pipeline (45 min)

**Goal**: Setup GitHub Actions for automated deployment

**Tasks**:

1. **Create build workflow**
   - Create `.github/workflows/build-solution.yml`
   - Configure to build on push to main
   - Upload ZIP artifact

2. **Create deployment workflow**
   - Create `.github/workflows/deploy-to-sit.yml`
   - Configure to deploy on manual trigger or release tag
   - Use GitHub secrets for authentication

3. **Update GitHub secrets**
   - Verify `DATAVERSE_CLIENT_ID_SIT` exists
   - Verify `DATAVERSE_CLIENT_SECRET_SIT` exists
   - Verify `DATAVERSE_URL_SIT` exists

4. **Test workflows**
   - Trigger build workflow
   - Trigger deployment workflow
   - Verify in Dataverse

**Workflow Files to Create**:
- `.github/workflows/build-solution.yml`
- `.github/workflows/deploy-to-sit.yml`

---

### Phase 6: Documentation Updates (20 min)

**Goal**: Update project documentation

**Tasks**:

1. **Update README.md**
   - Add "Solution Deployment" section
   - Document build and deploy commands
   - Add CI/CD badge

2. **Update DATAVERSE.md**
   - Add solution deployment section
   - Document manual deployment steps
   - Add troubleshooting guide

3. **Create CONTRIBUTING.md**
   - Add developer guide for adding new controls
   - Document solution versioning strategy
   - Add testing guidelines

**Files to Update/Create**:
- `README.md`
- `DATAVERSE.md`
- `CONTRIBUTING.md` (new)

---

## Solution Versioning Strategy

### Version Format
`Major.Minor.Patch.Build`

**Example**: `0.0.0.1` → `0.0.0.2` → `0.1.0.0`

### Versioning Rules

| Change Type | Version Increment | Example |
|-------------|-------------------|---------|
| Bug fix, minor change | Patch | 0.0.0.1 → 0.0.0.2 |
| New control added | Minor | 0.0.0.2 → 0.1.0.0 |
| Breaking change | Major | 0.1.0.0 → 1.0.0.0 |
| CI/CD build number | Build | Auto-incremented |

### Current Plan
- **Current Version**: `0.0.0.1` (in Dataverse)
- **Next Version**: `0.0.0.2` (first deployment from solution)
- **When NutritionCounsellingControl is complete**: `0.1.0.0`
- **Production release**: `1.0.0.0`

---

## Control Deployment Process

### For New Controls

1. **Create PCF control** in `src/`
2. **Add reference** to solution project
   ```powershell
   pac solution add-reference --path src\<ControlName>
   ```
3. **Build solution**
4. **Deploy to SIT**
5. **Test**
6. **Increment version**
7. **Deploy to Production**

### For Control Updates

1. **Make changes** in `src/NutritionCounsellingControl/`
2. **Build locally** with `npm run build`
3. **Test in harness** with `npm start`
4. **Build solution** with `msbuild`
5. **Deploy to SIT**
6. **Test in Dataverse**
7. **Commit changes** to git
8. **CI/CD auto-deploys** (if configured)

---

## File Structure Reference

### Solution Project Files

```
solution/
├── Other/
│   ├── Solution.xml                    # Solution metadata
│   ├── Customizations.xml              # Customization metadata
│   └── Relationships/                  # Entity relationships
├── PluginAssemblies/                   # Plugin DLLs (none for PCF)
├── WebResources/                       # Web resources (CSS, JS, images)
├── Workflows/                          # Classic workflows (none)
├── ernaehrungundsportcomponents.cdsproj # MSBuild project file
└── bin/
    ├── Debug/
    │   └── ernaehrungundsportcomponents.zip
    └── Release/
        └── ernaehrungundsportcomponents.zip
```

### Solution.xml Key Elements

```xml
<?xml version="1.0" encoding="utf-8"?>
<ImportExportXml version="9.2" SolutionPackageVersion="9.2">
  <SolutionManifest>
    <UniqueName>ernaehrungundsportcomponents</UniqueName>
    <LocalizedNames>
      <LocalizedName description="Ernährung &amp; Sport Components" languagecode="1033" />
    </LocalizedNames>
    <Descriptions>
      <Description description="Ernährung &amp; Sport solution for custom build controls" languagecode="1033" />
    </Descriptions>
    <Version>0.0.0.2</Version>
    <Managed>0</Managed>
    <Publisher>
      <UniqueName>ursruegg</UniqueName>
      <LocalizedNames>
        <LocalizedName description="ursruegg" languagecode="1033" />
      </LocalizedNames>
    </Publisher>
  </SolutionManifest>
</ImportExportXml>
```

---

## Troubleshooting Guide

### Common Issues

#### Issue 1: Solution import fails - "Publisher mismatch"
**Cause**: Publisher in solution doesn't match Dataverse  
**Solution**: Verify publisher unique name is `ursruegg` and prefix is `ur`

#### Issue 2: Control not appearing in form editor
**Cause**: Solution not published or control not registered  
**Solution**: Republish solution, clear browser cache, refresh form editor

#### Issue 3: Build fails - "MSBuild not found"
**Cause**: .NET SDK or Build Tools not installed  
**Solution**: Install Visual Studio Build Tools 2022 or .NET SDK 6.0+

#### Issue 4: Import fails - "Version conflict"
**Cause**: Solution version same or lower than existing  
**Solution**: Increment version number in Solution.xml

#### Issue 5: Authentication fails
**Cause**: Service principal expired or incorrect secret  
**Solution**: Regenerate secret in Azure AD, update GitHub secret

---

## Security Considerations

### Service Principal Permissions
Required permissions for deployment:
- **System Customizer** role in Dataverse
- **Solution Import** privileges
- **Write** access to custom controls

### Secret Management
- Store secrets in GitHub Secrets (encrypted)
- Never commit secrets to git
- Rotate secrets every 90 days
- Use different service principals for SIT/Production

### Code Signing (Future)
- Consider Authenticode signing for production
- Implement code review process
- Require 2 approvals for production deployments

---

## Next Steps - Implementation Checklist

### Immediate (Today)
- [ ] Initialize solution project with `pac solution init`
- [ ] Add PCF control reference with `pac solution add-reference`
- [ ] Update Solution.xml with correct metadata
- [ ] Build solution locally and verify ZIP creation
- [ ] Test import to Dataverse SIT environment

### Short-term (This Week)
- [ ] Create GitHub Actions workflows
- [ ] Test CI/CD pipeline end-to-end
- [ ] Update documentation (README, DATAVERSE)
- [ ] Add solution deployment to IMPLEMENTATION_PLAN_FR1.md

### Medium-term (Next Week)
- [ ] Establish versioning process
- [ ] Create deployment runbook
- [ ] Setup monitoring for deployment failures
- [ ] Document rollback procedure

---

## Success Metrics

### Technical Metrics
- ✅ Solution builds without errors
- ✅ Solution imports to Dataverse successfully
- ✅ Control deploys and renders on form
- ✅ Version increments correctly
- ✅ CI/CD pipeline runs automatically

### Process Metrics
- **Build Time**: < 2 minutes
- **Deploy Time**: < 5 minutes
- **Total Pipeline**: < 10 minutes
- **Deployment Success Rate**: > 95%

---

## Resources

### Documentation
- [Power Platform CLI Reference](https://learn.microsoft.com/power-platform/developer/cli/reference/solution)
- [Solution Concepts](https://learn.microsoft.com/power-platform/alm/solution-concepts-alm)
- [PCF Packaging](https://learn.microsoft.com/power-apps/developer/component-framework/import-custom-controls)

### Tools
- [Power Platform CLI](https://aka.ms/PowerPlatformCLI)
- [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/)
- [.NET SDK](https://dotnet.microsoft.com/download)

### Related Documents
- [IMPLEMENTATION_PLAN_FR1.md](./IMPLEMENTATION_PLAN_FR1.md)
- [DATAVERSE.md](../DATAVERSE.md)
- [README.md](../README.md)

---

## Approval & Sign-off

- [ ] Technical Lead Review
- [ ] DevOps Review
- [ ] Security Review
- [ ] Ready for Implementation

---

**Document Status**: Draft - Ready for Implementation  
**Last Updated**: December 4, 2025  
**Next Review**: After Phase 1 completion
