# Ernährung & Sport Counselling PCF Control - Project Instructions

## Project Type
Power Apps Component Framework (PCF) custom control for Model-Driven Apps

## Technology Stack
- **Framework**: Power Apps Component Framework (PCF)
- **UI**: React 18 with Fluent UI
- **Language**: TypeScript
- **Deployment**: Dataverse environment

## Project Structure
- `NutritionSportControl/` - Main control implementation
  - `index.ts` - PCF control entry point
  - `NutritionSportApp.tsx` - React UI component
  - `ControlManifest.Input.xml` - Control manifest

## Development Workflow

### Build Commands
- `npm run build` - Build the control
- `npm run start:watch` - Development with auto-reload
- `npm start` - Test in browser harness

### Key Files
- **index.ts**: PCF control lifecycle (init, updateView, getOutputs, destroy)
- **NutritionSportApp.tsx**: React component with Fluent UI
- **ControlManifest.Input.xml**: Control metadata and properties

## Important Notes
- Uses React 18 `createRoot` API (not legacy `ReactDOM.render`)
- Fluent UI icons initialized in `init()` method
- Control stores counselling data in `sampleProperty` field
- Watch task runs on port 8181

## Deployment to Dataverse
1. Create PAC solution
2. Add control reference
3. Build MSBuild solution
4. Import to Dataverse environment

Work through each checklist item systematically. Keep communication concise and focused. Follow development best practices.
