# Dataverse SMART Goal (Activity) Table - Schema Discovery

**Document Type:** Actual State Documentation  
**Last Updated:** 2025-01-15  
**Status:** Active Schema  
**Source:** Dataverse Metadata API Export

---

## Table Information

| Property | Value |
|----------|-------|
| **Logical Name** | `ur_smartgoal` |
| **Schema Name** | `ur_smartgoal` |
| **Object Type Code** | `10686` |
| **Table Type** | Standard (Custom Activity) |
| **Ownership Type** | User Owned |
| **Primary Key** | `activityid` |
| **Primary Name Attribute** | `subject` |
| **Primary Image Attribute** | None |
| **Collection Name** | `ur_smartgoals` |
| **Display Name (EN)** | SMART Goal |
| **Display Name (DE)** | SMART-Ziel |
| **Description (EN)** | S.M.A.R.T. (or SMART) is an acronym used as a mnemonic device to establish criteria for effective goal-setting and objective development. |
| **Description (DE)** | S.M.A.R.T. (oder SMART) ist ein Akronym, das als Eselsbrücke dient, um Kriterien für eine effektive Zielsetzung und Zielentwicklung festzulegen. |
| **Is Custom Entity** | `true` |
| **Is Activity** | `true` |
| **Activity Type Mask** | `1` |
| **Is Activity Party** | `false` |
| **Has Notes** | `true` |
| **Has Activities** | `false` |
| **Has Feedback** | `true` |
| **Is Enabled For Charts** | `true` |
| **Is Quick Create Enabled** | `true` |
| **Is Valid For Advanced Find** | `true` |
| **Is Available Offline** | `true` |
| **Change Tracking Enabled** | `true` |
| **Entity Color** | (Empty/Default) |
| **Created On** | `2025-11-12T09:38:17Z` |
| **Modified On** | `2025-11-12T09:38:17Z` |
| **Introduced Version** | `5.0.0.0` |

---

## Table Purpose

The **SMART Goal** table is a custom activity entity designed for goal tracking and management within the Nutrition & Sport Counseling solution. It implements the S.M.A.R.T. goal-setting framework:

- **S**pecific: Clear and well-defined objectives
- **M**easurable: Quantifiable metrics for tracking progress
- **A**chievable: Realistic and attainable targets
- **R**elevant: Aligned with broader objectives and values
- **T**ime-bound: Defined timeline with deadlines

### Primary Use Cases

1. **Nutrition Goals**: Weight management, dietary improvements, macro targets
2. **Fitness Goals**: Activity levels, workout frequency, strength objectives
3. **Health Goals**: General wellness, habit formation, lifestyle changes
4. **Progress Tracking**: Measuring achievement against defined criteria
5. **Counseling Support**: Goal setting during nutrition counseling sessions

### Key Features

- **Activity-Based**: Inherits standard activity functionality (scheduling, completion tracking)
- **Timeline Integration**: Appears on related record timelines
- **Regarding Object**: Can be associated with contacts, accounts, or other records
- **Due Date Tracking**: Built-in deadline management
- **Status Management**: Open/Completed/Cancelled states

---

## Custom Fields

### Goal Definition Fields

| Logical Name | Display Name (EN) | Display Name (DE) | Type | Required | Description |
|--------------|-------------------|-------------------|------|----------|-------------|
| `subject` | Subject | Betreff | String(200) | Required | Goal title/summary |
| `description` | Description | Beschreibung | Memo | None | Detailed goal description |
| `scheduledstart` | Start Date | Startdatum | DateTime | None | Goal start date |
| `scheduledend` | Due Date | Fälligkeitsdatum | DateTime | None | Goal completion deadline |
| `actualdurationminutes` | Actual Duration | Tatsächliche Dauer | Integer | None | Actual time spent (minutes) |
| `actualdurationminutes` | Scheduled Duration | Geplante Dauer | Integer | None | Planned duration (minutes) |

### Goal Tracking Fields

| Logical Name | Display Name (EN) | Display Name (DE) | Type | Required | Description |
|--------------|-------------------|-------------------|------|----------|-------------|
| `statecode` | Status | Status | State | System Required | Activity state (Open/Completed/Cancelled) |
| `statuscode` | Status Reason | Statusgrund | Status | None | Detailed status reason |
| `actualend` | Actual End | Tatsächliches Ende | DateTime | None | Actual completion date |
| `prioritycode` | Priority | Priorität | Picklist | None | Goal priority level |

### Relationship Fields

| Logical Name | Display Name (EN) | Display Name (DE) | Type | Required | Description |
|--------------|-------------------|-------------------|------|----------|-------------|
| `regardingobjectid` | Regarding | Bezüglich | Lookup(multiple) | None | Related contact, account, or record |
| `ownerid` | Owner | Besitzer | Lookup(systemuser,team) | System Required | Goal owner |

### Activity-Specific Fields

