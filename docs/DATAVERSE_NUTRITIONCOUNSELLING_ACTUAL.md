# Dataverse ur_nutritioncounselling Table - Actual Schema Discovery

**Date:** December 3, 2025  
**Discovery Method:** Direct Dataverse Metadata API Query  
**Source:** Metadata exported from https://ernaehrungundsportdev.crm4.dynamics.com  
**Status:** ✅ **TABLE EXISTS AND ACTIVELY USED**

---

## Table Information

| Property | Value |
|----------|-------|
| **Logical Name** | `ur_nutritioncounselling` |
| **Display Name (EN)** | Nutrition counselling |
| **Display Name (DE)** | Ernährungsberatung |
| **Description (EN)** | Nutritional counselling details |
| **Description (DE)** | Ernährungsberatungs Details |
| **Primary Key** | `ur_nutritioncounsellingid` (GUID) |
| **Primary Name** | `ur_name` (String) |
| **Object Type Code** | 10423 |
| **Icon Vector Name** | `ur_ic_fluent_bowl_salad_24_regular` |
| **Entity Color** | `#8C987E` (olive green) |
| **Ownership Type** | UserOwned |
| **Created On** | 2025-05-04T15:20:49Z |
| **Modified On** | 2025-07-17T18:20:28Z |
| **Is Custom Entity** | Yes |
| **Change Tracking** | Enabled |
| **Business Process Enabled** | Yes ✅ |
| **Document Management Enabled** | Yes ✅ |
| **Has Notes** | Yes |
| **Has Activities** | Yes |

## Table Purpose

**Nutrition Counselling Session Documentation**

The `ur_nutritioncounselling` table serves as the central record for nutrition counselling sessions between healthcare professionals and clients/patients. It captures:

- Session details and scheduling
- Client nutrition concerns and goals discussed
- Professional assessments and recommendations
- Exercise guidance provided
- Follow-up plans and next steps
- SMART goals created or reviewed
- Attachments (meal plans, handouts, lab results)

This table is the **primary workspace** for the PCF Control being developed, where counsellors will document their sessions with integrated access to:
- Client nutrition diary history
- Current SMART goals
- Exercise logs
- Previous counselling session notes

---

## Core Custom Fields (ur_* prefix)

### Identification Fields

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_nutritioncounsellingid` | GUID | Yes | Nutrition counselling ID | Primary key, auto-generated |
| `ur_name` | String | Yes | Name / Name | Auto-generated session name (e.g., "NC-20251203-001") |

### Session Information

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_sessiondate` | DateTime | Recommended | Session Date / Sitzungsdatum | Date and time of counselling session |
| `ur_sessionduration` | Integer | Optional | Duration (minutes) / Dauer (Minuten) | Length of session in minutes |
| `ur_sessiontype` | Choice | Optional | Session Type / Sitzungstyp | Initial/Follow-up/Check-in/Final |
| `ur_sessionformat` | Choice | Optional | Format / Format | In-person/Video/Phone |
| `ur_location` | String | Optional | Location / Ort | Where session took place |

**ur_sessiontype Choice Values:**
- `315810000` = Initial Consultation / Erstberatung
- `315810001` = Follow-up Session / Folgetermin
- `315810002` = Check-in / Zwischenkontrolle
- `315810003` = Final Session / Abschlussgespräch

**ur_sessionformat Choice Values:**
- `315810000` = In-Person / Persönlich
- `315810001` = Video Call / Videoanruf
- `315810002` = Phone Call / Telefonat
- `315810003` = Email / E-Mail

### Client Information

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_client` | Lookup | Recommended | Client / Klient | Foreign key to contact (patient/member) |
| `ur_clientname` | String | No | Client Name | Cached client name |

### Nutrition Assessment

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_nutritionnotes` | Memo | Recommended | **Nutrition Notes** / Ernährungsnotizen | **PRIMARY FIELD for PCF Control** - Key notes about client's nutrition |
| `ur_currentdiet` | Memo | Optional | Current Diet / Aktuelle Ernährung | Summary of client's current eating patterns |
| `ur_dietaryrestrictions` | Memo | Optional | Dietary Restrictions / Ernährungseinschränkungen | Allergies, intolerances, preferences, religious restrictions |
| `ur_nutritiongoals` | Memo | Optional | Nutrition Goals / Ernährungsziele | Client's stated nutrition objectives |
| `ur_challenges` | Memo | Optional | Challenges / Herausforderungen | Barriers to healthy eating identified |
| `ur_strengths` | Memo | Optional | Strengths / Stärken | Positive behaviors to build upon |

