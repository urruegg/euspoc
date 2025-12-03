# Component Examples & Documentation

This guide shows how to use common Fluent UI components and custom components in your mobile app.

## Table of Contents

1. [Importing Components](#importing-components)
2. [Navigation Components](#navigation-components)
3. [Form Components](#form-components)
4. [Custom Components](#custom-components)
5. [Fluent UI Components](#fluent-ui-components)

---

## Importing Components

```tsx
// Fluent UI Components
import {
  Button,
  Card,
  CardHeader,
  Text,
  Avatar,
  Badge,
  Switch,
  Input,
  Textarea,
  Spinner,
  Dialog,
  Label,
} from '@fluentui/react-components'

// Fluent UI Icons
import {
  Home24Regular,
  Settings24Regular,
  FoodApple24Filled,
  Dumbbell24Filled,
  Camera24Regular,
  Image24Regular,
  Dismiss24Regular,
  CheckmarkCircle24Filled,
  // Browse all icons: https://react.fluentui.dev/?path=/docs/icons-catalog--page
} from '@fluentui/react-icons'

// Custom Components
import { LogEntryScreen } from './components/LogEntryScreen'
import { LogMealScreen } from './components/LogMealScreen'
import { LogExerciseScreen } from './components/LogExerciseScreen'
import { CameraCapture } from './components/CameraCapture'
```

---

## Navigation Components

### MainNavigation (Bottom Navigation Bar)

The app uses a bottom navigation pattern with 5 tabs.

```tsx
interface MainNavigationProps {
  activeTab: 'home' | 'meals' | 'log' | 'charts' | 'more' | 'profile' | 'settings'
  onTabChange: (tab: string) => void
}

// Usage
<MainNavigation activeTab={activeTab} onTabChange={handleTabChange} />
```

**Features:**
- Fixed bottom position
- Large touch targets (48px minimum)
- Active state indication
- Icon + label for each tab
- Central "+" button for quick logging

---

## Form Components

### LogMealScreen

Full-screen modal for logging meals with camera integration.

```tsx
interface LogMealScreenProps {
  onBack: () => void
}

// Usage
<LogMealScreen onBack={() => setShowLogMeal(false)} />
```

**Features:**
- Meal type badge selection (Breakfast, Lunch, Dinner, Snack)
- Date/time picker (pre-filled with current time)
- Description textarea (required)
- Additional notes textarea (optional)
- Camera capture button
- Photo upload button
- Save and Cancel actions

**State Management:**
```tsx
const [selectedMealType, setSelectedMealType] = useState<'Breakfast' | 'Lunch' | 'Dinner' | 'Snack'>('Breakfast')
const [dateTime, setDateTime] = useState<string>('')
const [description, setDescription] = useState<string>('')
const [notes, setNotes] = useState<string>('')
const [capturedImage, setCapturedImage] = useState<string | null>(null)
```

### LogExerciseScreen

Full-screen modal for logging exercise activities.

```tsx
interface LogExerciseScreenProps {
  onBack: () => void
}

// Usage
<LogExerciseScreen onBack={() => setShowLogExercise(false)} />
```

**Features:**
- Sport type badge selection (Running, Cycling, Swimming, Walking, Gym, Yoga, Other)
- Start time and duration fields
- Cardio metrics (Avg/Max heart rate, Calories)
- Macronutrient distribution fields
- Description/notes textarea
- Save and Cancel actions

**State Management:**
```tsx
const [sportType, setSportType] = useState<string>('Running')
const [startTime, setStartTime] = useState<string>('')
const [duration, setDuration] = useState<string>('')
const [avgHeartRate, setAvgHeartRate] = useState<string>('')
const [maxHeartRate, setMaxHeartRate] = useState<string>('')
const [calories, setCalories] = useState<string>('')
const [carbs, setCarbs] = useState<string>('')
const [protein, setProtein] = useState<string>('')
const [fat, setFat] = useState<string>('')
const [notes, setNotes] = useState<string>('')
```

---

## Custom Components

### CameraCapture

Full-screen camera preview component with capture functionality.

```tsx
interface CameraCaptureProps {
  onCapture: (imageDataUrl: string) => void
  onCancel: () => void
}

// Usage
<CameraCapture
  onCapture={(imageDataUrl) => {
    setCapturedImage(imageDataUrl)
    setShowCamera(false)
  }}
  onCancel={() => setShowCamera(false)}
/>
```

**Features:**
- Full-screen camera preview
- Live video stream
- Large circular capture button
- Cancel button
- Automatic camera cleanup
- Uses MediaDevices API with fallback

**Implementation Details:**
```tsx
const handlePhoto = () => {
  if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
    setShowCamera(true) // Opens CameraCapture component
  } else {
    // Fallback to file input
    cameraInputRef.current?.click()
  }
}
```

### LogEntryScreen

Landing page for choosing between meal and exercise logging.

```tsx
interface LogEntryScreenProps {
  onLogMeal: () => void
  onLogExercise: () => void
}

// Usage
<LogEntryScreen
  onLogMeal={() => setShowLogMeal(true)}
  onLogExercise={() => setShowLogExercise(true)}
/>
```

**Features:**
- Two large clickable cards
- Food icon for Log Meal
- Dumbbell icon for Log Exercise
- Clear descriptions
- Touch-friendly design

---

## Fluent UI Components

### Badge (Toggle Selection)

Used for single-select options like meal types and sport types.

```tsx
// Badge Group Container
<div className={styles.badgeGroup}>
  {options.map((option) => (
    <Badge
      key={option}
      className={styles.badge}
      appearance="outline"
      style={{
        backgroundColor: selected === option ? '#667653' : 'transparent',
        color: selected === option ? '#ffffff' : tokens.colorNeutralForeground1,
        borderColor: selected === option ? '#667653' : tokens.colorNeutralStroke1,
      }}
      onClick={() => setSelected(option)}
    >
      {option}
    </Badge>
  ))}
</div>

// Styles
const useStyles = makeStyles({
  badgeGroup: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: '8px',
    width: '100%',
  },
  badge: {
    cursor: 'pointer',
    fontSize: '14px',
    padding: '12px 16px',
    borderRadius: '16px',
    userSelect: 'none',
  },
})
```

### Button Variants

```tsx
// Primary button
<Button appearance="primary">Primary Action</Button>

// Secondary button
<Button appearance="secondary">Secondary Action</Button>

// Outline button
<Button appearance="outline">Outline Button</Button>

// Subtle button
<Button appearance="subtle">Subtle Action</Button>

// Transparent button (for navigation)
<Button appearance="transparent">Transparent</Button>

// With icon
<Button icon={<Home24Regular />}>Home</Button>

// Icon only
<Button icon={<Settings24Regular />} />

// Disabled state
<Button disabled>Disabled</Button>

// Full width (good for mobile)
<Button style={{ width: '100%' }}>Full Width Button</Button>
```

## Cards

```tsx
<Card>
  <CardHeader
    image={<Avatar name="User Name" />}
    header={<Text weight="semibold">Card Title</Text>}
    description={<Caption1>Card description text</Caption1>}
  />
  <Body1>
    Card content goes here. Cards are great for organizing
    information in mobile apps.
  </Body1>
</Card>
```

## Input Fields

```tsx
// Text input
<Input
  placeholder="Enter text..."
  value={value}
  onChange={(e) => setValue(e.target.value)}
/>

// Textarea
<Textarea
  placeholder="Enter longer text..."
  rows={4}
  value={text}
  onChange={(e) => setText(e.target.value)}
/>
```

## Toggle Switch

```tsx
<Switch
  checked={isEnabled}
  onChange={(e, data) => setIsEnabled(data.checked)}
  label="Enable feature"
/>
```

## Loading Spinner

```tsx
// Default spinner
<Spinner />

// With label
<Spinner label="Loading..." />

// Different sizes
<Spinner size="tiny" />
<Spinner size="small" />
<Spinner size="medium" />
<Spinner size="large" />
```

## Avatar

```tsx
// With initials
<Avatar name="John Doe" />

// With image
<Avatar image={{ src: 'path/to/image.jpg' }} />

// Different sizes
<Avatar size={24} />
<Avatar size={32} />
<Avatar size={48} />
<Avatar size={64} />

// Colored
<Avatar color="brand" />
<Avatar color="colorful" />
```

## Badge

```tsx
<Badge>New</Badge>
<Badge appearance="filled">5</Badge>
<Badge appearance="outline">Info</Badge>
```

## Dialog (Modal)

```tsx
const [open, setOpen] = useState(false)

return (
  <>
    <Button onClick={() => setOpen(true)}>Open Dialog</Button>
    
    <Dialog open={open} onOpenChange={(e, data) => setOpen(data.open)}>
      <DialogSurface>
        <DialogBody>
          <DialogTitle>Dialog Title</DialogTitle>
          <DialogContent>
            Dialog content goes here
          </DialogContent>
          <DialogActions>
            <Button appearance="secondary" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button appearance="primary" onClick={() => setOpen(false)}>
              Confirm
            </Button>
          </DialogActions>
        </DialogBody>
      </DialogSurface>
    </Dialog>
  </>
)
```

## Styling with makeStyles

```tsx
import { makeStyles, tokens } from '@fluentui/react-components'

const useStyles = makeStyles({
  container: {
    padding: '16px',
    backgroundColor: tokens.colorNeutralBackground1,
  },
  title: {
    color: tokens.colorBrandForeground1,
    marginBottom: '12px',
  },
  button: {
    width: '100%',
    marginTop: '8px',
  },
})

function MyComponent() {
  const styles = useStyles()
  
  return (
    <div className={styles.container}>
      <Text className={styles.title}>Title</Text>
      <Button className={styles.button}>Action</Button>
    </div>
  )
}
```

## Mobile-Specific Tips

### Touch-Friendly Sizing
```tsx
// Make buttons larger for easier tapping
<Button style={{ minHeight: '48px', padding: '12px 24px' }}>
  Tap Me
</Button>
```

### Full-Width Inputs
```tsx
<Input style={{ width: '100%' }} />
```

### Spacing
```tsx
// Use consistent spacing between elements
<div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
  <Card>Content 1</Card>
  <Card>Content 2</Card>
  <Card>Content 3</Card>
</div>
```

### Scrollable Content Area
```tsx
<div style={{
  flex: 1,
  overflowY: 'auto',
  padding: '16px',
  WebkitOverflowScrolling: 'touch',
}}>
  {/* Scrollable content */}
</div>
```

## Resources

- Full component documentation: <https://react.fluentui.dev/>
- Icon gallery: <https://react.fluentui.dev/?path=/docs/icons-catalog--page>
- Theme tokens: <https://react.fluentui.dev/?path=/docs/theme-theme--page>
