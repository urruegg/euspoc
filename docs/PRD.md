# Product Requirements Document (PRD)
# NutritionCounsellingControl - Use Case 1: As-Is Analysis Dashboard

**Document Version:** 1.0  
**Date:** December 3, 2025  
**Status:** Draft  
**Owner:** Ernährung & Sport Development Team

---

## Executive Summary

This PRD defines the first use case implementation for the NutritionCounsellingControl PCF custom control: an **As-Is Analysis Dashboard** that enables nutrition counselors to perform fast, accurate nutritional assessments by consolidating key performance indicators (KPIs) from a member's nutrition diary and detailed food logs.

**Primary Goal:** Reduce As-Is analysis time from ~15-20 minutes to ~3-5 minutes while improving accuracy of target value recommendations.

---

## Table of Contents

1. [Problem Statement](#problem-statement)
2. [Persona & Context](#persona--context)
3. [Business Objectives](#business-objectives)
4. [User Story](#user-story)
5. [Functional Requirements](#functional-requirements)
6. [Data Requirements](#data-requirements)
7. [UI/UX Requirements](#ui-ux-requirements)
8. [Technical Requirements](#technical-requirements)
9. [Success Metrics](#success-metrics)
10. [Out of Scope](#out-of-scope)
11. [Implementation Phases](#implementation-phases)

---

## Problem Statement

### Current State

Nutrition counselors currently need to:
1. Manually review multiple nutrition diary entries across different dates
2. Calculate average daily caloric intake by hand or spreadsheet
3. Manually compute macronutrient distribution percentages
4. Cross-reference with metabolic information stored separately
5. Switch between multiple screens/forms to gather all data
6. Re-calculate totals when date ranges change

**Pain Points:**
- ⏱️ **Time-consuming:** 15-20 minutes per client for As-Is analysis
- ❌ **Error-prone:** Manual calculations lead to mistakes
- 📊 **Fragmented data:** Information scattered across multiple tables
- 🔄 **Repetitive work:** Same calculations done repeatedly
- 📉 **Delays counselling:** Analysis time takes away from actual counselling

### Desired State

A **single-view dashboard** that:
- ✅ Automatically aggregates nutrition data from `ur_nutritiondiary` and `ur_nutritionlog`
- ✅ Displays metabolic information from `contact` table
- ✅ Calculates and visualizes macronutrient distribution
- ✅ Shows daily energy averages with configurable date ranges
- ✅ Enables 3-5 minute As-Is analysis with higher accuracy

---

## Persona & Context

### Primary Persona: Ernährung & Sport Counselor

**Name:** Dominic Gubser  
**Role:** Certified Nutrition & Sports Counselor  
**Experience:** 5+ years in metabolic nutrition counseling  
**Tech Proficiency:** Moderate (comfortable with Dynamics 365 forms, basic Excel)

**Goals:**
- Conduct thorough nutritional assessments efficiently
- Provide evidence-based recommendations
- Track client progress over time
- Maintain high client satisfaction

**Frustrations:**
- Too much time spent on data gathering vs. actual counseling
- Manual calculations prone to errors
- Difficulty spotting trends across time periods
- Lack of visual tools for client education

### Context: As-Is Analysis Phase

**When:** During initial consultation or follow-up sessions  
**Where:** In Model-Driven App, on `ur_nutritioncounselling` form  
**Duration:** Currently 15-20 min, target 3-5 min  
**Frequency:** 3-5 times per day, 15-25 times per week

**Workflow:**
1. Open client's nutrition counselling session record
2. **[USE CASE 1 - As-Is Analysis]** Review member's current nutrition habits
   - Daily caloric intake averages
   - Macronutrient distribution (carbs, fats, protein)
   - Compare against metabolic baseline
3. Document findings in session notes
4. Set target values for To-Be state (Use Case 2 - future)
5. Create SMART goals (Use Case 3 - future)

---

## Business Objectives

### Primary Objectives

1. **Increase Efficiency**
   - **Goal:** Reduce As-Is analysis time by 70% (from 15-20 min to 3-5 min)
   - **Measure:** Time-tracking study with 10 counselors over 2 weeks
   - **Impact:** ~50-60 minutes saved per counselor per day

2. **Improve Accuracy**
   - **Goal:** Reduce calculation errors from ~15% to <2%
   - **Measure:** Spot-check audit of 100 assessments before/after
   - **Impact:** Higher quality recommendations, better client outcomes

3. **Enhance User Satisfaction**
   - **Goal:** Increase counselor NPS from 6.5 to 8.5+
   - **Measure:** Quarterly user satisfaction survey
   - **Impact:** Lower turnover, higher engagement

### Secondary Objectives

4. **Enable Better Decision Making**
   - Visualize trends that were previously hidden
   - Support evidence-based target setting

5. **Reduce Training Time**
   - New counselors can perform accurate analysis faster
   - Less dependency on senior staff for validation

---

## User Story

### Primary User Story

**As a** nutrition counselor  
**I want to** see a consolidated dashboard of a member's current nutritional intake with automatic calculations  
**So that** I can quickly assess their As-Is state and make accurate recommendations  

**Acceptance Criteria:**
- [ ] I can see the member's metabolic information (BMR, TDEE, target calories)
- [ ] I can view daily average energy intake calculated from nutrition diary
- [ ] I can see macronutrient distribution as percentages and grams
- [ ] I can adjust the date range for analysis (last 7, 14, 30 days, custom)
- [ ] All calculations update automatically when date range changes
- [ ] Data is read-only (view-only mode for As-Is analysis)
- [ ] Dashboard loads in <3 seconds for typical dataset (30 days, 90 diary entries)

---

## Functional Requirements

### FR1: Metabolic Information Display

**Priority:** P0 (Must Have)

**Description:**  
Display the member's metabolic baseline information from the `contact` table to provide context on the nutrition counseling `ur_nutritioncounselling` analysis.

**Data Sources:**
- `ur_nutritioncounselling.ur_bmr` - Basal Metabolic Rate (kcal/day) / (calculated field on Dataverse level)
- `ur_nutritioncounselling.ur_tdee` - Total Daily Energy Expenditure (kcal/day) / (calculated field on Dataverse level)
- `ur_nutritioncounselling.ur_targetcalories` - Target daily caloric intake (kcal/day)
- `ur_nutritioncounselling.ur_activitylevel` - Activity level choice (PAL Value)
- `ur_nutritioncounselling.ur_weight` - Current weight (kg)
- `contact.ur_height` - Height (cm)
- `contact.ur_age` - Age (years)
- `contact.ur_gender` - Gender choice

**UI Components:**
- **Card:** "Metabolic Information"
- **Layout:** Compact card showing key metrics
- **Visual indicators:**
  - BMR with icon (🔥 metabolism icon)
  - TDEE with icon (⚡ activity icon)
  - Target Calories with icon (🎯 target icon)

**Business Rules:**
- If BMR is null/empty, show placeholder: "Not calculated"
- If TDEE is null but BMR exists, calculate TDEE = BMR × activity_factor
- Activity factors:
  - Sedentary (0): 1.2
  - Light (1): 1.375
  - Moderate (2): 1.55
  - Active (3): 1.725
  - Very Active (4): 1.9

**Example Display:**
```
┌─────────────────────────────────┐
│ 📊 Metabolic Information        │
├─────────────────────────────────┤
│ 🔥 BMR:          1,650 kcal/day │
│ ⚡ TDEE:         2,310 kcal/day │
│ 🎯 Target:       2,100 kcal/day │
│ 📏 Height/Weight: 175 cm, 78 kg │
│ 🎂 Age/Gender:   34 yrs, Male   │
└─────────────────────────────────┘
```

---

### FR2: Daily Average Energy Intake Calculation

**Priority:** P0 (Must Have)

**Description:**  
Calculate and display average daily caloric intake from nutrition diary entries over a selected date range.

**Data Sources:**
- `ur_nutritiondiary` - Parent diary records
  - `ur_actualdate` - Meal date
  - `ur_member` - Link to contact
- `ur_nutritionlog` - Child food log records (aggregated)
  - `ur_calories` - Calories per food item
  - `ur_date` - Date of consumption

**Calculation Logic:**
```
1. Get all ur_nutritiondiary records where:
   - ur_member = current contact
   - ur_actualdate BETWEEN [StartDate] AND [EndDate]
   - statecode = Active (0)

2. For each diary record, sum ur_nutritionlog.ur_calories:
   - Join ur_nutritionlog ON ur_nutritiondiary.ur_nutritiondiaryid
   - SUM(ur_calories) AS total_daily_calories

3. Calculate average:
   - total_calories = SUM(all daily totals)
   - number_of_days = COUNT(DISTINCT ur_actualdate)
   - average_daily_calories = total_calories / number_of_days
```

**UI Components:**
- **Card:** "Daily Average Energy"
- **Primary Metric:** Large number display (e.g., "2,245 kcal/day")
- **Comparison:** vs. Target Calories
  - Green if within ±100 kcal
  - Yellow if ±101-200 kcal
  - Red if >200 kcal difference
- **Date Range Selector:** Dropdown with preset options
  - Last 7 days
  - Last 14 days
  - Last 30 days
  - Custom range (date picker)

**Business Rules:**
- Days with no diary entries are excluded from average
- If no data exists, show "No data available for selected period"
- Round to nearest whole number (e.g., 2,245 not 2,245.37)
- Display difference as "+/- X kcal from target"

**Example Display:**
```
┌────────────────────────────────────┐
│ 🍽️ Daily Average Energy           │
├────────────────────────────────────┤
│   2,245 kcal/day                   │
│   ────────────────                 │
│   Target: 2,100 kcal/day           │
│   Diff: +145 kcal ⚠️               │
│                                    │
│   📅 Last 14 days ▼                │
│   Based on 12 days with entries    │
└────────────────────────────────────┘
```

---

### FR3: Macronutrient Distribution Analysis

**Priority:** P0 (Must Have)

**Description:**  
Calculate average daily macronutrient intake (protein, carbs, fats) in both grams and percentage distribution, visualized for quick comprehension.

**Data Sources:**
- `ur_nutritionlog`:
  - `ur_protein` (grams)
  - `ur_carbs` (grams)
  - `ur_fat` (grams)
  - Related to `ur_nutritiondiary` in selected date range

**Calculation Logic:**
```
1. For each day in date range:
   - daily_protein = SUM(ur_nutritionlog.ur_protein)
   - daily_carbs = SUM(ur_nutritionlog.ur_carbs)
   - daily_fat = SUM(ur_nutritionlog.ur_fat)

2. Calculate averages:
   - avg_protein_grams = AVERAGE(daily_protein) across all days
   - avg_carbs_grams = AVERAGE(daily_carbs) across all days
   - avg_fat_grams = AVERAGE(daily_fat) across all days

3. Calculate energy from each macronutrient:
   - protein_kcal = avg_protein_grams × 4 kcal/g
   - carbs_kcal = avg_carbs_grams × 4 kcal/g
   - fat_kcal = avg_fat_grams × 9 kcal/g
   - total_kcal = protein_kcal + carbs_kcal + fat_kcal

4. Calculate percentage distribution:
   - protein_percent = (protein_kcal / total_kcal) × 100
   - carbs_percent = (carbs_kcal / total_kcal) × 100
   - fat_percent = (fat_kcal / total_kcal) × 100
```

**UI Components:**
- **Card:** "Macronutrient Distribution"
- **Primary Visualization:** Horizontal stacked bar chart or donut chart
  - Protein: Blue (#0078D4)
  - Carbs: Green (#107C10)
  - Fats: Orange (#D83B01)
- **Data Table:** Detailed breakdown

| Macro | Grams/day | Percentage | kcal/day |
|-------|-----------|------------|----------|
| 🥩 Protein | 98 g | 18% | 392 kcal |
| 🍞 Carbs | 245 g | 44% | 980 kcal |
| 🥑 Fats | 95 g | 38% | 855 kcal |
| **Total** | | **100%** | **2,227 kcal** |

**Business Rules:**
- Percentages must sum to 100% (handle rounding)
- If total_kcal doesn't match Daily Average Energy ±5%, show warning
- Standard recommendations (for reference):
  - Protein: 15-25%
  - Carbs: 45-65%
  - Fats: 20-35%
- Color-code if distribution is outside healthy ranges (configurable)

**Example Display:**
```
┌──────────────────────────────────────┐
│ 🥗 Macronutrient Distribution        │
├──────────────────────────────────────┤
│                                      │
│  [████████████░░░░░░░░░░░░░░░░░░░░] │
│    18%      44%          38%         │
│   Protein  Carbs        Fats         │
│                                      │
│  Detailed Breakdown:                 │
│  • 🥩 Protein:  98g  │ 18% │ 392kcal│
│  • 🍞 Carbs:   245g  │ 44% │ 980kcal│
│  • 🥑 Fats:     95g  │ 38% │ 855kcal│
│  ─────────────────────────────────── │
│  Total: 438g │ 100% │ 2,227 kcal    │
│                                      │
│  📊 Comparison to Targets:           │
│  Protein: ✅ Within range (15-25%)   │
│  Carbs:   ✅ Within range (45-65%)   │
│  Fats:    ⚠️ Slightly high (20-35%)  │
└──────────────────────────────────────┘
```

---

### FR4: Date Range Selection and Filtering

**Priority:** P0 (Must Have)

**Description:**  
Allow counselors to select different date ranges for analysis to view short-term or long-term trends.

**Functional Behavior:**
- **Preset Options:**
  - Last 7 days
  - Last 14 days
  - Last 30 days
  - Custom range
- **Default:** Last 14 days
- **Custom Range:**
  - Start date picker (calendar control)
  - End date picker (calendar control)
  - Validation: Start date must be before end date
  - Max range: 90 days (to prevent performance issues)

**UI Components:**
- **Dropdown:** Date range selector (top-right of dashboard)
- **Date Pickers:** For custom range (Fluent UI DatePicker)
- **Apply Button:** To refresh data with new range
- **Status Indicator:** "Last updated: [timestamp]"

**Business Rules:**
- Date range applies to ALL calculations (energy, macros)
- If custom range exceeds 90 days, show warning: "Large date ranges may affect performance"
- If custom range has no data, show friendly message: "No nutrition data found for this period"
- Save last-used date range in session storage

**Interactions:**
1. User selects "Last 7 days" → Dashboard refreshes immediately
2. User selects "Custom" → Date pickers appear → User selects dates → Click "Apply" → Dashboard refreshes
3. Date range change triggers:
   - Re-query Dataverse for ur_nutritiondiary + ur_nutritionlog
   - Re-calculate all metrics
   - Update all visualizations

---

### FR5: Data Validation and Error Handling

**Priority:** P1 (Should Have)

**Description:**  
Provide clear feedback when data is missing, incomplete, or invalid.

**Scenarios:**

**Scenario 1: No Nutrition Data**
- **Condition:** No `ur_nutritiondiary` records for member in date range
- **Display:** 
  ```
  📭 No Nutrition Data Available
  
  This member has not logged any nutrition diary entries
  for the selected period.
  
  Suggestions:
  - Encourage member to start logging meals
  - Check if date range is correct
  - Review with member during session
  ```

**Scenario 2: Incomplete Metabolic Info**
- **Condition:** `contact.ur_bmr` or `contact.ur_tdee` is null
- **Display:**
  ```
  ⚠️ Metabolic Information Incomplete
  
  BMR/TDEE not calculated for this member.
  
  Action Required:
  - Update member profile with height, weight, age
  - System will auto-calculate BMR/TDEE
  ```

**Scenario 3: Missing Macronutrient Data**
- **Condition:** Some `ur_nutritionlog` records missing protein/carbs/fat values
- **Display:**
  - Show percentage of complete records
  - "85% of food logs have complete macro data"
  - Option to view incomplete entries

**Scenario 4: Extreme Values Detected**
- **Condition:** Daily calories >5,000 or <500 kcal
- **Display:**
  ```
  ⚠️ Unusual Values Detected
  
  Some diary entries show extreme caloric values.
  Please review data accuracy with member.
  
  [View Flagged Entries]
  ```

**Business Rules:**
- Never show raw error messages to user
- Always provide actionable next steps
- Log errors to console for debugging
- Gracefully degrade (show partial data if available)

---

## Data Requirements

### Data Sources

| Table | Fields Used | Purpose | Refresh Frequency |
|-------|-------------|---------|-------------------|
| `contact` | `ur_bmr`, `ur_tdee`, `ur_targetcalories`, `ur_weight`, `ur_height`, `ur_age`, `ur_gender`, `ur_activitylevel` | Metabolic baseline | On load |
| `ur_nutritiondiary` | `ur_nutritiondiaryid`, `ur_actualdate`, `ur_member`, `statecode` | Parent meal records | On date range change |
| `ur_nutritionlog` | `ur_calories`, `ur_protein`, `ur_carbs`, `ur_fat`, `ur_date`, `_ur_nutritiondiary_value` | Detailed food data | On date range change |

### Data Relationships

```
contact (1) ──┬── (M) ur_nutritiondiary ──┬── (M) ur_nutritionlog
              │                           │
              │                           └── Aggregate: daily totals
              │
              └── Provides: metabolic context
```

### Data Volume Estimates

**Per Member:**
- Avg diary entries/day: 3-4
- Avg food logs/diary: 2-3
- 30-day dataset: ~90 diary entries, ~270 food logs

**Performance Targets:**
- Initial load: <3 seconds
- Date range change: <2 seconds
- Supports up to 90 days (270 diary entries, 810 food logs)

### Data Access Requirements

**Permissions:**
- Read access to `contact` table (member data)
- Read access to `ur_nutritiondiary` table
- Read access to `ur_nutritionlog` table
- No write permissions needed (read-only dashboard)

**Filtering:**
- Respect Dataverse security roles
- Only show data for member associated with current counselling session
- Filter by `statecode = 0` (Active records only)

---

## UI/UX Requirements

### Visual Design Principles

1. **Clarity Over Complexity**
   - Large, easy-to-read numbers
   - Minimal text, maximum data density
   - Use icons to convey meaning quickly

2. **Fluent UI Compliance**
   - Follow Microsoft Fluent Design System
   - Use Fluent UI React components (@fluentui/react-components)
   - Maintain consistency with Dynamics 365 interface
   - Leverage Fluent UI design tokens for theming

3. **Responsive Layout**
   - Dashboard width: 100% of control container
   - Min width: 600px
   - Max width: 1200px
   - Stack cards vertically on narrow screens (<768px)

4. **Accessibility (WCAG 2.1 AA)**
   - Color contrast ratio ≥4.5:1 for text
   - Keyboard navigation support
   - Screen reader friendly (ARIA labels)
   - Focus indicators on interactive elements
   - Touch-friendly sizing (minimum 48px tap targets)

### Fluent UI Component Requirements

#### Required Fluent UI Components

| Component | Usage | Specification |
|-----------|-------|---------------|
| **Card** | Container for metric sections | Use with subtle shadow, padding: 16px |
| **Text** | All text elements | Use semantic variants (title1, body1, caption1) |
| **Dropdown** | Date range selector | Appearance: outline, full-width on mobile |
| **DatePicker** | Custom date range | Fluent calendar component |
| **Spinner** | Loading states | Size: medium, with label |
| **MessageBar** | Warnings, errors, info | Intent-based (info, warning, error, success) |
| **Icon** | Visual indicators | From @fluentui/react-icons, 24px default size |
| **ProgressIndicator** | Macro percentage bars | Determinate progress |
| **Stack** | Layout management | Use with gap tokens (8px, 12px, 16px) |
| **Badge** | Status indicators | Appearance: filled for status, outline for counts |

#### Component Import Pattern

```typescript
// Required imports for dashboard
import {
  Card,
  Text,
  Dropdown,
  Option,
  DatePicker,
  Spinner,
  MessageBar,
  MessageBarBody,
  MessageBarTitle,
  ProgressBar,
  Badge,
  makeStyles,
  tokens,
} from '@fluentui/react-components'

import {
  CalendarLtr24Regular,
  Food24Filled,
  HeartPulse24Regular,
  WeightLifter24Regular,
  Warning24Regular,
  CheckmarkCircle24Filled,
} from '@fluentui/react-icons'
```

### Design Token System

**Use Fluent UI Design Tokens** (not hardcoded values):

```typescript
// Color tokens
tokens.colorNeutralBackground1      // Card backgrounds
tokens.colorNeutralBackground2      // Screen background
tokens.colorNeutralForeground1      // Primary text
tokens.colorNeutralForeground3      // Secondary/muted text
tokens.colorNeutralStroke1          // Borders
tokens.colorBrandBackground         // Brand green (#667653)
tokens.colorPaletteGreenBackground2 // Success states
tokens.colorPaletteRedBackground2   // Error states
tokens.colorPaletteYellowBackground2// Warning states

// Spacing tokens
tokens.spacingHorizontalS   // 8px
tokens.spacingHorizontalM   // 12px
tokens.spacingHorizontalL   // 16px
tokens.spacingHorizontalXL  // 20px
tokens.spacingVerticalS     // 8px
tokens.spacingVerticalM     // 12px
tokens.spacingVerticalL     // 16px

// Typography tokens
tokens.fontSizeBase200  // 12px - captions
tokens.fontSizeBase300  // 14px - body
tokens.fontSizeBase400  // 16px - headings
tokens.fontSizeBase500  // 18px - section titles
tokens.fontSizeBase600  // 24px - page titles

tokens.fontWeightRegular  // 400
tokens.fontWeightSemibold // 600
tokens.fontWeightBold     // 700

// Border radius tokens
tokens.borderRadiusMedium  // 4px
tokens.borderRadiusLarge   // 6px
```

### Common CSS Classes (from STYLING_GUIDE.md)

**Use shared CSS classes** to maintain consistency:

```tsx
// Screen layout
<div className="screen-container">
  <div className="screen-header">
    <Text className="page-title">As-Is Analysis</Text>
    <Text className="page-subtitle">Nutrition Overview</Text>
  </div>
  <div className="screen-content-flex">
    {/* Cards go here */}
  </div>
</div>

// Typography classes
.page-title          // 24px, 600 weight, green
.section-title       // 18px, 600 weight
.page-subtitle       // 14px, muted color
.option-title        // 16px, 600 weight
.option-description  // 13px, muted color

// Layout utilities
.flex-column         // Vertical flex layout
.gap-16              // 16px gap between children
.gap-24              // 24px gap between children
```

### makeStyles Pattern

**Use makeStyles for component-specific styling:**

```typescript
const useStyles = makeStyles({
  metabolicCard: {
    padding: tokens.spacingHorizontalL,
    backgroundColor: tokens.colorNeutralBackground1,
    borderRadius: tokens.borderRadiusLarge,
    boxShadow: tokens.shadow4,
  },
  metricRow: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: tokens.spacingVerticalM,
  },
  metricLabel: {
    color: tokens.colorNeutralForeground3,
    fontSize: tokens.fontSizeBase300,
  },
  metricValue: {
    color: tokens.colorNeutralForeground1,
    fontSize: tokens.fontSizeBase400,
    fontWeight: tokens.fontWeightSemibold,
  },
  statusBadge: {
    ':hover': {
      backgroundColor: tokens.colorNeutralBackground1Hover,
    },
  },
})
```

### Layout Structure

**Dashboard Layout: 3-Column Grid**

```
┌─────────────────────────────────────────────────────┐
│  [Date Range Selector: Last 14 days ▼]             │
├─────────────────────┬──────────────────┬────────────┤
│                     │                  │            │
│  📊 Metabolic       │  🍽️ Daily Avg   │  🥗 Macro  │
│  Information        │  Energy          │  Distrib.  │
│                     │                  │            │
│  - BMR              │  2,245 kcal/day  │  [Chart]   │
│  - TDEE             │                  │            │
│  - Target           │  vs Target:      │  [Table]   │
│  - Demographics     │  +145 kcal ⚠️    │            │
│                     │                  │            │
└─────────────────────┴──────────────────┴────────────┘
```

**On Narrow Screens (<768px):**
```
┌──────────────────────┐
│ [Date Range: 14d ▼] │
├──────────────────────┤
│ 📊 Metabolic Info    │
├──────────────────────┤
│ 🍽️ Daily Avg Energy │
├──────────────────────┤
│ 🥗 Macro Distribution│
└──────────────────────┘
```

### Fluent UI Components to Use

| Component | Usage |
|-----------|-------|
| `Card` (Stack with shadow) | Container for each metric section |
| `Text` with variants | Headers, labels, values |
| `Dropdown` | Date range selector |
| `DatePicker` | Custom date range |
| `Spinner` | Loading state |
| `MessageBar` | Warnings, errors, info messages |
| `Icon` | Visual indicators (🔥, ⚡, 🎯, etc.) |
| `ProgressIndicator` | Percentage visualization |
| `Stack` | Layout management |

### Color Palette

**Primary Colors (Fluent UI):**
- Primary Blue: `#0078D4`
- Success Green: `#107C10`
- Warning Orange: `#F7630C`
- Error Red: `#D13438`
- Neutral Gray: `#605E5C`

**Macronutrient Colors:**
- Protein: `#0078D4` (Blue)
- Carbs: `#107C10` (Green)
- Fats: `#D83B01` (Orange)

**Status Indicators:**
- Within target: Green `#107C10`
- Slightly off: Yellow `#F7630C`
- Significantly off: Red `#D13438`

### Loading States

**Initial Load:**
```
┌──────────────────────┐
│  ⏳ Loading data...  │
│  [Spinner]           │
│  Please wait...      │
└──────────────────────┘
```

**Date Range Change:**
- Overlay spinner on affected cards
- Fade out old data, fade in new data (smooth transition)

### Empty States

**No Data:**
```
┌────────────────────────────┐
│  📭                        │
│  No Nutrition Data         │
│  No diary entries found    │
│  for selected period.      │
│                            │
│  [Change Date Range]       │
└────────────────────────────┘
```

---

### Component Implementation Examples

Based on `COMPONENTS.md` and `STYLING_GUIDE.md`:

#### Example: Metabolic Information Card

```tsx
import { Card, Text, makeStyles, tokens } from '@fluentui/react-components'
import { HeartPulse24Regular, WeightLifter24Regular, Target24Regular } from '@fluentui/react-icons'

const useStyles = makeStyles({
  card: {
    padding: tokens.spacingHorizontalL,
    display: 'flex',
    flexDirection: 'column',
    gap: tokens.spacingVerticalM,
  },
  metricRow: {
    display: 'flex',
    alignItems: 'center',
    gap: tokens.spacingHorizontalM,
    marginBottom: tokens.spacingVerticalS,
  },
  icon: {
    color: '#667653', // Brand green
  },
  value: {
    fontSize: tokens.fontSizeBase500,
    fontWeight: tokens.fontWeightSemibold,
  },
})

export const MetabolicInfoCard: React.FC<{ data: MetabolicData }> = ({ data }) => {
  const styles = useStyles()
  
  return (
    <Card className={styles.card}>
      <Text className="section-title">📊 Metabolic Information</Text>
      
      <div className={styles.metricRow}>
        <HeartPulse24Regular className={styles.icon} />
        <div>
          <Text className="option-description">BMR</Text>
          <Text className={styles.value}>{data.bmr} kcal/day</Text>
        </div>
      </div>
      
      <div className={styles.metricRow}>
        <WeightLifter24Regular className={styles.icon} />
        <div>
          <Text className="option-description">TDEE</Text>
          <Text className={styles.value}>{data.tdee} kcal/day</Text>
        </div>
      </div>
      
      <div className={styles.metricRow}>
        <Target24Regular className={styles.icon} />
        <div>
          <Text className="option-description">Target</Text>
          <Text className={styles.value}>{data.target} kcal/day</Text>
        </div>
      </div>
    </Card>
  )
}
```

#### Example: Date Range Dropdown

```tsx
import { Dropdown, Option } from '@fluentui/react-components'

const dateRangeOptions = [
  { key: '7', text: 'Last 7 days' },
  { key: '14', text: 'Last 14 days' },
  { key: '30', text: 'Last 30 days' },
  { key: 'custom', text: 'Custom range' },
]

<Dropdown
  placeholder="Select date range"
  value={selectedRange}
  onOptionSelect={(e, data) => handleDateRangeChange(data.optionValue)}
  appearance="outline"
  style={{ minWidth: '200px' }}
>
  {dateRangeOptions.map((option) => (
    <Option key={option.key} value={option.key}>
      {option.text}
    </Option>
  ))}
</Dropdown>
```

#### Example: Macronutrient Progress Bars

```tsx
import { ProgressBar, Text, makeStyles, tokens } from '@fluentui/react-components'

const useStyles = makeStyles({
  macroRow: {
    marginBottom: tokens.spacingVerticalM,
  },
  labelRow: {
    display: 'flex',
    justifyContent: 'space-between',
    marginBottom: tokens.spacingVerticalS,
  },
})

export const MacroDistribution: React.FC<{ data: MacroData }> = ({ data }) => {
  const styles = useStyles()
  
  return (
    <Card>
      <Text className="section-title">🥗 Macronutrient Distribution</Text>
      
      {/* Protein */}
      <div className={styles.macroRow}>
        <div className={styles.labelRow}>
          <Text>🥩 Protein</Text>
          <Text weight="semibold">{data.protein.grams}g ({data.protein.percent}%)</Text>
        </div>
        <ProgressBar
          value={data.protein.percent / 100}
          color="brand"
          thickness="large"
        />
      </div>
      
      {/* Carbs */}
      <div className={styles.macroRow}>
        <div className={styles.labelRow}>
          <Text>🍞 Carbs</Text>
          <Text weight="semibold">{data.carbs.grams}g ({data.carbs.percent}%)</Text>
        </div>
        <ProgressBar
          value={data.carbs.percent / 100}
          color="success"
          thickness="large"
        />
      </div>
      
      {/* Fats */}
      <div className={styles.macroRow}>
        <div className={styles.labelRow}>
          <Text>🥑 Fats</Text>
          <Text weight="semibold">{data.fats.grams}g ({data.fats.percent}%)</Text>
        </div>
        <ProgressBar
          value={data.fats.percent / 100}
          color="warning"
          thickness="large"
        />
      </div>
    </Card>
  )
}
```

#### Example: Loading State with Spinner

```tsx
import { Spinner } from '@fluentui/react-components'

{isLoading ? (
  <div style={{
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    padding: tokens.spacingVerticalXXL,
  }}>
    <Spinner size="large" label="Loading nutrition data..." />
  </div>
) : (
  <DashboardContent data={data} />
)}
```

#### Example: Status MessageBar

```tsx
import { MessageBar, MessageBarBody, MessageBarTitle } from '@fluentui/react-components'

{caloriesDiff > 200 && (
  <MessageBar intent="warning">
    <MessageBarBody>
      <MessageBarTitle>Caloric Intake Above Target</MessageBarTitle>
      Your average daily intake is {caloriesDiff} kcal above your target.
      Consider reducing portion sizes or increasing activity level.
    </MessageBarBody>
  </MessageBar>
)}

{!hasData && (
  <MessageBar intent="info">
    <MessageBarBody>
      <MessageBarTitle>No Nutrition Data Available</MessageBarTitle>
      This member hasn't logged any meals for the selected period.
      Encourage them to start tracking their nutrition.
    </MessageBarBody>
  </MessageBar>
)}
```

---

## Technical Requirements

### Technology Stack

**Frontend (PCF Control):**
- React 18.x
- TypeScript 5.x
- Fluent UI React (@fluentui/react)
- Power Apps Component Framework (PCF) SDK

**Backend:**
- Dataverse Web API
- OData queries for data retrieval
- Azure AD authentication (inherited from Dynamics 365)

### PCF Control Specification

**Control Name:** `NutritionCounsellingControl`  
**Namespace:** `EUSPoc`  
**Version:** `1.0.0`  
**Type:** Dataset control (bound to `ur_nutritioncounselling` table)

**Input Properties:**
```xml
<property name="contactId" 
          display-name-key="Contact ID" 
          of-type="SingleLine.Text" 
          usage="bound" 
          required="true" />

<property name="dateRangePreset" 
          display-name-key="Default Date Range" 
          of-type="Enum" 
          usage="input" 
          required="false"
          default-value="14" />
```

**Resources:**
- 1 CSS file (styles.css)
- React bundle (bundle.js)
- Fluent UI fonts (inherited)

### Data Queries

**Query 1: Get Metabolic Information**
```typescript
const contactData = await Xrm.WebApi.retrieveRecord(
  "contact",
  contactId,
  "?$select=ur_bmr,ur_tdee,ur_targetcalories,ur_weight,ur_height,ur_age,ur_gender,ur_activitylevel"
);
```

**Query 2: Get Nutrition Diary Entries**
```typescript
const diaryEntries = await Xrm.WebApi.retrieveMultipleRecords(
  "ur_nutritiondiary",
  `?$filter=_ur_member_value eq ${contactId} and ur_actualdate ge ${startDate} and ur_actualdate le ${endDate} and statecode eq 0
   &$select=ur_nutritiondiaryid,ur_actualdate
   &$expand=ur_nutritiondiary_nutritionlog($select=ur_calories,ur_protein,ur_carbs,ur_fat)
   &$orderby=ur_actualdate desc`
);
```

**Query 3: Aggregate Nutrition Logs (if expand not sufficient)**
```typescript
const nutritionLogs = await Xrm.WebApi.retrieveMultipleRecords(
  "ur_nutritionlog",
  `?$filter=_ur_nutritiondiary_value in (${diaryIds}) and statecode eq 0
   &$select=ur_calories,ur_protein,ur_carbs,ur_fat,ur_date,_ur_nutritiondiary_value`
);
```

### Performance Requirements

| Metric | Target | Max Acceptable |
|--------|--------|----------------|
| Initial load time | <3 seconds | 5 seconds |
| Date range change | <2 seconds | 3 seconds |
| Memory usage | <50 MB | 100 MB |
| Bundle size | <500 KB | 1 MB |
| API calls per load | 2-3 queries | 5 queries |

### Browser Support

- Microsoft Edge (Chromium) - latest 2 versions
- Google Chrome - latest 2 versions
- Firefox - latest 2 versions
- Safari - latest 2 versions (iOS/macOS)

### Security Requirements

1. **Authentication:** Leverage Dynamics 365 authentication (Azure AD)
2. **Authorization:** Respect Dataverse security roles
3. **Data Isolation:** Only show data for associated member
4. **No Caching:** Don't store sensitive health data in browser storage
5. **HTTPS Only:** All API calls over encrypted connections

---

## Success Metrics

### Primary KPIs

1. **Time Efficiency**
   - **Metric:** Average time to complete As-Is analysis
   - **Baseline:** 15-20 minutes
   - **Target:** 3-5 minutes
   - **Measure:** Time-tracking study (10 users, 50 sessions)

2. **Accuracy**
   - **Metric:** Calculation error rate
   - **Baseline:** ~15% errors (manual calculations)
   - **Target:** <2% errors
   - **Measure:** Audit of 100 random assessments

3. **User Satisfaction**
   - **Metric:** System Usability Scale (SUS) score
   - **Baseline:** N/A (new feature)
   - **Target:** ≥75 (Good)
   - **Measure:** Post-implementation survey

### Secondary KPIs

4. **Adoption Rate**
   - **Metric:** % of counselors using dashboard regularly
   - **Target:** >80% within 30 days
   - **Measure:** Telemetry / usage logs

5. **Error Recovery**
   - **Metric:** % of sessions with data errors resolved
   - **Target:** >90%
   - **Measure:** Support ticket analysis

6. **Performance**
   - **Metric:** Average dashboard load time
   - **Target:** <3 seconds
   - **Measure:** Application Insights telemetry

### Success Criteria for Release

**Must Meet:**
- ✅ Average load time <3 seconds (90th percentile)
- ✅ Zero critical bugs in production
- ✅ SUS score ≥70
- ✅ All P0 functional requirements implemented

**Should Meet:**
- ✅ Time savings ≥60% vs. baseline
- ✅ Adoption rate >70% within 30 days
- ✅ All P1 functional requirements implemented

---

## Out of Scope

The following features are **explicitly excluded** from Use Case 1 and planned for future releases:

### Use Case 2: Target Value Setting (Future)
- Input fields for target macronutrient percentages
- Recommendation engine for target values
- Save/edit functionality

### Use Case 3: SMART Goals Integration (Future)
- Create SMART goals from dashboard
- Track goal progress over time
- Goal completion workflows

### Advanced Features (Future Backlog)
- Comparison with previous time periods (trend analysis)
- Micronutrient analysis (vitamins, minerals)
- Meal timing analysis
- PDF export of As-Is analysis
- Member-facing view of dashboard
- Multi-language support beyond EN/DE
- Integration with wearable devices
- AI-powered recommendations

---

## Implementation Phases

### Phase 1: Foundation (Week 1-2) ✅ **CURRENT PHASE**

**Goal:** Set up project infrastructure and data layer

**Tasks:**
- [x] Initialize PCF project with React + TypeScript
- [x] Configure Fluent UI integration
- [x] Set up Dataverse metadata export scripts
- [x] Document actual table schemas (5 tables)
- [x] Define data models and interfaces
- [ ] Create mock data for development
- [ ] Set up local development environment

**Deliverables:**
- Working PCF project scaffold
- Complete Dataverse documentation
- TypeScript interfaces for all data types

---

### Phase 2: Core Features (Week 3-4)

**Goal:** Implement P0 functional requirements

**Tasks:**
- [x] FR1: Metabolic Information Display
  - [x] Create MetabolicInfoCard component (with interactive editing)
  - [x] Create data fetching script (Get-ContactData-Simple.ps1)
  - [x] Validate real data structure from production
  - [ ] Integrate real data into mock
  - [ ] Fetch contact data from Dataverse (runtime integration)
  - [ ] Handle missing data scenarios
  
- [ ] FR2: Daily Average Energy Calculation
  - [ ] Implement date range filtering logic
  - [ ] Query ur_nutritiondiary + ur_nutritionlog
  - [ ] Calculate average daily calories
  - [ ] Create DailyEnergyCard component
  
- [ ] FR3: Macronutrient Distribution
  - [ ] Calculate macro averages (grams)
  - [ ] Convert to percentages and kcal
  - [ ] Create MacroDistributionCard component
  - [ ] Add visualization (bar chart or donut)
  
- [ ] FR4: Date Range Selection
  - [ ] Create DateRangeSelector component
  - [ ] Implement preset options (7, 14, 30 days)
  - [ ] Add custom date range picker
  - [ ] Wire up state management for date changes

**Deliverables:**
- Functional dashboard with all 3 main cards
- Date range filtering working end-to-end
- Unit tests for calculation logic

---

### Phase 3: Polish & Error Handling (Week 5)

**Goal:** Implement P1 requirements and improve UX

**Tasks:**
- [ ] FR5: Data Validation & Error Handling
  - [ ] No data scenarios
  - [ ] Incomplete data warnings
  - [ ] Extreme value detection
  
- [ ] Loading states
  - [ ] Skeleton screens for cards
  - [ ] Smooth transitions on data refresh
  
- [ ] Empty states
  - [ ] Friendly messages for no data
  - [ ] Actionable next steps
  
- [ ] Responsive design
  - [ ] Test on mobile/tablet/desktop
  - [ ] Adjust layout for narrow screens
  
- [ ] Accessibility
  - [ ] Keyboard navigation
  - [ ] Screen reader support
  - [ ] ARIA labels

**Deliverables:**
- Polished, production-ready dashboard
- Comprehensive error handling
- Accessible UI (WCAG 2.1 AA compliant)

---

### Phase 4: Testing & Deployment (Week 6)

**Goal:** Validate with real users and deploy to production

**Tasks:**
- [ ] Integration testing
  - [ ] Test with real Dataverse data
  - [ ] Verify all calculations match manual results
  - [ ] Performance testing with large datasets
  
- [ ] User Acceptance Testing (UAT)
  - [ ] 5 counselors test with real clients
  - [ ] Collect feedback on usability
  - [ ] Measure time savings
  
- [ ] Deployment
  - [ ] Package PCF solution
  - [ ] Deploy to SIT environment
  - [ ] User training sessions
  - [ ] Deploy to Production
  
- [ ] Monitoring
  - [ ] Set up Application Insights
  - [ ] Create dashboard for KPI tracking
  - [ ] Establish support process

**Deliverables:**
- Production-ready PCF control deployed
- User training materials
- Monitoring dashboards configured

---

### Phase 5: Iteration & Optimization (Week 7-8)

**Goal:** Refine based on user feedback

**Tasks:**
- [ ] Analyze usage data and KPIs
- [ ] Address user feedback
- [ ] Performance optimizations
- [ ] Bug fixes
- [ ] Documentation updates

**Success Gate:**
- All success metrics met
- No P0/P1 bugs in production
- SUS score ≥75

---

## Appendices

### Appendix A: References

- [DATAVERSE_CONTACT_ACTUAL.md](./DATAVERSE_CONTACT_ACTUAL.md)
- [DATAVERSE_NUTRITIONDIARY_ACTUAL.md](./DATAVERSE_NUTRITIONDIARY_ACTUAL.md)
- [DATAVERSE_NUTRITIONLOG_ACTUAL.md](./DATAVERSE_NUTRITIONLOG_ACTUAL.md)
- [DATAVERSE_NUTRITIONCOUNSELLING_ACTUAL.md](./DATAVERSE_NUTRITIONCOUNSELLING_ACTUAL.md)
- [SESSION_2025-12-03.md](./SESSION_2025-12-03.md) - Real data integration session
- [GitHub Repository](https://github.com/urruegg/euspoc)
- [Get-ContactData-Simple.ps1](../scripts/Get-ContactData-Simple.ps1) - Data fetching script

### Appendix B: Mockup Screenshots

Refer to `docs/ideas/` folder for visual mockups:
- `MetabolicInformationCanvas.png`
- `DailyAverageEnergyFromNutritionDiary.png`
- `MacronutritientsAveragePerDayCanvas.png`
- `MacronutritionsTotalAverageCanvas.png`

### Appendix C: Calculation Examples

**Example: Daily Average Calculation**

Member: John Doe  
Date Range: Dec 1-7, 2025 (7 days)

```
Day 1 (Dec 1): Breakfast (350) + Lunch (650) + Dinner (800) + Snack (200) = 2,000 kcal
Day 2 (Dec 2): Breakfast (400) + Lunch (700) + Dinner (750) + Snack (150) = 2,000 kcal
Day 3 (Dec 3): No entries = excluded
Day 4 (Dec 4): Breakfast (350) + Lunch (600) + Dinner (850) + Snack (300) = 2,100 kcal
Day 5 (Dec 5): Breakfast (380) + Lunch (680) + Dinner (820) = 1,880 kcal
Day 6 (Dec 6): Breakfast (400) + Lunch (720) + Dinner (900) + Snack (250) = 2,270 kcal
Day 7 (Dec 7): Breakfast (360) + Lunch (640) + Dinner (780) = 1,780 kcal

Total calories: 12,030 kcal
Days with data: 6 days
Average: 12,030 / 6 = 2,005 kcal/day
```

**Example: Macronutrient Distribution**

Using same dataset, Day 1 breakdown:
- Protein: 25g + 40g + 50g + 10g = 125g × 4 kcal/g = 500 kcal (25%)
- Carbs: 40g + 80g + 90g + 25g = 235g × 4 kcal/g = 940 kcal (47%)
- Fats: 10g + 20g + 25g + 5g = 60g × 9 kcal/g = 540 kcal (27%)

Total: 500 + 940 + 540 = 1,980 kcal (≈2,000 with rounding)

(Repeat for all 6 days and average)

### Appendix D: Glossary

| Term | Definition |
|------|------------|
| **As-Is Analysis** | Assessment of member's current nutritional habits and intake patterns |
| **BMR** | Basal Metabolic Rate - calories burned at rest |
| **TDEE** | Total Daily Energy Expenditure - total calories burned including activity |
| **Macronutrients** | Protein, carbohydrates, and fats - primary dietary components |
| **PCF Control** | Power Apps Component Framework custom control |
| **SUS Score** | System Usability Scale - standardized usability questionnaire (0-100) |
| **Dataverse** | Microsoft's low-code data platform (formerly Common Data Service) |

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Dec 3, 2025 | Development Team | Initial PRD for Use Case 1 |

---

**Approval Signatures:**

- [ ] Product Owner: _________________ Date: _______
- [ ] Technical Lead: _________________ Date: _______
- [ ] UX Designer: ___________________ Date: _______
- [ ] Stakeholder: ___________________ Date: _______

---

**Next Steps:**
1. Review and approve PRD
2. Refine mockups based on FR specifications
3. Begin Phase 2 implementation
4. Schedule UAT with 5 pilot counselors