| Logical Name | Display Name (EN) | Display Name (DE) | Type | Required | Description |
|--------------|-------------------|-------------------|------|----------|-------------|
| `community` | Social Channel | Sozialer Kanal | Picklist | None | Social media channel if applicable |
| `deliverylastattemptedon` | Date Delivery Last Attempted | Datum des letzten Zustellungsversuchs | DateTime | None | Last delivery attempt |
| `deliveryprioritycode` | Delivery Priority | Zustellpriorität | Picklist | None | Priority for delivery |
| `ismapiprivate` | Is Private | Ist privat | Boolean | None | Private activity flag |
| `isworkflowcreated` | Is Workflow Created | Ist durch Workflow erstellt | Boolean | None | Created by workflow |
| `leftvoicemail` | Left Voice Mail | Sprachnachricht hinterlassen | Boolean | None | Voice mail left indicator |
| `lastonholdtime` | Last On Hold Time | Letzte Zeit der Zurückstellung | DateTime | None | Last time put on hold |

---

## Choice/Picklist Fields

### statecode (Status)

Activity State Values:

| Value | Label (EN) | Label (DE) | State Type |
|-------|------------|------------|------------|
| 0 | Open | Geöffnet | Active |
| 1 | Completed | Abgeschlossen | Inactive |
| 2 | Cancelled | Abgebrochen | Inactive |

### statuscode (Status Reason)

Status Reason Values (linked to statecode):

| Value | Label (EN) | Label (DE) | State | Notes |
|-------|------------|------------|-------|-------|
| 1 | Open | Offen | Open | Default open status |
| 2 | Completed | Abgeschlossen | Completed | Goal achieved |
| 3 | Cancelled | Abgebrochen | Cancelled | Goal abandoned |

### prioritycode (Priority)

| Value | Label (EN) | Label (DE) |
|-------|------------|------------|
| 0 | Low | Niedrig |
| 1 | Normal | Normal |
| 2 | High | Hoch |

### deliveryprioritycode (Delivery Priority)

| Value | Label (EN) | Label (DE) |
|-------|------------|------------|
| 0 | Low | Niedrig |
| 1 | Normal | Normal |
| 2 | High | Hoch |

---

## System Fields

Standard Dataverse activity auditing fields:

| Logical Name | Display Name (EN) | Type | Description |
|--------------|-------------------|------|-------------|
| `activityid` | Activity | UniqueIdentifier | Unique identifier for the activity |
| `activitytypecode` | Activity Type | String | Type of activity (ur_smartgoal) |
| `createdby` | Created By | Lookup(systemuser) | User who created the record |
| `createdon` | Created On | DateTime | Date and time when created |
| `createdonbehalfby` | Created By (Delegate) | Lookup(systemuser) | Delegate who created the record |
| `modifiedby` | Modified By | Lookup(systemuser) | User who last modified |
| `modifiedon` | Modified On | DateTime | Date and time of last modification |
| `modifiedonbehalfby` | Modified By (Delegate) | Lookup(systemuser) | Delegate who modified |
| `ownerid` | Owner | Lookup(systemuser,team) | Owner of the goal |
| `owningbusinessunit` | Owning Business Unit | Lookup(businessunit) | Business unit that owns |
| `owningteam` | Owning Team | Lookup(team) | Team that owns the goal |
| `owninguser` | Owning User | Lookup(systemuser) | User that owns the goal |
| `versionnumber` | Version Number | BigInt | Version number |

---

## Sample Data Records

### Nutrition Goal Example

```json
{
  "activityid": "11111111-1111-1111-1111-111111111111",
  "subject": "Reduce daily calorie intake to 2000 kcal",
  "description": "Specific: Limit daily calories to 2000 kcal\nMeasurable: Track using nutrition diary\nAchievable: Gradual reduction from current 2500 kcal\nRelevant: Supports weight loss goal of 5kg\nTime-bound: Achieve by end of Q1 2025",
  "scheduledstart": "2025-01-01T00:00:00Z",
  "scheduledend": "2025-03-31T23:59:59Z",
  "statecode": 0,
  "statuscode": 1,
  "prioritycode": 2,
  "regardingobjectid": "22222222-2222-2222-2222-222222222222",
  "regardingobjecttypecode": "contact"
}
```

### Fitness Goal Example

```json
{
  "activityid": "33333333-3333-3333-3333-333333333333",
  "subject": "Exercise 3 times per week for 30 minutes",
  "description": "Specific: Cardio or strength training sessions\nMeasurable: 3 sessions weekly, 30 min each\nAchievable: Starting with 2x/week, building up\nRelevant: Improves cardiovascular health\nTime-bound: Maintain for 12 weeks",
  "scheduledstart": "2025-01-15T00:00:00Z",
  "scheduledend": "2025-04-15T23:59:59Z",
  "statecode": 0,
  "statuscode": 1,
  "prioritycode": 1,
  "regardingobjectid": "44444444-4444-4444-4444-444444444444",
  "regardingobjecttypecode": "contact"
}
```

---

## Architecture and Relationships

### Entity Relationship Diagram

