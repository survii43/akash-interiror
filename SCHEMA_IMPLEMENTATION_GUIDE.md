# Schema Implementation Guide

## Quick Reference

### Model Files
- `lib/models/project_model.dart` - Enhanced Project model with measurement tracking
- `lib/models/work_item_model.dart` - Work items/measurements model
- `lib/models/deduction_model.dart` - Deductions model
- `lib/models/work_rate_model.dart` - Work rates model
- `lib/models/project_user_model.dart` - Project users and permissions model
- `lib/models/accountability_log_model.dart` - Audit trail model

### Documentation
- `PROJECT_SCHEMA_ANALYSIS.md` - Complete schema analysis and design documentation

## Implementation Checklist

### ✅ Phase 1: Models (COMPLETED)
- [x] Enhanced Project model with location, verification, and measurement fields
- [x] WorkItem model with dimensional and category data
- [x] Deduction model with reason and area calculations
- [x] WorkRate model with time-based validity
- [x] ProjectUser model with role-based permissions
- [x] AccountabilityLog model for audit trail

### 🔄 Phase 2: Database Service (PENDING)
- [ ] Add work_items table creation in `_onCreate`
- [ ] Add deductions table creation in `_onCreate`
- [ ] Add work_rates table creation in `_onCreate`
- [ ] Add project_users table creation in `_onCreate`
- [ ] Add accountability_logs table creation in `_onCreate`
- [ ] Add appropriate indexes for each table
- [ ] Implement CRUD operations for WorkItem
- [ ] Implement CRUD operations for Deduction
- [ ] Implement CRUD operations for WorkRate
- [ ] Implement CRUD operations for ProjectUser
- [ ] Implement CRUD operations for AccountabilityLog
- [ ] Implement calculation methods for project summaries
- [ ] Update Project CRUD to handle new fields

### 🔄 Phase 3: Providers & Services (PENDING)
- [ ] Create WorkItemProvider for state management
- [ ] Create DeductionProvider for state management
- [ ] Create WorkRateProvider for state management
- [ ] Create ProjectUserProvider for state management
- [ ] Create AccountabilityLogProvider for state management
- [ ] Create CalculationService for area and financial calculations
- [ ] Create PermissionService for role-based access control
- [ ] Create AuditService for logging changes

### 🔄 Phase 4: UI Screens (PENDING)
- [ ] Create WorkItem management screen
- [ ] Create Deduction management screen
- [ ] Create WorkRate management screen
- [ ] Create ProjectUser/Team management screen
- [ ] Create Project summary dashboard
- [ ] Create Audit log viewer screen
- [ ] Enhance Project form with new fields
- [ ] Create Project detail/verification screen

### 🔄 Phase 5: Forms & Validation (PENDING)
- [ ] WorkItem form with area calculations
- [ ] Deduction form with reason selection
- [ ] WorkRate form with date validation
- [ ] ProjectUser form with permission checkboxes
- [ ] Validation utilities for new entities
- [ ] Area conversion utilities

### 🔄 Phase 6: Integration & Testing (PENDING)
- [ ] Database migration from v1 to v2
- [ ] Data validation across relationships
- [ ] Permission checking implementation
- [ ] Calculation verification
- [ ] End-to-end testing
- [ ] Performance testing with large datasets

## Key Model Features

### Project (Enhanced)
```dart
Project(
  name: 'Bhawar Interiors - Chennai',
  location: 'State Street, Chennai',
  status: 'tender', // or active, completed, on-hold, cancelled
  createdBy: 'user_001',
  verifiedBy: null,
  verifiedOn: null,
  totalAreaSqm: null,
  totalDeductionSqm: null,
  totalClaimableSqm: null,
  totalClaimableSqft: null,
)
```

### WorkItem
```dart
WorkItem(
  projectId: 1,
  sNo: 1,
  description: 'Portal grey Side Wall (A)',
  workCategory: 'wall',
  unitOfMeasure: 'Meter',
  quantityCount: 2,
  lengthM: 2.44,
  widthM: 1.15,
  areaSqm: 5.612,
  areaSqft: 60.408,
  materialType: 'Portal Grey',
  imageRef: 'gs://project_images/portal_wall_a.jpg',
  remarks: 'Measured on-site',
)
```

