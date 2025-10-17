# Enhanced Project Schema Analysis

## Overview
This document provides a comprehensive analysis of the enhanced project management schema for the Akash App. The schema has been designed to support complex project measurement, deduction tracking, work rate management, and accountability logging.

## Schema Architecture

### 1. Core Entities

#### A. Projects (Enhanced)
**Purpose**: Central entity representing a construction/interior design project
**Enhancements from existing schema**:
- Added `location` (State Street, Chennai)
- Added `createdBy` (user who created the project)
- Added measurement summary fields:
  - `totalAreaSqm`: Total measured area in square meters
  - `totalDeductionSqm`: Total deductions in square meters
  - `totalClaimableSqm`: Claimable area after deductions
  - `totalClaimableSqft`: Claimable area in square feet
- Added verification fields:
  - `verifiedBy`: User who verified the measurements
  - `verifiedOn`: Timestamp of verification
- Updated `status` to support more states:
  - `tender`: Project in bidding phase
  - `active`: Project in progress
  - `completed`: Project finished
  - `on-hold`: Project paused
  - `cancelled`: Project cancelled

**Database Fields**:
```
Projects Table:
- id (PK, INTEGER)
- name (TEXT NOT NULL)
- description (TEXT)
- clientId (FK to Clients)
- status (TEXT: tender|active|completed|on-hold|cancelled)
- startDate (TEXT ISO8601)
- endDate (TEXT ISO8601)
- budget (REAL)
- location (TEXT)
- createdBy (TEXT - user identifier)
- createdAt (TEXT ISO8601)
- updatedAt (TEXT ISO8601)
- totalAreaSqm (REAL)
- totalDeductionSqm (REAL)
- totalClaimableSqm (REAL)
- totalClaimableSqft (REAL)
- verifiedBy (TEXT - user identifier)
- verifiedOn (TEXT ISO8601)
```

#### B. Work Items
**Purpose**: Represent individual work items/measurements within a project
**Key Features**:
- Serial number (`sNo`) for item ordering
- Dimensional data: `lengthM`, `widthM`
- Calculated areas: `areaSqm`, `areaSqft`
- Quantity tracking: `quantityCount`
- Classification: `workCategory` (wall, floor, ceiling, door, window, etc.)
- Material tracking: `materialType`
- Image references for documentation: `imageRef`
- Remarks for on-site notes

**Database Fields**:
```
WorkItems Table:
- id (PK, INTEGER)
- projectId (FK to Projects)
- sNo (INTEGER - serial number)
- description (TEXT)
- unitOfMeasure (TEXT: Meter|sqft|sqm|Count|Liter|kg)
- quantityCount (INTEGER)
- lengthM (REAL)
- widthM (REAL)
- areaSqm (REAL)
- areaSqft (REAL)
- materialType (TEXT nullable)
- workCategory (TEXT: wall|floor|ceiling|door|window|finishing|other)
- imageRef (TEXT - cloud path or reference)
- remarks (TEXT nullable)
- createdAt (TEXT ISO8601)
- updatedAt (TEXT ISO8601 nullable)
```

#### C. Deductions
**Purpose**: Track deductions from work items (e.g., window openings, pipe penetrations)
**Key Features**:
- Linked to `workItemId` for traceability
- Reason categorization: Window opening, Door opening, Pipe, Electrical outlet, Damage, Other
- Dimensional data: `lengthM`, `widthM`, `quantity`
- Calculated areas: `areaSqm`, `areaSqft`
- Full audit trail with timestamps

**Database Fields**:
```
Deductions Table:
- id (PK, INTEGER)
- projectId (FK to Projects)
- workItemId (FK to WorkItems)
- reason (TEXT: Window opening|Door opening|Pipe|etc.)
- lengthM (REAL)
- widthM (REAL)
- quantity (INTEGER)
- areaSqm (REAL)
- areaSqft (REAL)
- createdAt (TEXT ISO8601)
- updatedAt (TEXT ISO8601 nullable)
```