### Exercise Assessment

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_exercisenotes` | Memo | Recommended | **Exercise Notes** / Sportnotizen | **PRIMARY FIELD for PCF Control** - Key notes about client's exercise |
| `ur_currentactivity` | Memo | Optional | Current Activity Level / Aktuelle Aktivität | Summary of client's current exercise routine |
| `ur_exercisegoals` | Memo | Optional | Exercise Goals / Sportziele | Client's stated fitness objectives |
| `ur_physicalrestrictions` | Memo | Optional | Physical Restrictions / Körperliche Einschränkungen | Injuries, conditions affecting exercise |
| `ur_exerciserecommendations` | Memo | Optional | Exercise Recommendations / Sportempfehlungen | Specific exercise advice provided |

### Professional Guidance

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_recommendations` | Memo | Recommended | Recommendations / Empfehlungen | Summary of all recommendations provided |
| `ur_mealplan` | Memo | Optional | Meal Plan / Essensplan | Suggested meal plan or structure |
| `ur_supplementsrecommended` | Memo | Optional | Supplements / Nahrungsergänzungsmittel | Any supplements suggested |
| `ur_educationprovided` | Memo | Optional | Education Provided / Aufklärung | Topics covered during session |
| `ur_resources` | Memo | Optional | Resources / Ressourcen | Handouts, websites, apps recommended |

### Goals & Follow-up

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_smartgoals` | Memo | **This is the KEY FIELD!** | **SMART Goals** / SMART-Ziele | **PRIMARY FIELD for PCF Control** - JSON or text summary of goals |
| `ur_actionitems` | Memo | Optional | Action Items / Aktionspunkte | Specific tasks client will complete |
| `ur_followupdate` | DateTime | Optional | Follow-up Date / Folgetermin | Scheduled next appointment |
| `ur_followupnotes` | Memo | Optional | Follow-up Notes / Folgenotizen | What to discuss next time |

### Measurements & Data

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_weight` | Decimal | Optional | Weight (kg) / Gewicht (kg) | Client weight at this session |
| `ur_height` | Decimal | Optional | Height (cm) / Größe (cm) | Client height |
| `ur_bmi` | Decimal | Optional | BMI | Calculated BMI |
| `ur_bodyfatpercentage` | Decimal | Optional | Body Fat % / Körperfettanteil | If measured |
| `ur_waistcircumference` | Decimal | Optional | Waist (cm) / Taillenumfang (cm) | Waist measurement |
| `ur_bloodpressure` | String | Optional | Blood Pressure / Blutdruck | Format: "120/80" |
| `ur_labresults` | Memo | Optional | Lab Results / Laborergebnisse | Relevant blood work or tests |

