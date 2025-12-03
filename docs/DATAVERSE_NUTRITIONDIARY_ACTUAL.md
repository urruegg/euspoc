# Dataverse ur_nutritiondiary Table - Actual Schema Discovery

**Date:** November 25, 2025 18:38 UTC  
**Source:** Dataverse Metadata API Query (Post-Schema Update)  
**Purpose:** Document actual table structure for control implementation planning  
**Total Fields:** 48 (17 custom + 31 system)  
**Recent Changes:** 

---

## Table Information

| Property | Value |
|----------|-------|
| **Logical Name** | `ur_nutritiondiary` |
| **Display Name (EN)** | Nutrition diary |
| **Display Name (DE)** | Ernährungstagebuch |
| **Primary Key** | `ur_nutritiondiaryid` (GUID) |
| **Primary Name** | `ur_name` (String) |
| **Total Fields** | 46 fields (16 custom + 30 system) |
| **Relationship** | 1:M to ur_nutritionlog (parent table) |

## Table Purpose

**ur_nutritiondiary serves as the USER INPUT and ANALYSIS REQUEST table:**
- User enters minimal meal information (date, meal type, description)
- Optionally uploads a photo
- Detailed food items stored in child `ur_nutritionlog` records (1:M relationship)
- Aggregated nutrition totals can be calculated from child records

---

## Custom Fields (ur_* prefix)

### Core Fields

| Field Name | Type | Required | Display Name (EN/DE) | Description |
|------------|------|----------|---------------------|-------------|
| `ur_nutritiondiaryid` | GUID | Yes | Nutrition diary / Ernährungstagebuch | Primary key, auto-generated |
| `ur_name` | String | Yes | Name / Name | Auto-generated record name (e.g., "ET-202511211036") |
| `ur_actualdate` | DateTime | Yes | Actual Date / Tatsächliches Datum | When the meal was consumed |
| `ur_food` | Memo | Recommended | Food / Lebensmittel | Description of food items |
| `ur_meal` | Choice | No | Meal / Mahlzeit | Meal type (Breakfast/Lunch/Dinner/Snack) |
| `ur_calories` | Decimal | No | Calories / Kalorien | Total calories (kcal) |

**ur_meal Choice Values:**
- `315810000` = Frühstück (Breakfast)
- `315810001` = Mittagessen (Lunch)
- `315810002` = Abendessen (Dinner)
- `315810003` = Snack (Snack)

### Image Fields

| Field Name | Type | Required | Display Name | Description |
|------------|------|----------|--------------|-------------|
| `ur_image` | Image | No | Image | Photo of meal (Base64 or URL) - **Max 5 MB recommended** |
| `ur_imageid` | GUID | No | Image ID | Image identifier |
| `ur_image_timestamp` | BigInt | No | Image Timestamp | Image upload timestamp |
| `ur_image_url` | String | No | Image URL | Image URL path |


### Relationship Fields

| Field Name | Type | Required | Display Name | Description |
|------------|------|----------|--------------|-------------|
| `ur_member` | Lookup | No | Member / Mitglied | Foreign key to contact (owner of diary entry) |
| `ur_membername` | String | No | Member Name | Cached name from contact |
| `ur_memberyominame` | String | No | Member Yomi Name | Japanese phonetic name |
| `ur_mealname` | String | No | Meal Name | Cached meal type name |

---

## System Fields (Standard Dataverse)

### Ownership & Security

| Field Name | Type | Description |
|------------|------|-------------|
| `ownerid` | Lookup | Owner of the record (user or team) |
| `owningbusinessunit` | Lookup | Business unit that owns the record |
| `owningteam` | Lookup | Team that owns the record |
| `owninguser` | Lookup | User that owns the record |

### Audit Fields

| Field Name | Type | Description |
|------------|------|-------------|
| `createdby` | Lookup | User who created the record |
| `createdon` | DateTime | When record was created |
| `createdbyname` | String | Name of creator |
| `modifiedby` | Lookup | User who last modified the record |
| `modifiedon` | DateTime | When record was last modified |
| `modifiedbyname` | String | Name of modifier |
| `createdonbehalfby` | Lookup | Delegate who created the record |
| `modifiedonbehalfby` | Lookup | Delegate who modified the record |