#### D. Work Rates
**Purpose**: Define rates for different work categories and manage rate variations
**Key Features**:
- Category-based rates: Different rates for walls, floors, etc.
- Unit flexibility: Support multiple unit types (sqft, sqm, meter, count)
- Rate validity period: `effectiveFrom` to `effectiveTo`
- Currency support: INR, USD, EUR, GBP
- Time-based rate queries: Check if rate is effective on a specific date

**Database Fields**:
```
WorkRates Table:
- id (PK, INTEGER)
- projectId (FK to Projects)
- workCategory (TEXT)
- unit (TEXT)
- rateValue (REAL)
- currency (TEXT: INR|USD|EUR|GBP)
- effectiveFrom (TEXT ISO8601)
- effectiveTo (TEXT ISO8601 nullable)
- createdAt (TEXT ISO8601)
- updatedAt (TEXT ISO8601 nullable)
```

#### E. Project Users (Team Management)
**Purpose**: Manage team members and their permissions for each project
**Key Features**:
- Role-based access: designer, engineer, supervisor, accountant, admin, viewer
- RACI Matrix support: R (Responsible), A (Accountable), C (Consulted), I (Informed)
- Granular permissions:
  - `canEditMeasurements`: Can modify work items
  - `canApproveDeductions`: Can approve/reject deductions
  - `canViewTenders`: Can view tender information
  - `canAddRates`: Can add/modify rates
  - `canDeleteItems`: Can delete work items
  - `canApproveProject`: Can approve final project
- Assignment tracking: `assignedAt`, `removedAt`
- Active status check: `isActive()` method

**Database Fields**:
```
ProjectUsers Table:
- id (PK, INTEGER)
- projectId (FK to Projects)
- name (TEXT)
- email (TEXT)
- role (TEXT: designer|engineer|supervisor|accountant|admin|viewer)
- raciRole (TEXT: R|A|C|I)
- canEditMeasurements (INTEGER boolean)
- canApproveDeductions (INTEGER boolean)
- canViewTenders (INTEGER boolean)
- canAddRates (INTEGER boolean)
- canDeleteItems (INTEGER boolean)
- canApproveProject (INTEGER boolean)
- assignedAt (TEXT ISO8601)
- removedAt (TEXT ISO8601 nullable)
- createdAt (TEXT ISO8601)
- updatedAt (TEXT ISO8601 nullable)
```

#### F. Accountability Logs
**Purpose**: Complete audit trail of all actions and changes
**Key Features**:
- Action tracking: Pre-defined actions (Approved deduction, Added work item, etc.)
- User attribution: Track who performed the action
- Change tracking: Capture what changed, old values, and new values
- Comments: Support for explanatory notes
- Related item tracking: Links to workItemId when applicable

**Database Fields**:
```
AccountabilityLogs Table:
- id (PK, INTEGER)
- projectId (FK to Projects)
- workItemId (FK to WorkItems nullable)
- action (TEXT - pre-defined actions)
- performedBy (TEXT - user identifier)
- comments (TEXT nullable)
- timestamp (TEXT ISO8601)
- changedFields (TEXT - JSON string)
- oldValues (TEXT - JSON string)
- newValues (TEXT - JSON string)
```

### 2. Client Integration
The existing Client entity remains the central reference for projects. Each project is linked to exactly one client through the `clientId` foreign key.

**Client Table** (existing, unchanged):
```
Clients Table:
- id (PK, INTEGER)
- name (TEXT NOT NULL)
- email (TEXT NOT NULL UNIQUE)
- phone (TEXT NOT NULL)
- address (TEXT nullable)
- company (TEXT nullable)
- createdAt (TEXT ISO8601)
- updatedAt (TEXT ISO8601 nullable)
- dataTier (TEXT DEFAULT 'active')
- isArchived (INTEGER DEFAULT 0)
- archivedAt (TEXT nullable)
```

