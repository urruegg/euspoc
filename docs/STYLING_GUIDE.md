# Styling Guide

This guide explains the common CSS classes available in `App.css` that can be used across components to maintain consistency and reduce code duplication.

## Benefits of Using Common CSS Classes

1. **Maintainability**: Change styling in one place affects all components
2. **Consistency**: Ensures uniform design across the entire app
3. **Performance**: Reduces JavaScript bundle size by using native CSS
4. **DX**: Faster development with pre-defined patterns

## Screen Layout Classes

### `.screen-container`
Standard full-height screen container with neutral background.

```tsx
<div className="screen-container">
  {/* Your screen content */}
</div>
```

**Replaces:**
```tsx
const useStyles = makeStyles({
  container: {
    display: 'flex',
    flexDirection: 'column',
    height: '100%',
    backgroundColor: tokens.colorNeutralBackground2,
  },
})
```

### `.screen-header`
White/neutral header section with standard padding.

```tsx
<div className="screen-header">
  <Text className="page-title">Screen Title</Text>
  <Text className="page-subtitle">Optional subtitle</Text>
</div>
```

### `.brand-header`
Green header with logo and navigation elements.

```tsx
<div className="brand-header">
  <div className="header-left">
    {/* Logo, back button, etc. */}
  </div>
  <div className="header-right">
    {/* Theme toggle, sign out, etc. */}
  </div>
</div>
```

### `.screen-content`
Standard content area with padding and scrolling.

```tsx
<div className="screen-content">
  {/* Your scrollable content */}
</div>
```

### `.screen-content-flex`
Content area with flexbox and gap for card layouts.

```tsx
<div className="screen-content-flex">
  <Card>...</Card>
  <Card>...</Card>
</div>
```

## Typography Classes

| Class | Usage | Style |
|-------|-------|-------|
| `.page-title` | Main page heading | 24px, 600 weight, green |
| `.section-title` | Section headings | 18px, 600 weight |
| `.page-subtitle` | Subtitle/description | 14px, muted color |
| `.option-title` | Card/option title | 16px, 600 weight |
| `.option-description` | Card/option description | 13px, muted color |

## Option Card Pattern

For selection screens (like LogEntryScreen, MoreScreen):

```tsx
<Card className="option-card" onClick={handleClick}>
  <div className="option-card-icon-container">
    <Icon className="option-card-icon" />
  </div>
  <div className="option-card-text">
    <Text className="option-title">Option Title</Text>
    <Text className="option-description">Option description</Text>
  </div>
</Card>
```

## Form Classes

### `.form-section`
Container for form fields with consistent spacing.

```tsx
<Card className="form-section">
  <div className="form-field">
    <Label className="form-label">Field Name</Label>
    <Input />
  </div>
</Card>
```

## Brand Elements

### `.icon-circle`
Standard 64px circular icon container with green background.

```tsx
<div className="icon-circle">
  <Icon />
</div>
```

### `.brand-badge`
Beige badge for counters, labels, etc.

```tsx
<div className="brand-badge">
  <Icon />
  <Text>3 meals</Text>
</div>
```

## Utility Classes

### Flexbox
- `.flex-column` - Vertical flex layout
- `.flex-row` - Horizontal flex layout

### Gaps
- `.gap-4` - 4px gap
- `.gap-8` - 8px gap
- `.gap-12` - 12px gap
- `.gap-16` - 16px gap
- `.gap-24` - 24px gap

### Layout Helpers
- `.header-left` - Left section of headers
- `.header-right` - Right section of headers
- `.header-text` - Text column in headers

## Migration Examples

### Before (Component-specific styles)

```tsx
const useStyles = makeStyles({
  container: {
    display: 'flex',
    flexDirection: 'column',
    height: '100%',
    backgroundColor: tokens.colorNeutralBackground2,
  },
  header: {
    backgroundColor: tokens.colorNeutralBackground1,
    padding: '16px',
    display: 'flex',
    flexDirection: 'column',
    gap: '8px',
  },
  title: {
    fontSize: '24px',
    fontWeight: '600',
    color: '#667653',
  },
  subtitle: {
    fontSize: '14px',
    color: tokens.colorNeutralForeground3,
  },
  content: {
    flex: 1,
    overflowY: 'auto',
    padding: '16px',
  },
})

return (
  <div className={styles.container}>
    <div className={styles.header}>
      <Text className={styles.title}>Title</Text>
      <Text className={styles.subtitle}>Subtitle</Text>
    </div>
    <div className={styles.content}>
      {/* Content */}
    </div>
  </div>
)
```

### After (Using common classes)

```tsx
// No styles needed, or only component-specific styles
const useStyles = makeStyles({
  // Only keep truly unique styles here
  customBehavior: {
    // ...
  }
})

return (
  <div className="screen-container">
    <div className="screen-header">
      <Text className="page-title">Title</Text>
      <Text className="page-subtitle">Subtitle</Text>
    </div>
    <div className="screen-content">
      {/* Content */}
    </div>
  </div>
)
```

## When to Use Common Classes vs makeStyles

### Use Common Classes When:
- ✅ Layout follows standard screen patterns
- ✅ Typography matches design system
- ✅ Styling is reused across multiple components
- ✅ No dynamic/conditional styling needed

### Use makeStyles When:
- ✅ Component has unique layout requirements
- ✅ Need dynamic styling based on props/state
- ✅ Complex animations or interactions
- ✅ Token values need to be accessed programmatically

## Design Tokens in CSS

CSS variables are automatically available from Fluent UI:
- `var(--colorNeutralBackground1)`
- `var(--colorNeutralBackground2)`
- `var(--colorNeutralForeground1)`
- `var(--colorNeutralForeground3)`
- `var(--colorNeutralStroke1)`
- `var(--colorNeutralBackground1Hover)`

## Components That Can Use Common Classes

Recommended for migration:
- ✅ **LogEntryScreen** - Uses standard option card pattern
- ✅ **MoreScreen** - Uses standard option card pattern
- ✅ **LogMealScreen** - Header and content layout
- ✅ **LogExerciseScreen** - Header and content layout
- ⚠️ **HomeScreen** - Partial (brand header only)
- ⚠️ **MealsScreen** - Partial (brand header only)
- ⚠️ **ProfileScreen** - Partial (brand header only)

## Maintaining Consistency

When adding new screens:
1. Use common classes for standard patterns
2. Add new common classes to `App.css` if pattern repeats 3+ times
3. Document new classes in this guide
4. Keep component-specific styles in `makeStyles` only when necessary