### Deduction
```dart
Deduction(
  projectId: 1,
  workItemId: 1,
  reason: 'Window opening',
  lengthM: 1.15,
  widthM: 0.21,
  quantity: 2,
  areaSqm: 4.830,
  areaSqft: 51.96,
)
```

### WorkRate
```dart
WorkRate(
  projectId: 1,
  workCategory: 'wall',
  unit: 'sqft',
  rateValue: 250.0,
  currency: 'INR',
  effectiveFrom: DateTime(2025, 9, 1),
  effectiveTo: DateTime(2026, 3, 1),
)
```

### ProjectUser
```dart
ProjectUser(
  projectId: 1,
  name: 'Sourav Kumar',
  email: 'sourav@devtoolpro.com',
  role: 'designer',
  raciRole: 'A', // Accountable
  canEditMeasurements: true,
  canApproveDeductions: true,
  canViewTenders: true,
  canAddRates: false,
)
```

### AccountabilityLog
```dart
AccountabilityLog(
  projectId: 1,
  workItemId: 1,
  action: 'Approved deduction',
  performedBy: 'user_002',
  comments: 'Verified window cutout deduction by site engineer',
  changedFields: 'status',
  oldValues: '{"status": "pending"}',
  newValues: '{"status": "approved"}',
)
```

## Validation Examples

### WorkItem Validation
```dart
// Area calculation validation
assert(workItem.areaSqm == (workItem.lengthM * workItem.widthM * workItem.quantityCount));
assert((workItem.areaSqft - (workItem.areaSqm * 10.764)).abs() < 0.01); // Allow for rounding
```

### Deduction Validation
```dart
// Cannot exceed 100% of work item
assert(deduction.areaSqm <= workItem.areaSqm);
```

### WorkRate Validation
```dart
// Ensure date range is valid
assert(workRate.effectiveFrom.isBefore(workRate.effectiveTo ?? DateTime(2099, 12, 31)));

// Check if rate is effective on a specific date
bool isEffective = workRate.isEffective(DateTime.now());
```

### Project Validation
```dart
// Calculate totals
final totalAreaSqm = workItems.fold<double>(0, (sum, item) => sum + item.areaSqm);
final totalDeductionSqm = deductions.fold<double>(0, (sum, ded) => sum + ded.areaSqm);
final totalClaimableSqm = totalAreaSqm - totalDeductionSqm;
final totalClaimableSqft = totalClaimableSqm * 10.764;
```

## Permission Matrix

| Role | canEditMeasurements | canApproveDeductions | canViewTenders | canAddRates | canDeleteItems | canApproveProject |
|------|:---:|:---:|:---:|:---:|:---:|:---:|
| Admin | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Supervisor | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Engineer | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Designer | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Accountant | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| Viewer | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |

## Database Migration Strategy

### Version 1 → Version 2
```sql
-- No data loss migration strategy

-- New tables created in order of dependencies
1. work_items (depends on projects)
2. deductions (depends on projects and work_items)
3. work_rates (depends on projects)
4. project_users (depends on projects)
5. accountability_logs (depends on projects and work_items)

-- Existing projects table updated with new columns (nullable initially)
ALTER TABLE projects ADD COLUMN location TEXT;
ALTER TABLE projects ADD COLUMN createdBy TEXT;
ALTER TABLE projects ADD COLUMN totalAreaSqm REAL;
ALTER TABLE projects ADD COLUMN totalDeductionSqm REAL;
ALTER TABLE projects ADD COLUMN totalClaimableSqm REAL;
ALTER TABLE projects ADD COLUMN totalClaimableSqft REAL;
ALTER TABLE projects ADD COLUMN verifiedBy TEXT;
ALTER TABLE projects ADD COLUMN verifiedOn TEXT;
```

## Calculation Engine

### Area Conversions
```dart
const double SQM_TO_SQFT = 10.764;
const double SQFT_TO_SQM = 0.092903;

double toSquareFeet(double sqm) => sqm * SQM_TO_SQFT;
double toSquareMeter(double sqft) => sqft * SQFT_TO_SQM;
```