## Relationships & Cardinality

```
Clients (1) ──→ (N) Projects
Projects (1) ──→ (N) WorkItems
Projects (1) ──→ (N) Deductions
WorkItems (1) ──→ (N) Deductions
Projects (1) ──→ (N) WorkRates
Projects (1) ──→ (N) ProjectUsers
Projects (1) ──→ (N) AccountabilityLogs
WorkItems (1) ──→ (N) AccountabilityLogs (optional)
```

## Data Flow & Usage Scenarios

### Scenario 1: Project Creation & Measurement
1. Create a new Project with `status: 'tender'`
2. Define WorkRates for this project
3. Add ProjectUsers with appropriate roles and permissions
4. Create WorkItems with measurements
5. Add Deductions for openings and obstacles
6. Log each action in AccountabilityLogs

### Scenario 2: Measurement Verification
1. User with permission reviews all WorkItems and Deductions
2. System calculates totals:
   - `totalAreaSqm = SUM(WorkItem.areaSqm) - SUM(Deduction.areaSqm)`
   - `totalClaimableSqm = totalAreaSqm` (or adjusted by rules)
   - `totalClaimableSqft = totalClaimableSqm * 10.764` (conversion)
3. Verification stored in Project: `verifiedBy`, `verifiedOn`
4. Status changes from 'tender' to 'active'
5. AccountabilityLog entry: "Verified measurements by engineer_001"

### Scenario 3: Rate-Based Valuation
1. Query effective WorkRate for specific category and date
2. Calculate: `Value = Claimable_Area × Rate`
3. Store calculation reference for audit trail

### Scenario 4: Change Tracking
1. User modifies a WorkItem
2. Before saving, capture old values
3. Save new values to WorkItem
4. Log change in AccountabilityLog with details
5. Supports rollback and audit requirements

## Indexes & Performance

Recommended database indexes for optimal performance:

```sql
-- Projects
CREATE INDEX idx_projects_clientId ON projects(clientId);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_location ON projects(location);

-- WorkItems
CREATE INDEX idx_workitems_projectId ON work_items(projectId);
CREATE INDEX idx_workitems_category ON work_items(workCategory);
CREATE INDEX idx_workitems_sNo ON work_items(projectId, sNo);

-- Deductions
CREATE INDEX idx_deductions_projectId ON deductions(projectId);
CREATE INDEX idx_deductions_workItemId ON deductions(workItemId);

-- WorkRates
CREATE INDEX idx_workrates_projectId ON work_rates(projectId);
CREATE INDEX idx_workrates_category ON work_rates(workCategory);
CREATE INDEX idx_workrates_effective ON work_rates(effectiveFrom, effectiveTo);

-- ProjectUsers
CREATE INDEX idx_projectusers_projectId ON project_users(projectId);
CREATE INDEX idx_projectusers_email ON project_users(email);
CREATE INDEX idx_projectusers_active ON project_users(removedAt);

-- AccountabilityLogs
CREATE INDEX idx_accountlogs_projectId ON accountability_logs(projectId);
CREATE INDEX idx_accountlogs_action ON accountability_logs(action);
CREATE INDEX idx_accountlogs_timestamp ON accountability_logs(timestamp);
```

## Validation Rules

### Project
- Status must be one of: tender, active, completed, on-hold, cancelled
- startDate must be before or equal to endDate
- verifiedOn must be after project creation

### WorkItem
- workCategory must be from predefined list
- unitOfMeasure must be from predefined list
- areaSqm must equal (lengthM × widthM × quantityCount)
- areaSqft must equal (areaSqm × 10.764)

### Deduction
- reason must be from predefined list
- areaSqm must equal (lengthM × widthM × quantity)
- areaSqft must equal (areaSqm × 10.764)
- Total deductions cannot exceed 100% of work item area

### WorkRate
- rateValue must be positive
- currency must be from predefined list
- effectiveFrom must be before effectiveTo
- Cannot have overlapping rates for same category