### State & Status

| Field Name | Type | Values | Description |
|------------|------|--------|-------------|
| `statecode` | State | 0=Active, 1=Inactive | Record state |
| `statuscode` | Status | 1=Active, 2=Inactive | Record status reason |

### Versioning & Import

| Field Name | Type | Description |
|------------|------|-------------|
| `versionnumber` | BigInt | Version number for optimistic concurrency |
| `importsequencenumber` | Integer | Import sequence number for data migration |
| `overriddencreatedon` | DateTime | Override created date during import |
| `timezoneruleversionnumber` | Integer | Time zone rule version |
| `utcconversiontimezonecode` | Integer | UTC conversion timezone code |

---

## Sample Data Records

### Record 1: Dinner (Abendessen)
```json
{
  "ur_name": "ET-202511211036",
  "ur_actualdate": "2025-11-03T17:00:00Z",
  "ur_meal": 315810002,
  "ur_meal@OData.Community.Display.V1.FormattedValue": "Abendessen",
  "ur_food": "150g Tofu (gebraten), 200g grüner Spargel (gedünstet), 100g Wildreis (gekocht)",
  "ur_calories": 450.0,
  "createdon": "2025-11-21T22:36:30Z",
  "modifiedon": "2025-11-22T09:19:59Z"
}
```

### Record 2: Breakfast (Frühstück)
```json
{
  "ur_name": "ET-202511211036",
  "ur_actualdate": "2025-11-04T07:00:00Z",
  "ur_meal": 315810000,
  "ur_meal@OData.Community.Display.V1.FormattedValue": "Frühstück",
  "ur_food": "1 Scheibe Vollkornbrot (ca. 50g), 1/2 Avocado (ca. 75g), 1 Ei (gekocht)",
  "ur_calories": 350.0,
  "createdon": "2025-11-21T22:36:30Z"
}
```

### Record 3: Snack
```json
{
  "ur_name": "ET-202511211036",
  "ur_actualdate": "2025-11-04T09:00:00Z",
  "ur_meal": 315810003,
  "ur_meal@OData.Community.Display.V1.FormattedValue": "Snack",
  "ur_food": "100g Beeren (frisch oder gefroren)",
  "ur_calories": 50.0,
  "createdon": "2025-11-21T22:36:30Z"
}
```

---

## Architecture: Diary + Log Design ✅ DECIDED

### Two-Table Strategy

**ur_nutritiondiary (Parent)** → User Input  
**ur_nutritionlog (Child)** → Detailed Food Items (1:M via `ur_regarding`)

```
┌─────────────────────────────────────┐
│     ur_nutritiondiary (Parent)      │
│  "User Input & Analysis Metadata"  │
├─────────────────────────────────────┤
│ ✅ ur_actualdate                    │
│ ✅ ur_meal (choice)                 │
│ ✅ ur_food (description)            │
│ ✅ ur_image                         │
│ ✅ ur_calories (optional/calculated) │
│ ✅ ur_snapcalorieresponse (JSON)    │
│ ⚠️  ur_snapcalorie_analyzed (TO ADD)│
│ ⚠️  ur_notes (TO ADD)                │
└─────────────────┬───────────────────┘
                  │ 1:M relationship
                  │ (ur_regarding)
                  │
     ┌────────────┼────────────┬───────────────┐
     │            │            │               │
     ▼            ▼            ▼               ▼
┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐
│ur_nutrition│ │ur_nutrition│ │ur_nutrition│ │ur_nutrition│
│log (Child1)│ │log (Child2)│ │log (Child3)│ │log (Child N)│
├────────────┤ ├────────────┤ ├────────────┤ ├────────────┤
│✅ ur_regarding│ │ur_regarding│ │ur_regarding│ │ur_regarding│
│✅ ur_food    │ │ur_food    │ │ur_food    │ │ur_food    │
│✅ ur_quantity│ │ur_quantity│ │ur_quantity│ │ur_quantity│
│✅ ur_calories│ │ur_calories│ │ur_calories│ │ur_calories│
│✅ ur_protein │ │ur_protein │ │ur_protein │ │ur_protein │
│✅ ur_carbs   │ │ur_carbs   │ │ur_carbs   │ │ur_carbs   │
│✅ ur_fat     │ │ur_fat     │ │ur_fat     │ │ur_fat     │
│⚠️ ur_brand   │ │ur_brand   │ │ur_brand   │ │ur_brand   │
│⚠️ ur_vitamina│ │ur_vitamina│ │ur_vitamina│ │ur_vitamina│
│              │ │           │ │           │ │           │
│Haferflocken  │ │Beeren     │ │Leinsamen  │ │...        │
│50g           │ │100g       │ │2.3g       │ │           │
└──────────────┘ └───────────┘ └───────────┘ └───────────┘
```

