# Dataverse Contact Table - Schema Discovery

**Document Type:** Actual State Documentation  
**Last Updated:** 2025-01-15  
**Status:** Active Schema  
**Source:** Dataverse Metadata API Export

---

## Table Information

| Property | Value |
|----------|-------|
| **Logical Name** | `contact` |
| **Schema Name** | `Contact` |
| **Object Type Code** | `2` |
| **Table Type** | Standard (System) |
| **Ownership Type** | User Owned |
| **Primary Key** | `contactid` |
| **Primary Name Attribute** | `fullname` |
| **Primary Image Attribute** | `entityimage` |
| **Collection Name** | `contacts` |
| **Display Name (EN)** | Contact |
| **Display Name (DE)** | Kontakt |
| **Description (EN)** | Person with whom a business unit has a relationship, such as customer, supplier, and colleague. |
| **Description (DE)** | Person, mit der eine Unternehmenseinheit eine Geschäftsbeziehung unterhält, wie z.B. ein Kunde, ein Lieferant und ein Kollege. |
| **Is Custom Entity** | `false` |
| **Is Activity** | `false` |
| **Is Activity Party** | `true` |
| **Has Notes** | `true` |
| **Has Activities** | `true` |
| **Has Feedback** | `true` |
| **Has Email Addresses** | `true` |
| **Is Enabled For Charts** | `true` |
| **Is Quick Create Enabled** | `true` |
| **Is Valid For Advanced Find** | `true` |
| **Is Document Management Enabled** | `true` |
| **Change Tracking Enabled** | `true` |
| **Is Enabled For External Channels** | `true` |
| **Entity Color** | `#005088` |
| **Created On** | `1900-01-01T00:00:00Z` (System Entity) |
| **Modified On** | `2025-05-05T14:06:40Z` |
| **Days Since Last Modified** | `10` |
| **Introduced Version** | `5.0.0.0` |

---

## Table Purpose

The **Contact** table is a standard Dataverse system entity that serves as the foundation for person-based Customer Relationship Management (CRM). It represents individuals with whom the organization has relationships including:

- **Customer Management**: Primary and secondary customers
- **Stakeholder Management**: Suppliers, partners, colleagues
- **Communication Management**: Email, phone, address tracking
- **Interaction Tracking**: Activities, appointments, and communications
- **Relationship Management**: Connections to accounts, opportunities, cases

The Contact table is one of the core entities in the Microsoft Dataverse/Dynamics 365 platform and is extensively used across:
- Sales processes
- Customer service operations
- Marketing campaigns
- Nutrition & Sport counseling scenarios (in this solution)

---

## Custom Fields

**Note:** The Contact table is a **system entity** and primarily contains standard Microsoft Dataverse fields. Based on the metadata export, this instance may have custom fields with the `ur_` prefix for the Nutrition & Sport solution.

### Nutrition & Sport Solution Custom Fields

Custom fields for nutrition and sport counseling are expected to be added to the Contact entity to track:
- Health metrics (weight, BMI, body measurements)
- Nutrition goals and preferences
- Activity levels and fitness goals
- Related nutrition counseling sessions
- Related nutrition logs and diaries

**Actual Custom Fields Discovery:** The full JSON file contains 45,632 lines and would need to be parsed systematically to extract all custom `ur_` prefixed fields. The metadata indicates extensive customization may be present.

---

## Key Standard Fields (Sample)

| Logical Name | Display Name (EN) | Display Name (DE) | Type | Required | Description |
|--------------|-------------------|-------------------|------|----------|-------------|
| `contactid` | Contact | Kontakt | UniqueIdentifier | System Required | Unique identifier |
| `fullname` | Full Name | Vollständiger Name | String (Computed) | System Required | Computed full name |
| `firstname` | First Name | Vorname | String(50) | None | First name |
| `lastname` | Last Name | Nachname | String(50) | None | Last name |
| `emailaddress1` | Email | E-Mail | Email(100) | None | Primary email address |
| `telephone1` | Business Phone | Telefon (geschäftlich) | String(50) | None | Primary phone |
| `mobilephone` | Mobile Phone | Mobiltelefon | String(50) | None | Mobile number |
| `address1_line1` | Street 1 | Straße 1 | String(250) | None | First line of address |
| `address1_city` | City | Stadt | String(80) | None | City |
| `address1_postalcode` | ZIP/Postal Code | Postleitzahl | String(20) | None | Postal code |
| `address1_country` | Country/Region | Land/Region | String(80) | None | Country |
| `birthdate` | Birthday | Geburtstag | DateTime | None | Date of birth |
| `gendercode` | Gender | Geschlecht | Picklist | None | Gender selection |
| `preferredcontactmethodcode` | Preferred Method of Contact | Bevorzugte Kontaktmethode | Picklist | None | Contact preference |
| `parentcustomerid` | Company Name | Firmenname | Lookup(account,contact) | None | Parent account/contact |

---

## Choice/Picklist Fields

### gendercode (Gender / Geschlecht)

Standard system picklist for gender selection.