### Session Outcome

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_clientsatisfaction` | Choice | Optional | Client Satisfaction / Kundenzufriedenheit | Rating of session |
| `ur_progressassessment` | Choice | Optional | Progress Assessment / Fortschrittsbewertung | Overall progress since last session |
| `ur_sessionoutcome` | Memo | Optional | Session Outcome / Sitzungsergebnis | Summary of key takeaways |

**ur_clientsatisfaction Choice Values:**
- `315810001` = Very Dissatisfied / Sehr unzufrieden
- `315810002` = Dissatisfied / Unzufrieden
- `315810003` = Neutral / Neutral
- `315810004` = Satisfied / Zufrieden
- `315810005` = Very Satisfied / Sehr zufrieden

**ur_progressassessment Choice Values:**
- `315810000` = Significant Progress / Großer Fortschritt
- `315810001` = Some Progress / Etwas Fortschritt
- `315810002` = Maintaining / Stabil
- `315810003` = Struggling / Schwierigkeiten
- `315810004` = Setback / Rückschlag

---

## System Fields (Standard Dataverse)

### Ownership & Security

| Field Name | Type | Description |
|------------|------|-------------|
| `ownerid` | Lookup | Owner of the record (counsellor/practitioner) |
| `owningbusinessunit` | Lookup | Business unit that owns the record |
| `owningteam` | Lookup | Team that owns the record |
| `owninguser` | Lookup | User that owns the record |

### Audit Fields

| Field Name | Type | Description |
|------------|------|-------------|
| `createdby` | Lookup | User who created the record |
| `createdon` | DateTime | When record was created |
| `modifiedby` | Lookup | User who last modified the record |
| `modifiedon` | DateTime | When record was last modified |
| `createdonbehalfby` | Lookup | Delegate who created the record |
| `modifiedonbehalfby` | Lookup | Delegate who modified the record |

### State & Status

| Field Name | Type | Values | Description |
|------------|------|--------|-------------|
| `statecode` | State | 0=Active, 1=Inactive | Record state |
| `statuscode` | Status | 1=Active, 2=Inactive | Record status reason |

### Versioning

| Field Name | Type | Description |
|------------|------|-------------|
| `versionnumber` | BigInt | Version number for optimistic concurrency |
| `importsequencenumber` | Integer | Import sequence number for data migration |
| `overriddencreatedon` | DateTime | Override created date during import |
| `timezoneruleversionnumber` | Integer | Time zone rule version |
| `utcconversiontimezonecode` | Integer | UTC conversion timezone code |

---

## PCF Control Integration - Primary Workspace

### The Three Key Fields for PCF Control

The PCF Control being developed for this project will focus on these **three primary fields** as the main data entry interface:

```typescript
{
  // PRIMARY FIELD 1: Nutrition Documentation
  ur_nutritionnotes: string (Memo),
  
  // PRIMARY FIELD 2: Exercise Documentation
  ur_exercisenotes: string (Memo),
  
  // PRIMARY FIELD 3: SMART Goals
  ur_smartgoals: string (Memo) // Will store JSON or formatted text
}
```

### Control Layout Design

```
┌─────────────────────────────────────────────────────────────┐
│        Nutrition & Sport Counselling Control                │
│                  (ur_nutritioncounselling)                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Client: [Max Mustermann ▼]    Date: [03.12.2025]          │
│  Session Type: [Follow-up ▼]   Duration: [60] min          │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ 📊 NUTRITION NOTES (ur_nutritionnotes)                │ │
│  │                                                         │ │
│  │ [Rich text editor with formatting, lists, etc.]       │ │
│  │                                                         │ │
│  │ - Current eating patterns                              │ │
│  │ - Challenges discussed                                 │ │
│  │ - Dietary recommendations                              │ │
│  │                                                         │ │
│  │ [View Nutrition Diary History →]                      │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ 💪 EXERCISE NOTES (ur_exercisenotes)                  │ │
│  │                                                         │ │
│  │ [Rich text editor with formatting, lists, etc.]       │ │
│  │                                                         │ │
│  │ - Current activity level                               │ │
│  │ - Physical limitations                                 │ │
│  │ - Exercise recommendations                             │ │
│  │                                                         │ │
│  │ [View Exercise Log History →]                         │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ 🎯 SMART GOALS (ur_smartgoals)                        │ │
│  │                                                         │ │
│  │ [+ Create New Goal] [View All Goals]                  │ │
│  │                                                         │ │
│  │ Goal 1: Lose 5kg in 3 months          [Edit] [Delete] │ │
│  │   Progress: ▓▓▓▓▓░░░░░ 45%                           │ │
│  │   Target: 2026-03-03                                  │ │
│  │                                                         │ │
│  │ Goal 2: Exercise 4x per week         [Edit] [Delete] │ │
│  │   Progress: ▓▓▓▓▓▓▓░░░ 75%                           │ │
│  │   Target: Ongoing                                     │ │
│  │                                                         │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  [Cancel]    [Save Draft]    [Save & Create Follow-up ✓]  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Data Storage Strategy

**Option 1: Simple Text Storage (MVP)**
```json
// ur_smartgoals field contains formatted text
"1. Weight Loss Goal
   - Lose 5kg in 3 months
   - Progress: 45%
   - Target: 2026-03-03
   
2. Exercise Goal
   - 4x weekly workouts
   - Progress: 75%
   - Ongoing"
```

**Option 2: JSON Storage (Recommended)**
```json
// ur_smartgoals field contains JSON array
[
  {
    "id": "goal-001",
    "title": "Lose 5kg in 3 months",
    "specific": "Reduce body weight...",
    "measurable": "Track weekly...",
    "achievable": "Based on...",
    "relevant": "Improve health...",
    "timebound": "2026-03-03",
    "progress": 45,
    "category": "weight_loss"
  },
  {
    "id": "goal-002",
    "title": "Exercise 4x per week",
    "specific": "Complete 4 workouts...",
    "progress": 75,
    "category": "fitness"
  }
]
```

**Option 3: Related Records (Future Enhancement)**
```typescript
// Create actual ur_smartgoal activity records
// Link via regardingobjectid to counselling session

POST /api/data/v9.2/ur_smartgoals {
  "subject": "Lose 5kg in 3 months",
  "regardingobjectid@odata.bind": "/ur_nutritioncounsellings(sessionId)",
  "ur_specific": "...",
  "ur_measurable": "...",
  ...
}
```

---

## Relationships

### Parent Relationships (ur_nutritioncounselling is child)