### ProjectUser
- role must be from predefined list
- raciRole must be one of: R, A, C, I
- Cannot assign same user twice to same project

## Calculation Rules

### Area Conversions
```
1 sqm = 10.764 sqft
1 sqft = 0.092903 sqm
```

### Project Summary Calculations
```
totalAreaSqm = SUM(work_items.areaSqm)
totalDeductionSqm = SUM(deductions.areaSqm)
totalClaimableSqm = totalAreaSqm - totalDeductionSqm
totalClaimableSqft = totalClaimableSqm × 10.764
```

### Financial Calculations
```
ProjectValue = totalClaimableSqm × applicable_rate
```

## Security & Permissions

### Permission Hierarchy
1. **Admin**: Full access to all operations
2. **Project Accountable (RACI A)**: Can approve major changes
3. **Supervisors**: Can approve deductions and measurements
4. **Engineers**: Can edit measurements and add rates
5. **Designers**: Can view and comment
6. **Viewers**: Read-only access

### Audit Requirements
- All modifications tracked with user, timestamp, and details
- Change reasons must be documented
- Cannot delete, only mark as removed with timestamp
- Historical data preserved for compliance

## Implementation Notes

### Models Created
1. `Project` (Enhanced from existing)
2. `WorkItem` (New)
3. `Deduction` (New)
4. `WorkRate` (New)
5. `ProjectUser` (New)
6. `AccountabilityLog` (New)

### Database Tables to Create
1. `work_items`
2. `deductions`
3. `work_rates`
4. `project_users`
5. `accountability_logs`

### Next Steps for Implementation
1. Update DatabaseService with CRUD operations for new entities
2. Create database migration strategy
3. Implement calculation engine for summaries
4. Build UI screens for each entity
5. Implement permission checking system
6. Create reporting and analytics features

## Example Data Structure (JSON)

```json
{
  "project": {
    "id": 1,
    "name": "Bhawar Interiors - Chennai",
    "clientId": 5,
    "location": "State Street, Chennai",
    "status": "active",
    "createdBy": "user_001",
    "verifiedBy": "user_002",
    "verifiedOn": "2025-10-15T10:00:00Z",
    "totalAreaSqm": 39.462,
    "totalDeductionSqm": 15.726,
    "totalClaimableSqm": 23.736,
    "totalClaimableSqft": 255.39
  },
  "workItems": [
    {
      "id": 1,
      "sNo": 1,
      "description": "Portal grey Side Wall (A)",
      "workCategory": "wall",
      "lengthM": 2.44,
      "widthM": 1.15,
      "areaSqm": 2.806,
      "areaSqft": 30.204
    }
  ],
  "deductions": [
    {
      "id": 1,
      "workItemId": 1,
      "reason": "Window opening",
      "lengthM": 1.15,
      "widthM": 0.21,
      "quantity": 2,
      "areaSqm": 0.4830,
      "areaSqft": 5.2
    }
  ],
  "workRates": [
    {
      "id": 1,
      "workCategory": "wall",
      "unit": "sqft",
      "rateValue": 250.0,
      "currency": "INR",
      "effectiveFrom": "2025-09-01",
      "effectiveTo": "2026-03-01"
    }
  ],
  "projectUsers": [
    {
      "id": 1,
      "name": "Sourav Kumar",
      "email": "sourav@devtoolpro.com",
      "role": "designer",
      "raciRole": "A",
      "permissions": {
        "canEditMeasurements": true,
        "canApproveDeductions": true,
        "canViewTenders": true
      }
    }
  ]
}
```

## Summary

This enhanced schema provides:
- ✅ Comprehensive project measurement tracking
- ✅ Deduction management with full audit trail
- ✅ Rate management with time-based validity
- ✅ Team collaboration with role-based access
- ✅ Complete accountability and change tracking
- ✅ Financial calculations and validation
- ✅ Scalability for complex projects
- ✅ Integration with existing client structure
