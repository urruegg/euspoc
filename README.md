# Ernährung & Sport Counselling PCF Control

Power Apps Component Framework (PCF) custom control for tracking nutrition and sport counselling sessions in Model-Driven Apps.

## Project Overview

This project contains a React-based PCF control built with Fluent UI that visualizes and manages counselling work for nutrition and sport consultations. The control is designed to be deployed to Dataverse environments.

## Features

- **Nutrition Notes**: Track detailed nutrition counselling information
- **Exercise Notes**: Document sport and exercise recommendations
- **Goals Tracking**: Set and monitor client goals
- **Fluent UI Integration**: Modern, accessible interface using Microsoft's Fluent UI components
- **React-based**: Built with React 18 and TypeScript

## Technology Stack

- **Framework**: Power Apps Component Framework (PCF)
- **UI Library**: Fluent UI React (@fluentui/react)
- **Language**: TypeScript
- **Build Tool**: PCF Scripts
- **Package Manager**: npm

## Prerequisites

- Node.js (v18 or later)
- Power Apps CLI (PAC CLI)
- Visual Studio Code (recommended)

## Getting Started

### Installation

Dependencies are already installed. If you need to reinstall:

```powershell
npm install
```

### Development

Start the watch mode to see live changes:

```powershell
npm run start:watch
```

This will:
- Compile and bundle the control
- Start a local test harness
- Watch for file changes and auto-rebuild

### Building

Build the control for production:

```powershell
npm run build
```

### Testing

Test the control locally:

```powershell
npm start
```

This opens a browser test harness where you can interact with the control.

## Project Structure

```
euspoc/
├── src/
│   └── NutritionCounsellingControl/  # Main control folder
│       ├── index.ts                  # PCF control implementation
│       ├── NutritionSportApp.tsx     # React component
│       ├── ControlManifest.Input.xml # Control manifest
│       └── generated/                # Auto-generated types
├── docs/                             # Dataverse table documentation
│   ├── DATAVERSE_CONTACT_ACTUAL.md
│   ├── DATAVERSE_NUTRITIONDIARY_ACTUAL.md
│   ├── DATAVERSE_NUTRITIONLOG_ACTUAL.md
│   ├── DATAVERSE_SMARTGOAL_ACTUAL.md
│   └── DATAVERSE_NUTRITIONCOUNSELLING_ACTUAL.md
├── scripts/                          # PowerShell scripts
│   ├── Export-DataverseMetadata.ps1
│   └── Verify-Dataverse-App-User.ps1
├── dataverse-metadata/               # Exported JSON metadata (gitignored)
├── .github/
│   ├── copilot-instructions.md       # GitHub Copilot instructions
│   └── workflows/
│       └── export-metadata.yml       # Metadata export workflow
├── package.json                      # Project dependencies
└── tsconfig.json                     # TypeScript configuration
```

## Deployment to Dataverse

### 1. Create Solution Package

```powershell
pac solution init --publisher-name YourPublisher --publisher-prefix prefix
```

### 2. Add Control to Solution

```powershell
pac solution add-reference --path .
```

### 3. Build Solution

```powershell
msbuild /t:build /restore
```

### 4. Deploy to Environment

```powershell
pac auth create --url https://yourorg.crm.dynamics.com
pac solution import --path bin\Debug\YourSolution.zip
```

## Control Configuration

The control accepts the following property:
- **Client Name** (sampleProperty): Text field for client identification

## Usage in Model-Driven App

1. Deploy the control to your Dataverse environment
2. Open a Model-Driven App form editor
3. Select a text field where you want to use the control
4. In the field properties, choose "Controls" tab
5. Add the "Nutrition Counselling Control"
6. Configure the Client Name property
7. Save and publish the form

## Development Commands

- `npm run build` - Build the control
- `npm run clean` - Clean build artifacts
- `npm run rebuild` - Clean and rebuild
- `npm run start` - Start test harness
- `npm run start:watch` - Start test harness with watch mode
- `npm run lint` - Run ESLint
- `npm run lint:fix` - Fix ESLint issues

## Troubleshooting

### Build Errors

If you encounter build errors:
1. Run `npm run clean`
2. Delete `node_modules` and run `npm install`
3. Run `npm run build`

### Watch Mode Not Working

Ensure port 8181 is not in use by another process.

## Contributing

This is a custom internal project. For questions or issues, contact the development team.

## License

Internal use only.
