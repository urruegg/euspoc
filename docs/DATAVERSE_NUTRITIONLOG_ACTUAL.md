# Dataverse ur_nutritionlog Table - Actual Schema Discovery

**Date:** November 25, 2025  
**Discovery Method:** Direct Dataverse API query  
**Status:** ✅ **TABLE EXISTS AND IS IN USE**

---

## Key Finding

The `ur_nutritionlog` table **already exists** in Dataverse and contains nutrition data! This is different from our initial analysis which suggested it needed to be created.

---

## Actual Table Schema (Discovered)

### Primary Fields

| Field Name | Type | Sample Value | Purpose |
|------------|------|--------------|---------|
| `ur_nutritionlogid` | GUID | `922c9473-4cc5-f011-bbd2-7ced8d770a33` | Primary key |
| `ur_name` | Text | `EP-20251119-2519` | Auto-generated name |
| `_ur_member_value` | Lookup (GUID) | `889f515e-379c-4b49-ac85-92b1189136f5` | FK to contact |
| `ur_date` | DateTime | `2025-11-17T17:00:00Z` | Date of meal |
| `ur_meal` | Choice | `315810002` (Dinner) | Meal type |
| `ur_food` | Text | `Pizza Prosciutto e Funghi` | Food description |

### Nutrition Fields

| Field Name | Type | Sample Value | Description |
|------------|------|--------------|-------------|
| `ur_quantity` | Decimal | `350` | Portion size |
| `ur_nutritionunit` | Choice | `315810001` (grams) | Unit of measurement |
| `ur_calories` | Decimal | `718.0` | Calories (kcal) |
| `ur_protein` | Decimal | `37.1` | Protein (g) |
| `ur_carbs` | Decimal | `84.0` | Carbohydrates (g) |
| `ur_fat` | Decimal | `24.5` | Total fat (g) |
| `ur_fiber` | Decimal | `5.6` | Fiber (g) |
| `ur_sugar` | Decimal | `4.6` | Sugar (g) |
| `ur_saturates` | Decimal | `9.8` | Saturated fat (g) |
| `ur_sodium` | Decimal | `1120.0` | Sodium (mg) |
| `ur_potassium` | Decimal | `735.0` | Potassium (mg) |
| `ur_cholesterol` | Decimal | `49.0` | Cholesterol (mg) |

### System Fields

| Field Name | Type | Description |
|------------|------|-------------|
| `createdon` | DateTime | Record creation timestamp |
| `modifiedon` | DateTime | Last modification timestamp |
| `_createdby_value` | GUID | User who created |
| `_modifiedby_value` | GUID | User who modified |
| `statecode` | Integer | 0 = Active, 1 = Inactive |
| `statuscode` | Integer | Status reason code |
| `versionnumber` | Long | Row version number |

### Image Fields (Currently Unused)

| Field Name | Type | Current Status |
|------------|------|----------------|
| `ur_image` | Image | `null` in all records |
| `ur_image_url` | Text | `null` in all records |
| `ur_imageid` | GUID | `null` in all records |
| `ur_image_timestamp` | Long | `null` in all records |
| `ur_description` | Memo | `null` in all records |

---

## Sample Data Records

### Record 1: Pizza Prosciutto e Funghi
```json
{
  "ur_name": "EP-20251119-2519",
  "ur_food": "Pizza Prosciutto e Funghi",
  "ur_quantity": 350,
  "ur_nutritionunit": 315810001,  // grams
  "ur_meal": 315810002,  // Dinner
  "ur_date": "2025-11-17T17:00:00Z",
  "ur_calories": 718.0,
  "ur_protein": 37.1,
  "ur_carbs": 84.0,
  "ur_fat": 24.5,
  "ur_fiber": 5.6,
  "ur_sugar": 4.6,
  "ur_saturates": 9.8,
  "ur_sodium": 1120.0,
  "ur_potassium": 735.0,
  "ur_cholesterol": 49.0,
  "_ur_member_value": "889f515e-379c-4b49-ac85-92b1189136f5"
}
```

### Record 2: Red Bull Sugarfree
```json
{
  "ur_name": "EP-20251119-2520",
  "ur_food": "Red Bull Sugarfree",
  "ur_quantity": 250,
  "ur_nutritionunit": 315810011,  // ml
  "ur_meal": 315810003,  // Snack
  "ur_date": "2025-11-17T05:00:00Z",
  "ur_calories": 8.0,
  "ur_protein": 0.0,
  "ur_carbs": 0.0,
  "ur_fat": 0.0,
  "ur_fiber": 0.0,
  "ur_sugar": 0.0,
  "ur_saturates": 0.0,
  "ur_sodium": 104.0,
  "_ur_member_value": "889f515e-379c-4b49-ac85-92b1189136f5"
}
```

### Record 3: Apfel (Apple)
```json
{
  "ur_name": "EP-20251119-2521",
  "ur_food": "Apfel",
  "ur_quantity": 150,
  "ur_nutritionunit": 315810001,  // grams
  "ur_calories": 78.0,
  "ur_protein": 0.4,
  "ur_carbs": 19.8,
  "ur_fat": 0.3,
  "ur_fiber": 3.0,
  "_ur_member_value": "889f515e-379c-4b49-ac85-92b1189136f5"
}
```

---

## Schema Comparison: Actual vs. Proposed

### ✅ Fields That Already Exist
- `ur_calories` ✓
- `ur_protein` ✓
- `ur_carbs` ✓
- `ur_fat` ✓
- `ur_fiber` ✓
- `ur_sugar` ✓
- `ur_sodium` ✓
- `ur_saturates` ✓
- `ur_potassium` ✓
- `ur_cholesterol` ✓


## Current Usage Statistics

**Query Date:** November 25, 2025  
**Sample Size:** 5 most recent records

### Data Observations:
- ✅ Table is actively used (records from Nov 17-19, 2025)
- ✅ Multiple meal types: Breakfast, Lunch, Dinner, Snack
- ✅ Diverse foods: Pizza, Red Bull, Apple, Salmon, Whole grain bread
- ✅ Proper nutrition data populated
- ✅ Linked to member contact IDs
- ⚠️ All records belong to same member: `889f515e-379c-4b49-ac85-92b1189136f5`
- ⚠️ No records found for Max Mustermann (`ce68c61c-3833-f011-8c4e-000d3ab53dff`)
- ❌ Image fields unused (all null)
- ❌ Description field unused (all null)

---

## Choice Field Values (Discovered)

### ur_meal (Meal Type)
- `315810000` = Breakfast
- `315810001` = Lunch
- `315810002` = Dinner
- `315810003` = Snack

### ur_nutritionunit (Unit of Measurement)
- `315810001` = grams (g)
- `315810011` = milliliters (ml)
- `315810016` = units/pieces (discovered in earlier record)

---

## Relationship to ur_nutritiondiary

**Current Structure Discovery:**
- `ur_nutritionlog` appears to be a **standalone log table**
- Each record represents ONE food item consumed
- Multiple records per day per member
- No explicit FK to `ur_nutritiondiary` found in sample data

**Question for Investigation:**
Is there a parent-child relationship between `ur_nutritiondiary` and `ur_nutritionlog`?
- Each `ur_nutritiondiary` entry has multiple `ur_nutritionlog` children (meal → food items)

---

## Files Created
- `DATAVERSE_NUTRITIONLOG_ACTUAL.md` - This document