```
┌─────────────────┐
│    Contact      │
│  (Standard)     │
└────────┬────────┘
         │
         │ regarding
         ↓
┌─────────────────┐        ┌──────────────────┐
│  ur_smartgoal   │───────→│  systemuser      │
│  (Activity)     │ owner  │  (Owner)         │
└────────┬────────┘        └──────────────────┘
         │
         │ regarding
         ↓
┌─────────────────────────┐
│ ur_nutritioncounselling │
│ (Counseling Session)    │
└─────────────────────────┘
```

### Relationship Details

1. **Regarding Object** (Polymorphic Lookup)
   - `regardingobjectid` → Multiple entity types
   - Common: `contact`, `account`, `ur_nutritioncounselling`
   - Purpose: Link goal to person or session

2. **Owner Relationship**
   - `ownerid` → `systemuser` or `team`
   - Purpose: Track goal ownership and responsibility

3. **Created/Modified By**
   - Standard audit relationships to `systemuser`
   - Purpose: Track who created and modified the goal

---

## Business Logic

### Goal Lifecycle

1. **Creation**: Goal is created in "Open" state
2. **In Progress**: Goal remains open while being worked on
3. **Completion**: Status changed to "Completed" when achieved
4. **Cancellation**: Can be cancelled if no longer relevant

### Status Transitions

```
Open (1)
├── → Completed (2)
└── → Cancelled (3)
```

### Validation Rules

- **Required Fields**: `subject`, `ownerid`, `statecode`
- **Date Logic**: `scheduledend` should be after `scheduledstart`
- **Completion**: `actualend` required when status is "Completed"

---

## Current State and Next Steps

### Implementation Status

✅ **Completed:**
- Custom activity entity created and configured
- Basic SMART goal structure implemented
- Activity timeline integration enabled
- Standard activity features inherited
- Offline capability enabled

🔄 **In Progress:**
- Custom SMART goal-specific fields (S.M.A.R.T. components)
- Progress tracking metrics
- Integration with nutrition counseling workflows
- Custom forms and views

⏳ **Planned:**
- Goal progress percentage calculation
- Milestone tracking sub-grid
- Goal achievement notifications
- Reporting and analytics dashboards
- Goal templates for common scenarios

### Known Limitations

1. **Custom Fields**: Full extraction of custom `ur_` fields pending
2. **Progress Tracking**: No built-in progress percentage field (yet)
3. **Milestones**: No sub-entity for tracking intermediate milestones
4. **Templates**: No goal template functionality implemented

### Technical Notes

- **Activity Entity**: Inherits all standard activity behavior
- **Activity Type Mask**: Set to `1` (custom activity)
- **Timeline Display**: Appears in activity timeline for related records
- **Mobile Support**: Available offline for mobile access
- **Icon**: No custom icon defined (using default)

### Next Actions

1. ✅ Extract and document all custom `ur_` prefixed fields
2. ✅ Add SMART goal component fields (Specific, Measurable, etc.)
3. ✅ Implement progress tracking calculated fields
4. ✅ Create milestone sub-entity or related entity
5. ✅ Build goal templates for common nutrition/fitness scenarios
6. ✅ Design custom forms for goal creation and tracking
7. ✅ Implement goal achievement business rules
8. ✅ Create Power BI reports for goal analytics

---

## Related Documentation

- [Nutrition Counselling Table Schema](./DATAVERSE_NUTRITIONCOUNSELLING_ACTUAL.md)
- [Contact Table Schema](./DATAVERSE_CONTACT_ACTUAL.md)
- [Nutrition Diary Table Schema](./DATAVERSE_NUTRITIONDIARY_ACTUAL.md)
- [Nutrition Log Table Schema](./DATAVERSE_NUTRITIONLOG_ACTUAL.md)
- [Dataverse Implementation Guide](../DATAVERSE.md)

---

## Usage Examples

### Creating a SMART Goal via Web API

```javascript
const goal = {
  "subject": "Increase protein intake to 120g daily",
  "description": "Specific: 120g protein per day\nMeasurable: Track via nutrition log\nAchievable: Increase from current 80g\nRelevant: Supports muscle building goal\nTime-bound: 8 weeks",
  "scheduledstart": "2025-01-20T00:00:00Z",
  "scheduledend": "2025-03-20T23:59:59Z",
  "prioritycode": 2,
  "regardingobjectid_contact@odata.bind": "/contacts(contactid-guid)"
};

// POST to /api/data/v9.2/ur_smartgoals
```

### Querying SMART Goals

```javascript
// Fetch all open goals for a contact
const fetchXml = `
<fetch>
  <entity name="ur_smartgoal">
    <attribute name="subject" />
    <attribute name="scheduledend" />
    <attribute name="statecode" />
    <filter>
      <condition attribute="regardingobjectid" operator="eq" value="{contact-guid}" />
      <condition attribute="statecode" operator="eq" value="0" />
    </filter>
    <order attribute="scheduledend" />
  </entity>
</fetch>
`;
```

---

**Document Maintenance**: This document reflects the actual state of the SMART Goal activity table as of the metadata export. Update when schema changes are deployed.