###Fields Strategy by Table

**ur_nutritiondiary (Parent) - What User Enters:**

| Field | Status | Purpose | Storage |
|-------|--------|---------|---------|
| `ur_actualdate` | ✅ EXISTS | When meal was consumed | User input |
| `ur_meal` | ✅ EXISTS | Breakfast/Lunch/Dinner/Snack | User selection |
| `ur_food` | ✅ EXISTS | Meal description for SnapCalorie | User input |
| `ur_image` | ✅ EXISTS | Optional meal photo | User upload |
| `ur_snapcalorieresponse` | Memo | ✅ EXISTS | Raw SnapCalorie JSON | API response |
| `ur_snapcalorieanalyzed` | Boolean | ✅ **ADDED** | AI vs manual entry flag | Backend sets |
| `ur_notes` | ⚠️  TO ADD | User notes | User input |
| `ur_calories` | ✅ EXISTS | Total calories | **Aggregated from SnapCalorie** OR user estimate |
| `ur_protein` | ✅ **IMPLEMENTED 2025-11-25** | Total protein | **Aggregated from SnapCalorie** |
| `ur_carbohydrates` | ✅ **IMPLEMENTED 2025-11-25** | Total carbs | **Aggregated from SnapCalorie** (maps to ur_carbs) |
| `ur_fat` | ✅ **IMPLEMENTED 2025-11-25** | Total fat | **Aggregated from SnapCalorie** |

**Azure Function Endpoint:** `POST /api/nutrition-diaries`

```http
POST /api/nutrition-diaries
Content-Type: application/json

{
  "contactId": "ce68c61c-3833-f011-8c4e-000d3ab53dff",
  "actualDate": "2025-11-25",
  "mealType": 315810000,  // Breakfast/Lunch/Dinner/Snack
  "description": "50g Haferflocken, 100g Beeren, 1 TL Leinsamen"
}
```

```

**✅ Status:** Working 
## Next Steps & Open Tasks

---

## Summary & Next Steps

### Current State ✅

1. **ur_nutritiondiary** has 48 fields including:
   - ✅ Core user input fields (date, meal, food, image)
   - ✅ `ur_snapcalorieresponse` (stores raw JSON)
   - ✅ `ur_snapcalorieanalyzed` (AI vs manual flag) ✅ **ADDED**
   - ⚠️  Missing: macros (can use calculated fields), ur_notes field

2. **ur_nutritionlog** has 60 fields including:
   - ✅ Relationship to parent (`ur_regarding`)
   - ✅ Core nutrition fields (calories, protein, carbs, fat, fiber, sugar, sodium, saturated fat)
   - ✅ Micronutrients (calcium, iron, vitamins, omega-3)
   - ✅ Food quality flags (ultra-processed, lean protein, healthy fat)
   - ⚠️  Missing: ur_brand, ur_snapcalorie_analyzed flag

### Architecture Decisions ✅

1. **Two-table design confirmed:**
   - Parent (ur_nutritiondiary) = user input + optional aggregates
   - Children (ur_nutritionlog) = detailed food items (1:M)

2. **Storage strategy:**
   - Detailed nutrition per food item in ur_nutritionlog
   - Aggregates either cached OR calculated from children

3. **Unit standardization:**
   - All `ur_quantity` values in ur_nutritionlog stored in **grams**

This allows incremental development without major schema changes upfront.