### Project Summary Calculations
```dart
class CalculationService {
  static ProjectSummary calculateProjectSummary(
    List<WorkItem> workItems,
    List<Deduction> deductions,
  ) {
    final totalAreaSqm = workItems.fold(0.0, (sum, item) => sum + item.areaSqm);
    final totalDeductionSqm = deductions.fold(0.0, (sum, ded) => sum + ded.areaSqm);
    final totalClaimableSqm = totalAreaSqm - totalDeductionSqm;
    final totalClaimableSqft = totalClaimableSqm * SQM_TO_SQFT;
    
    return ProjectSummary(
      totalAreaSqm: totalAreaSqm,
      totalDeductionSqm: totalDeductionSqm,
      totalClaimableSqm: totalClaimableSqm,
      totalClaimableSqft: totalClaimableSqft,
    );
  }

  static double calculateProjectValue(
    double claimableSqm,
    double rate,
  ) {
    return claimableSqm * rate;
  }
}
```

## Usage Examples

### Create a Project with Work Items
```dart
// 1. Create project
final project = Project(
  name: 'Bhawar Interiors',
  clientId: 5,
  location: 'State Street, Chennai',
  status: 'tender',
  createdBy: 'user_001',
);
final projectId = await databaseService.insertProject(project);

// 2. Create work items
final workItem = WorkItem(
  projectId: projectId,
  sNo: 1,
  description: 'Portal grey Side Wall',
  workCategory: 'wall',
  lengthM: 2.44,
  widthM: 1.15,
  areaSqm: 2.806,
  areaSqft: 30.204,
  quantityCount: 2,
  unitOfMeasure: 'Meter',
);
final workItemId = await databaseService.insertWorkItem(workItem);

// 3. Add deductions
final deduction = Deduction(
  projectId: projectId,
  workItemId: workItemId,
  reason: 'Window opening',
  lengthM: 1.15,
  widthM: 0.21,
  quantity: 2,
  areaSqm: 0.4830,
  areaSqft: 5.2,
);
await databaseService.insertDeduction(deduction);

// 4. Add team members
final user = ProjectUser(
  projectId: projectId,
  name: 'Sourav Kumar',
  email: 'sourav@devtoolpro.com',
  role: 'engineer',
  raciRole: 'A',
  canEditMeasurements: true,
);
await databaseService.insertProjectUser(user);

// 5. Log action
final log = AccountabilityLog(
  projectId: projectId,
  action: 'Added work item',
  performedBy: 'user_001',
  comments: 'Initial measurement from site survey',
);
await databaseService.insertAccountabilityLog(log);
```

### Query Project Data
```dart
// Get all work items for a project
final workItems = await databaseService.getWorkItemsByProject(projectId);

// Get all deductions for a project
final deductions = await databaseService.getDeductionsByProject(projectId);

// Get effective work rate for a category on a specific date
final rate = await databaseService.getEffectiveWorkRate(
  projectId: projectId,
  workCategory: 'wall',
  date: DateTime.now(),
);

// Get active project users
final users = await databaseService.getActiveProjectUsers(projectId);

// Get audit trail for a project
final logs = await databaseService.getAccountabilityLogs(projectId);
```

## Testing Strategy

### Unit Tests
- Model validation (status, categories, permissions)
- Area calculations and conversions
- Date range validations
- Permission checking logic

### Integration Tests
- CRUD operations for all new models
- Foreign key constraints
- Cascade delete behavior
- Transaction handling

### UI Tests
- Form validation and submission
- Data binding and updates
- Error handling and messages
- Permission-based UI visibility

## Performance Considerations

### Indexes (Already recommended in PROJECT_SCHEMA_ANALYSIS.md)
- Index on (projectId) for fast filtering
- Index on (status, workCategory) for complex queries
- Index on (timestamp) for log sorting

### Query Optimization
- Use pagination for large lists
- Lazy load related data
- Cache frequently accessed rates
- Batch operations for accountability logs

### Database Optimization
- Enable WAL (Write-Ahead Logging) mode
- Vacuum database periodically
- Archive old completed projects
- Partition logs by date range

## Next Steps

1. **Start Phase 2**: Update DatabaseService with new table creation and CRUD operations
2. **Add Tests**: Create comprehensive unit and integration tests
3. **Create Providers**: Implement state management for new entities
4. **Build UI**: Create screens for managing all new entities
5. **Integration**: Connect everything together and test end-to-end
6. **Deploy**: Gradual rollout with data migration support

## Support & Questions

Refer to `PROJECT_SCHEMA_ANALYSIS.md` for detailed documentation of each entity, relationships, calculation rules, and validation requirements.