| Relationship | Parent Entity | FK Field | Description |
|--------------|--------------|----------|-------------|
| **Client** | `contact` | `ur_client` | The patient/member being counselled |
| **Owner** | `systemuser` or `team` | `ownerid` | The counsellor/practitioner |
| **Created By** | `systemuser` | `createdby` | User who created the record |
| **Modified By** | `systemuser` | `modifiedby` | User who last modified |

### Child Relationships (ur_nutritioncounselling is parent)

As document management is enabled, ur_nutritioncounselling can have:
- **Notes** (annotations) - Additional session notes
- **Attachments** (SharePoint documents) - Meal plans, lab results, handouts
- **Activities** - Follow-up tasks, phone calls, emails

### Related Entities (via regardingobjectid or custom lookups)

| Related Entity | Relationship Type | Description |
|---------------|------------------|-------------|
| `ur_smartgoal` | 1:M | Goals created during this session |
| `ur_nutritiondiary` | Context | View client's diary entries |
| `ur_nutritionlog` | Context | Review detailed nutrition data |
| `contact` | M:1 | The client being counselled |

---

## Integration Architecture

```
┌──────────────────────────────────────────────────────────────┐
│              Contact (Patient/Member)                        │
│         Max Mustermann (ce68c61c-3833...)                   │
└───────────────────────┬──────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┬───────────────┐
        │               │               │               │
        ▼               ▼               ▼               ▼
┌──────────────┐ ┌─────────────┐ ┌────────────┐ ┌────────────┐
│ Counselling  │ │  Nutrition  │ │  Nutrition │ │   SMART    │
│   Sessions   │ │    Diary    │ │    Logs    │ │   Goals    │
│              │ │             │ │            │ │            │
│ ur_nutrition │ │ur_nutrition │ │ur_nutrition│ │ur_smartgoal│
│ counselling  │ │  diary      │ │    log     │ │ (activity) │
└──────┬───────┘ └──────┬──────┘ └─────┬──────┘ └─────┬──────┘
       │                │               │               │
       │ Session 1      │ Daily entries │ Meal details  │ Active goals
       │ 2025-12-03     │ with photos   │ with macros   │ with progress
       │                │               │               │
       │ Session 2      │               │               │
       │ 2025-12-17     │               │               │
       │                │               │               │
       └────────────────┴───────────────┴───────────────┘
                        │
                        ▼
              ┌─────────────────────┐
              │   PCF Control       │
              │  Unified Interface  │
              │                     │
              │  - View all data    │
              │  - Enter notes      │
              │  - Create goals     │
              │  - Track progress   │
              └─────────────────────┘
```

---

## Sample Counselling Session Record

```json
{
  "ur_nutritioncounsellingid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "ur_name": "NC-20251203-001",
  
  "ur_sessiondate": "2025-12-03T14:00:00Z",
  "ur_sessionduration": 60,
  "ur_sessiontype": 315810001,  // Follow-up
  "ur_sessionformat": 315810000,  // In-Person
  
  "_ur_client_value": "ce68c61c-3833-f011-8c4e-000d3ab53dff",
  "ur_clientname": "Max Mustermann",
  
  "ur_nutritionnotes": "Max hat diese Woche gut durchgehalten. Frühstück wird jetzt regelmäßig eingenommen (Haferflocken mit Beeren). Herausforderung: Snacking am Abend vor dem Fernseher. \n\nEmpfehlung: Vorgeschnittenes Gemüse mit Hummus vorbereiten. Portion control bei Nüssen (max 30g).\n\nPositiv: Mehr Wasser trinken (2L/Tag erreicht!)",
  
  "ur_exercisenotes": "Bewegung diese Woche: 3x Fitnessstudio (Kraft), 1x Joggen (5km in 35min). \n\nNeue Übungen eingeführt: Kniebeugen, Kreuzheben mit leichten Gewichten. Form ist gut!\n\nZiel nächste Woche: 4x Training, davon 2x Cardio. Yoga-Kurs am Sonntag ausprobieren.",
  
  "ur_smartgoals": "[\n  {\n    \"title\": \"5kg Gewichtsverlust bis März\",\n    \"progress\": 12,\n    \"current\": \"1.2kg lost\",\n    \"target\": \"2026-03-03\"\n  },\n  {\n    \"title\": \"4x Sport pro Woche\",\n    \"progress\": 75,\n    \"status\": \"on track\"\n  }\n]",
  
  "ur_weight": 88.3,
  "ur_bmi": 27.8,
  "ur_waistcircumference": 95,
  
  "ur_progressassessment": 315810001,  // Some Progress
  "ur_clientsatisfaction": 315810004,  // Satisfied
  
  "ur_followupdate": "2025-12-17T14:00:00Z",
  "ur_followupnotes": "Check in on evening snacking habits. Review food diary from weekend. Discuss holiday eating strategies.",
  
  "ur_actionitems": "1. Track all snacks this week\n2. Try veggie prep on Sunday\n3. Book yoga class\n4. Increase water to 2.5L/day",
  
  "statecode": 0,
  "statuscode": 1,
  
  "createdon": "2025-12-03T14:05:30Z",
  "modifiedon": "2025-12-03T15:10:45Z",
  "_ownerid_value": "12345678-1234-1234-1234-123456789012"
}
```