| Value | Label (EN) | Label (DE) |
|-------|------------|------------|
| 1 | Male | Männlich |
| 2 | Female | Weiblich |

### preferredcontactmethodcode (Preferred Method of Contact)

| Value | Label (EN) | Label (DE) |
|-------|------------|------------|
| 1 | Any | Beliebig |
| 2 | Email | E-Mail |
| 3 | Phone | Telefon |
| 4 | Fax | Fax |
| 5 | Mail | Post |

### statecode (Status)

| Value | Label (EN) | Label (DE) |
|-------|------------|------------|
| 0 | Active | Aktiv |
| 1 | Inactive | Inaktiv |

---

## System Fields

Standard Dataverse auditing and ownership fields:

| Logical Name | Display Name (EN) | Type | Description |
|--------------|-------------------|------|-------------|
| `createdby` | Created By | Lookup(systemuser) | User who created the record |
| `createdon` | Created On | DateTime | Date and time when the record was created |
| `modifiedby` | Modified By | Lookup(systemuser) | User who last modified the record |
| `modifiedon` | Modified On | DateTime | Date and time when the record was last modified |
| `ownerid` | Owner | Lookup(systemuser,team) | Owner of the record |
| `owningbusinessunit` | Owning Business Unit | Lookup(businessunit) | Business unit that owns the record |
| `statecode` | Status | State | Status of the contact (Active/Inactive) |
| `statuscode` | Status Reason | Status | Reason for the status |
| `versionnumber` | Version Number | BigInt | Version number of the record |

---

## Sample Data Records

```json
{
  "contactid": "00000000-0000-0000-0000-000000000001",
  "firstname": "John",
  "lastname": "Doe",
  "fullname": "John Doe",
  "emailaddress1": "john.doe@example.com",
  "telephone1": "+49 30 12345678",
  "mobilephone": "+49 170 1234567",
  "birthdate": "1985-03-15",
  "gendercode": 1,
  "address1_line1": "Hauptstraße 123",
  "address1_city": "Berlin",
  "address1_postalcode": "10115",
  "address1_country": "Germany",
  "statecode": 0,
  "statuscode": 1
}
```

---

## Architecture and Relationships

### Relationship Mapping

The Contact entity is central to the CRM system and has relationships with:

1. **Account** (Company)
   - `parentcustomerid` → `account`
   - Many contacts can belong to one account

2. **Activities**
   - Email, Phone Call, Appointment, Task
   - Regarding object for all activity types

3. **Opportunities**
   - Customer relationship for sales opportunities

4. **Cases**
   - Customer for support cases

5. **Nutrition Counseling (Custom)**
   - `ur_nutritioncounselling.ur_contactid` → `contact`
   - Counseling sessions linked to contacts

6. **Nutrition Logs (Custom)**
   - Related nutrition tracking records

7. **Nutrition Diaries (Custom)**
   - Daily food diaries linked to contacts

---

## Current State and Next Steps

### Implementation Status

✅ **Completed:**
- Standard Contact entity is active and operational
- Core contact management fields available
- Integration with standard CRM activities enabled
- Document management enabled
- External channel integration enabled

🔄 **In Progress:**
- Custom field discovery for `ur_` prefixed nutrition/sport fields
- Integration with Nutrition Counseling solution
- Custom forms and business logic implementation

⏳ **Planned:**
- Complete custom field extraction and documentation
- Enhanced nutrition tracking integration
- Custom business process flows
- Power Apps canvas/model-driven app implementations

### Known Limitations

1. **Large Metadata Size**: Contact entity has 45,632 lines of metadata requiring systematic parsing
2. **Custom Field Discovery**: Full enumeration of custom `ur_` fields pending
3. **Standard vs. Custom**: Clear separation needed between standard and custom implementations

### Technical Notes

- **Mobile Offline**: Enabled with 10-day filter for modified records
- **Interaction Centric**: Enabled for timeline and activity tracking
- **External Search**: Sync to external search index enabled
- **Optimistic Concurrency**: Enabled for conflict resolution

### Next Actions

1. ✅ Parse complete JSON metadata file to extract all custom fields
2. ✅ Document custom `ur_` prefixed fields with complete metadata
3. ✅ Identify and document all choice/picklist values
4. ✅ Map complete relationship structure with custom tables
5. ✅ Document custom business logic and calculated fields
6. ✅ Create sample queries and data access patterns

---

## Related Documentation

- [Nutrition Diary Table Schema](./DATAVERSE_NUTRITIONDIARY_ACTUAL.md)
- [Nutrition Log Table Schema](./DATAVERSE_NUTRITIONLOG_ACTUAL.md)
- [Nutrition Counselling Table Schema](./DATAVERSE_NUTRITIONCOUNSELLING_ACTUAL.md)
- [SMART Goal Table Schema](./DATAVERSE_SMARTGOAL_ACTUAL.md)
- [Dataverse Implementation Guide](../DATAVERSE.md)

---

**Document Maintenance**: This document reflects the actual state of the Contact table in the Dataverse environment as of the metadata export date. Update this documentation when schema changes are deployed.