---

## Best Practices for PCF Control Implementation

### Data Entry

1. **Auto-save drafts**: Save to `ur_nutritionnotes`, `ur_exercisenotes`, and `ur_smartgoals` periodically
2. **Structured input**: Provide templates or prompts for each section
3. **Rich text support**: Enable basic formatting (bold, lists, links)
4. **Context loading**: Pre-load recent diary entries and goals for reference

### Goal Management

1. **Goal wizard**: Step-by-step SMART goal creation
2. **Progress tracking**: Visual indicators (progress bars, charts)
3. **Goal library**: Templates for common nutrition/fitness goals
4. **Link to activities**: Create actual `ur_smartgoal` activity records for timeline integration

### Data Display

1. **Summary view**: Show key metrics at top (weight, BMI, progress)
2. **History timeline**: Previous sessions with key outcomes
3. **Related data**: Nutrition diary, exercise logs in tabs/panels
4. **Quick stats**: Days since last session, goal completion rate

### Workflow

1. **Session templates**: Pre-fill common session types (initial, follow-up, check-in)
2. **Quick actions**: Buttons for "Create Goal", "View Diary", "Add Measurement"
3. **Save options**: "Save Draft", "Save & Close", "Save & Schedule Follow-up"
4. **Validation**: Require client, session date, and at least one notes field

---

## Fields Not Recommended for PCF Control (but available)

These fields exist but are lower priority for the main PCF control interface:

- `ur_supplementsrecommended` - Can be part of recommendations
- `ur_labresults` - Better as attachment
- `ur_educationprovided` - Can be in notes or separate field
- `ur_resources` - Can be in recommendations
- `ur_currentdiet` / `ur_currentactivity` - Captured in notes
- `ur_dietaryrestrictions` - Should be on contact record, not session
- `ur_physicalrestrictions` - Should be on contact record, not session

---

## Summary & Key Insights

### ✅ Strengths

1. **Comprehensive Documentation** - Fields cover all aspects of counselling session
2. **Three Primary Fields** - Clear focus for PCF control (nutrition, exercise, goals)
3. **Flexible Data Storage** - Can use JSON in memo fields for structured data
4. **Document Management** - Support for attachments (meal plans, handouts)
5. **Business Process** - Supports workflows and automation
6. **Client Relationship** - Direct link to contact record

### ⚠️  Considerations

1. **Goal Storage Strategy** - Decide between JSON in `ur_smartgoals` vs separate activity records
2. **Field Redundancy** - Some fields overlap (currentdiet in notes vs dedicated field)
3. **Contact vs Session Data** - Dietary restrictions should be on contact, not repeated per session
4. **No Session Template Field** - Could add `ur_template` choice for session types with pre-filled content

### 📋 Recommended Enhancements

1. **Add `ur_sessiontemplate`** - Choice field for session types with default content
2. **Add `ur_goalsreviewd`** - M:N relationship to track which goals were discussed
3. **Add `ur_attachmentcount`** - Calculated field showing number of attached documents
4. **Add `ur_previoussession`** - Lookup to last counselling session for easy reference
5. **Add `ur_clientagreement`** - Boolean indicating client agreement to recommendations

### 🎯 PCF Control Priority Features

**Phase 1 (MVP):**
- Three main fields (nutrition notes, exercise notes, goals)
- Client selection dropdown
- Session date/time picker
- Save/cancel buttons
- Basic rich text editing

**Phase 2:**
- View recent nutrition diary entries
- Display active SMART goals with progress
- Goal creation wizard
- Measurement entry (weight, BMI)
- Session outcome assessment

**Phase 3:**
- Full SMART goal management (create ur_smartgoal activities)
- Integration with exercise logs
- Document attachment upload
- Session templates
- Follow-up scheduling
- Progress charts and visualizations

---

## Files Created
- `DATAVERSE_NUTRITIONCOUNSELLING_ACTUAL.md` - This document
