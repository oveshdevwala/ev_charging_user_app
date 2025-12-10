# Partners Management Feature - Production Implementation Outline

## 1. Core Purpose

Manage all business partners connected to EV charging operations, including:
- Partner onboarding and registration
- Approval/rejection workflows
- Status management (pending, active, suspended, rejected)
- Contract lifecycle management
- Location mapping and management
- Comprehensive audit trail tracking
- Bulk operations for efficiency

---

## 2. Main Screens (ModelSheet where needed)

### 2.1 Partners List Screen
- **Type**: Main routed page (`/admin/partners`)
- **Location**: `lib/admin/features/partners/views/partners_list_page.dart`
- **Purpose**: Primary entry point showing all partners in a data table
- **Features**:
  - AdminDataTable with sortable columns
  - Horizontal scroll support for wide tables
  - Pagination controls
  - Search bar with debounced input
  - Filter panel (status, type, country)
  - Bulk selection and actions
  - Export CSV button
  - Create partner button

### 2.2 Partner Detail Sheet
- **Type**: ModelSheet (via `context.showAdminModal()`)
- **Location**: `lib/admin/features/partners/views/partner_detail_page.dart`
- **Purpose**: View comprehensive partner information
- **Features**:
  - Partner summary card (logo, name, status, rating)
  - Key metrics (total locations, active contracts, revenue)
  - Contracts list (expandable)
  - Locations list (expandable with map preview)
  - Audit log timeline
  - Action buttons (Edit, Approve, Reject, Suspend, Activate)
  - Quick actions for contracts and locations

### 2.3 Partner Create Sheet
- **Type**: ModelSheet (via `context.showAdminModal()`)
- **Location**: `lib/admin/features/partners/views/partner_create_page.dart`
- **Purpose**: Onboard new partners
- **Features**:
  - Multi-step form (Basic Info → Contact → Initial Location)
  - Logo upload (Pexels placeholder)
  - Form validation
  - Auto-generate audit log entry on creation

### 2.4 Partner Edit Sheet
- **Type**: ModelSheet (via `context.showAdminModal()`)
- **Location**: `lib/admin/features/partners/views/partner_edit_page.dart`
- **Purpose**: Modify existing partner details
- **Features**:
  - Pre-filled form with current data
  - Editable fields (name, email, phone, country, type, status)
  - Logo update option
  - Save changes with audit log entry

### 2.5 Add Contract Sheet
- **Type**: ModelSheet (via `context.showAdminModal()`)
- **Location**: `lib/admin/features/partners/views/widgets/add_contract_sheet.dart`
- **Purpose**: Add new contract to partner
- **Features**:
  - Contract form (title, start date, end date, amount, currency, notes)
  - Date pickers
  - Validation
  - Auto-link to partner

### 2.6 Manage Locations Sheet
- **Type**: ModelSheet (via `context.showAdminModal()`)
- **Location**: `lib/admin/features/partners/views/widgets/manage_locations_sheet.dart`
- **Purpose**: Add/edit/remove partner locations
- **Features**:
  - List of existing locations
  - Add new location form
  - Edit location inline
  - Remove location with confirmation
  - Map preview for each location

### 2.7 View Audit Logs Sheet
- **Type**: ModelSheet (via `context.showAdminModal()`)
- **Location**: `lib/admin/features/partners/views/widgets/audit_logs_sheet.dart`
- **Purpose**: View complete audit history
- **Features**:
  - Chronological timeline
  - Filter by action type
  - Search by admin user or memo
  - Export audit log

---

## 3. Data Models Needed

### 3.1 PartnerModel
**Location**: `lib/admin/features/partners/models/partner_model.dart`

```dart
class PartnerModel {
  final String id;
  final String name;
  final PartnerType type; // enum: owner, operator, reseller
  final String email;
  final String phone;
  final String country; // ISO code: IN, US, UK, DE
  final PartnerStatus status; // enum: pending, active, suspended, rejected
  final String? logoUrl; // Pexels URL
  final double rating; // 2.5 - 5.0
  final DateTime createdAt;
  final DateTime updatedAt;
  final String primaryContact; // Contact person name
  
  // JSON serialization with json_serializable
  // fromJson, toJson, copyWith
}
```

### 3.2 PartnerLocationModel
**Location**: `lib/admin/features/partners/models/partner_location_model.dart`

```dart
class PartnerLocationModel {
  final String id;
  final String partnerId;
  final String label; // e.g., "Headquarters", "Warehouse A"
  final String address;
  final String city;
  final String country;
  final double lat;
  final double lng;
  final DateTime createdAt;
  
  // JSON serialization with json_serializable
  // fromJson, toJson, copyWith
}
```

### 3.3 PartnerContractModel
**Location**: `lib/admin/features/partners/models/partner_contract_model.dart`

```dart
class PartnerContractModel {
  final String id;
  final String partnerId;
  final String title;
  final DateTime startDate;
  final DateTime? endDate; // null = ongoing
  final ContractStatus status; // enum: active, expired, terminated
  final double amount;
  final String currency; // USD, EUR, INR, GBP
  final String? notes;
  
  // JSON serialization with json_serializable
  // fromJson, toJson, copyWith
}
```

### 3.4 PartnerAuditModel
**Location**: `lib/admin/features/partners/models/partner_audit_model.dart`

```dart
class PartnerAuditModel {
  final String id;
  final String partnerId;
  final AuditActionType actionType; // enum: created, updated, approved, rejected, suspended, activated, contract_added, location_added, etc.
  final String adminUser; // Admin username/ID
  final DateTime timestamp;
  final String? memo; // Optional notes
  
  // JSON serialization with json_serializable
  // fromJson, toJson, copyWith
}
```

### 3.5 Enums
**Location**: `lib/admin/features/partners/models/partner_enums.dart`

```dart
enum PartnerType { owner, operator, reseller }
enum PartnerStatus { pending, active, suspended, rejected }
enum ContractStatus { active, expired, terminated }
enum AuditActionType {
  created, updated, approved, rejected, suspended, activated,
  contractAdded, contractUpdated, locationAdded, locationUpdated, locationRemoved
}
```

---

## 4. Functional Flows

### 4.1 Listing Flow
1. **Initial Load**: Fetch paginated partners (page 1, 25 per page)
2. **Table Display**: Show columns: Logo, Name, Type, Email, Country, Status, Rating, Created At, Actions
3. **Sorting**: Click column header to sort (name, createdAt, rating)
4. **Horizontal Scroll**: Table scrolls horizontally on mobile/tablet
5. **Pagination**: Page size selector (10, 25, 50, 100) + page navigation

### 4.2 Filtering Flow
1. **Filter Panel**: Collapsible panel with dropdowns
   - Status: All, Pending, Active, Suspended, Rejected
   - Type: All, Owner, Operator, Reseller
   - Country: All, IN, US, UK, DE
2. **Apply Filters**: Update table immediately
3. **Clear Filters**: Reset to default view
4. **Filter State**: Persist in BLoC state

### 4.3 Search Flow
1. **Search Input**: Debounced (300ms) text field
2. **Search Scope**: Name, email, ID
3. **Real-time Results**: Update table as user types
4. **Clear Search**: Reset to full list

### 4.4 Sorting Flow
1. **Column Click**: Toggle ascending/descending
2. **Visual Indicator**: Arrow icon in header
3. **Multi-column**: Single column sort only
4. **Default Sort**: Created At (descending)

### 4.5 Pagination Flow
1. **Page Size**: Dropdown selector
2. **Page Navigation**: Previous/Next buttons + page numbers
3. **Total Count**: "Showing X to Y of Z"
4. **State Management**: Update BLoC on page change

### 4.6 Detail Viewer Flow
1. **Open Detail**: Click row or "View Details" button → `context.showAdminModal()`
2. **Load Data**: Fetch partner + contracts + locations + audit logs
3. **Display Sections**: Summary, Metrics, Contracts, Locations, Audit
4. **Actions**: Edit, Approve, Reject, Suspend, Activate buttons
5. **Sub-actions**: Add Contract, Manage Locations buttons

### 4.7 Create Flow
1. **Open Create**: Click "Create Partner" → `context.showAdminModal()`
2. **Form Steps**: Basic Info → Contact → Initial Location
3. **Validation**: Real-time validation per field
4. **Logo Upload**: Pexels placeholder image selection
5. **Submit**: Create partner + initial audit log entry
6. **Success**: Close modal + refresh list

### 4.8 Edit Flow
1. **Open Edit**: Click "Edit" → `context.showAdminModal()`
2. **Load Data**: Pre-fill form with current partner data
3. **Modify Fields**: Update editable fields
4. **Save**: Update partner + audit log entry
5. **Success**: Close modal + refresh detail/list

### 4.9 Status Updates Flow
1. **Approve**: Change status to active + audit log
2. **Reject**: Show reason dialog → update status + audit log
3. **Suspend**: Confirmation dialog → update status + audit log
4. **Activate**: Update status + audit log
5. **All Actions**: Require confirmation dialog with "CONFIRM" text input

### 4.10 Contract Management Flow
1. **Add Contract**: Open Add Contract Sheet → Fill form → Save
2. **View Contracts**: Expandable list in detail page
3. **Edit Contract**: Inline edit or separate sheet
4. **Auto-link**: Contract automatically linked to partner

### 4.11 Location Management Flow
1. **Add Location**: Open Manage Locations Sheet → Add form → Save
2. **View Locations**: List with map preview in detail page
3. **Edit Location**: Inline edit in Manage Locations Sheet
4. **Remove Location**: Confirmation dialog → Delete + audit log

### 4.12 Audit Logging Flow
1. **Auto-logging**: Every action creates audit entry
2. **View Logs**: Open Audit Logs Sheet → Chronological timeline
3. **Filter Logs**: By action type or admin user
4. **Export Logs**: CSV export of audit history

### 4.13 Bulk Actions Flow
1. **Select Multiple**: Checkbox selection in table
2. **Bulk Approve**: Approve all selected partners
3. **Bulk Reject**: Show reason dialog → Reject all selected
4. **Bulk Export**: Export selected partners as CSV
5. **Clear Selection**: Deselect all

---

## 5. Admin Actions

### 5.1 Partner Actions
- **Approve Partner**: Change status to active
- **Reject Partner**: Change status to rejected (requires reason)
- **Suspend Partner**: Change status to suspended
- **Activate Partner**: Change status to active (from suspended)
- **Create Partner**: Add new partner
- **Edit Partner**: Modify partner details
- **Delete Partner**: (Optional - soft delete via status)

### 5.2 Contract Actions
- **Add Contract**: Create new contract for partner
- **Edit Contract**: Update contract details
- **View Contracts**: List all contracts for partner
- **Terminate Contract**: Mark contract as terminated

### 5.3 Location Actions
- **Add Location**: Add new location for partner
- **Edit Location**: Update location details
- **Remove Location**: Delete location (with confirmation)
- **View Locations**: List all locations for partner

### 5.4 Audit Actions
- **View Audit History**: Display all audit logs for partner
- **Filter Audit Logs**: By action type or admin user
- **Export Audit Logs**: CSV export

### 5.5 Bulk Actions
- **Bulk Approve**: Approve multiple partners
- **Bulk Reject**: Reject multiple partners (requires reason)
- **Bulk Export**: Export selected partners as CSV

---

## 6. Repository Operations

### 6.1 PartnersRepository Interface
**Location**: `lib/admin/features/partners/repository/partners_repository.dart`

```dart
abstract class PartnersRepository {
  // List operations
  Future<PaginatedPartnersResponse> fetchPartners(PartnersRequest request);
  Future<List<PartnerModel>> searchPartners(String query);
  
  // Single partner operations
  Future<PartnerModel?> getPartnerById(String id);
  Future<PartnerModel> createPartner(CreatePartnerPayload payload);
  Future<PartnerModel> updatePartner(String id, UpdatePartnerPayload payload);
  
  // Status operations
  Future<void> approvePartner(String id);
  Future<void> rejectPartner(String id, String reason);
  Future<void> suspendPartner(String id);
  Future<void> activatePartner(String id);
  
  // Contract operations
  Future<PartnerContractModel> addContract(String partnerId, CreateContractPayload contract);
  Future<PartnerContractModel> updateContract(String contractId, UpdateContractPayload contract);
  Future<List<PartnerContractModel>> getContracts(String partnerId);
  
  // Location operations
  Future<List<PartnerLocationModel>> getLocations(String partnerId);
  Future<PartnerLocationModel> addLocation(String partnerId, CreateLocationPayload location);
  Future<PartnerLocationModel> updateLocation(String locationId, UpdateLocationPayload location);
  Future<void> removeLocation(String locationId);
  
  // Audit operations
  Future<List<PartnerAuditModel>> getAuditLogs(String partnerId, {AuditFilters? filters});
  Future<void> addAuditLog(String partnerId, AuditActionType action, String adminUser, {String? memo});
  
  // Export operations
  Future<String> exportPartnersAsCsv(PartnersRequest request);
}
```

### 6.2 PartnersLocalMock Implementation
**Location**: `lib/admin/features/partners/repository/partners_local_mock.dart`

**Features**:
- Load from `assets/dummy_data/admin/partners.json`
- In-memory mutable datasets
- Simulate API delays (600ms default)
- Support pagination, filtering, sorting, searching
- CRUD operations with local state updates
- Auto-generate audit logs on actions
- Export CSV functionality

**Data Structure**:
```json
{
  "partners": [...],
  "contracts": [...],
  "locations": [...],
  "auditLogs": [...]
}
```

### 6.3 Request/Response Models
**Location**: `lib/admin/features/partners/repository/partners_requests.dart`

```dart
class PartnersRequest {
  final int page;
  final int perPage;
  final PartnersFilters? filters;
  final String? sortBy;
  final String order; // 'asc' or 'desc'
}

class PartnersFilters {
  final PartnerStatus? status;
  final PartnerType? type;
  final String? country;
  final String? search;
}

class PaginatedPartnersResponse {
  final List<PartnerModel> items;
  final int total;
  final int page;
  final int perPage;
}
```

---

## 7. UI/UX Requirements

### 7.1 Admin DataTable
- **Component**: `AdminDataTable<PartnerModel>`
- **Columns**: Logo, Name, Type, Email, Country, Status, Rating, Created At, Actions
- **Features**:
  - Sortable columns (name, createdAt, rating)
  - Responsive layout (horizontal scroll on mobile)
  - Row selection (checkbox)
  - Row tap to open detail
  - Loading state (shimmer)
  - Empty state (no partners message)
  - Error state (retry button)

### 7.2 Reusable List Tiles
- **PartnerLocationTile**: Display location with map icon
- **PartnerContractTile**: Display contract with status badge
- **PartnerAuditTile**: Display audit entry with icon and timestamp

### 7.3 ModelSheet Implementation
- **All CRUD**: Detail, Create, Edit, Add Contract, Manage Locations, Audit Logs
- **Adaptive**: Full-screen on mobile/tablet, centered modal on desktop
- **Max Width**: 800-1000 for forms, 1200+ for detail views
- **Material Context**: Proper Material widget wrapping for form fields
- **Padding**: 24.w on desktop, 16.w on mobile

### 7.4 ConfirmDialog
- **Destructive Actions**: Delete, Remove Location, Reject Partner
- **Requirement**: User must type "CONFIRM" to proceed
- **Component**: `AdminConfirmDialog`

### 7.5 Disabled States
- **While Loading**: Disable buttons during API calls
- **While Processing**: Show loading indicator
- **Error Handling**: Show error message + retry option

### 7.6 Empty States
- **No Partners**: "No partners found" with create button
- **No Contracts**: "No contracts yet" with add button
- **No Locations**: "No locations yet" with add button
- **No Audit Logs**: "No audit history"

### 7.7 Responsive Layout
- **Mobile**: Single column, stacked filters, full-screen modals
- **Tablet**: Two columns, side-by-side filters, full-screen modals
- **Desktop**: Multi-column table, inline filters, centered modals

### 7.8 Pexels Integration
- **Logo Placeholder**: Use Pexels URLs for partner logos
- **Image Loading**: `cached_network_image` for logos
- **Fallback**: Default placeholder icon if image fails

---

## 8. BLoC State Groups

### 8.1 PartnersBloc
**Location**: `lib/admin/features/partners/bloc/partners_bloc.dart`

**Events** (`lib/admin/features/partners/bloc/partners_event.dart`):
```dart
class LoadPartners extends PartnersEvent
class SearchPartners extends PartnersEvent { final String query; }
class FilterPartners extends PartnersEvent { final PartnersFilters filters; }
class SortPartners extends PartnersEvent { final String columnId; final bool ascending; }
class ChangePage extends PartnersEvent { final int page; }
class ChangePageSize extends PartnersEvent { final int pageSize; }
class BulkApprovePartners extends PartnersEvent { final List<String> partnerIds; }
class BulkRejectPartners extends PartnersEvent { final List<String> partnerIds; final String reason; }
class RefreshPartners extends PartnersEvent
```

**State** (`lib/admin/features/partners/bloc/partners_state.dart`):
```dart
class PartnersState extends Equatable {
  final bool isLoading;
  final bool isRefreshing;
  final List<PartnerModel> partners;
  final int total;
  final int page;
  final int perPage;
  final PartnersFilters? filters;
  final SortState? sortState;
  final Set<String> selectedPartnerIds;
  final String? error;
  final String? searchQuery;
  
  // copyWith method
  // Equatable props
}
```

### 8.2 PartnerDetailBloc
**Location**: `lib/admin/features/partners/bloc/partner_detail_bloc.dart`

**Events** (`lib/admin/features/partners/bloc/partner_detail_event.dart`):
```dart
class LoadPartnerDetail extends PartnerDetailEvent { final String partnerId; }
class ApprovePartner extends PartnerDetailEvent { final String partnerId; }
class RejectPartner extends PartnerDetailEvent { final String partnerId; final String reason; }
class SuspendPartner extends PartnerDetailEvent { final String partnerId; }
class ActivatePartner extends PartnerDetailEvent { final String partnerId; }
class AddContract extends PartnerDetailEvent { final String partnerId; final CreateContractPayload contract; }
class UpdateContract extends PartnerDetailEvent { final String contractId; final UpdateContractPayload contract; }
class AddLocation extends PartnerDetailEvent { final String partnerId; final CreateLocationPayload location; }
class UpdateLocation extends PartnerDetailEvent { final String locationId; final UpdateLocationPayload location; }
class RemoveLocation extends PartnerDetailEvent { final String locationId; }
class LoadAuditLogs extends PartnerDetailEvent { final String partnerId; final AuditFilters? filters; }
```

**State** (`lib/admin/features/partners/bloc/partner_detail_state.dart`):
```dart
class PartnerDetailState extends Equatable {
  final bool isLoading;
  final PartnerModel? partner;
  final List<PartnerContractModel> contracts;
  final List<PartnerLocationModel> locations;
  final List<PartnerAuditModel> auditLogs;
  final bool isApproving;
  final bool isRejecting;
  final bool isSuspending;
  final bool isActivating;
  final bool isAddingContract;
  final bool isUpdatingLocation;
  final String? error;
  final String? successMessage;
  
  // copyWith method
  // Equatable props
}
```

---

## 9. Dummy Data Requirements

### 9.1 JSON File Structure
**Location**: `assets/dummy_data/admin/partners.json`

**Content**:
- **50 Partners** with mixed:
  - Statuses: 15 pending, 25 active, 5 suspended, 5 rejected
  - Types: 20 owner, 20 operator, 10 reseller
  - Countries: 15 IN, 15 US, 10 UK, 10 DE
  - Ratings: 2.5 - 5.0 (distributed)
- **Each Partner Includes**:
  - 2-6 locations (random)
  - 1-3 contracts (random)
  - 5-10 audit logs (random)
- **Timestamps**: Spread across last 12 months
- **Pexels URLs**: Use Pexels API URLs for logos (business/company images)

### 9.2 Data Generation Strategy
- Use realistic company names (e.g., "Green Energy Solutions", "EV Power Co")
- Mix of email domains (gmail, company domains)
- Phone numbers match country codes
- Addresses match country (realistic city names)
- Contract amounts: $10K - $500K
- Contract currencies match country
- Audit logs show realistic admin actions over time

---

## 10. Routing Notes

### 10.1 Main Route
- **Route**: `/admin/partners`
- **Handler**: `AdminMainPage(initialRoute: AdminRoutes.partners)`
- **Component**: `PartnersListPage` wrapped in `PartnersFeatureProvider`
- **Location**: Already configured in `admin_routes.dart`

### 10.2 Sub-Views (ModelSheet Only)
- **NO separate routes** for detail, create, edit, contracts, locations, audit
- **All opened via**: `context.showAdminModal()`
- **Examples**:
  ```dart
  // Detail
  context.showAdminModal(
    title: AdminStrings.partnersDetailTitle,
    maxWidth: 1200,
    child: PartnerDetailPage(partnerId: partner.id),
  );
  
  // Create
  context.showAdminModal(
    title: AdminStrings.partnersCreateTitle,
    maxWidth: 1000,
    child: const PartnerCreatePage(),
  );
  
  // Edit
  context.showAdminModal(
    title: AdminStrings.partnersEditTitle,
    maxWidth: 1000,
    child: PartnerEditPage(partnerId: partner.id),
  );
  ```

---

## 11. File Structure

```
lib/admin/features/partners/
├── partners.dart                    # Barrel export
├── bloc/
│   ├── partners_bloc.dart
│   ├── partners_event.dart
│   ├── partners_state.dart
│   ├── partner_detail_bloc.dart
│   ├── partner_detail_event.dart
│   └── partner_detail_state.dart
├── models/
│   ├── partner_model.dart
│   ├── partner_location_model.dart
│   ├── partner_contract_model.dart
│   ├── partner_audit_model.dart
│   └── partner_enums.dart
├── repository/
│   ├── partners_repository.dart     # Interface
│   ├── partners_local_mock.dart     # Implementation
│   └── partners_requests.dart       # Request/Response models
├── views/
│   ├── partners_list_page.dart
│   ├── partner_detail_page.dart
│   ├── partner_create_page.dart
│   ├── partner_edit_page.dart
│   └── widgets/
│       ├── partners_table.dart
│       ├── partner_summary_card.dart
│       ├── partner_metrics_card.dart
│       ├── partner_contracts_list.dart
│       ├── partner_locations_list.dart
│       ├── partner_audit_timeline.dart
│       ├── add_contract_sheet.dart
│       ├── manage_locations_sheet.dart
│       └── audit_logs_sheet.dart
└── partners_bindings.dart           # BLoC providers
```

---

## 12. Constants & Strings

### 12.1 AdminStrings Additions
**Location**: `lib/admin/core/constants/admin_strings.dart`

```dart
// Partners
static const String partnersTitle = 'Partners';
static const String partnersDetailTitle = 'Partner Details';
static const String partnersCreateTitle = 'Create Partner';
static const String partnersEditTitle = 'Edit Partner';
static const String partnersAddContractTitle = 'Add Contract';
static const String partnersManageLocationsTitle = 'Manage Locations';
static const String partnersAuditLogsTitle = 'Audit History';

// Partner Fields
static const String partnerName = 'Partner Name';
static const String partnerType = 'Type';
static const String partnerEmail = 'Email';
static const String partnerPhone = 'Phone';
static const String partnerCountry = 'Country';
static const String partnerStatus = 'Status';
static const String partnerRating = 'Rating';
static const String partnerLogo = 'Logo';
static const String partnerPrimaryContact = 'Primary Contact';

// Contract Fields
static const String contractTitle = 'Contract Title';
static const String contractStartDate = 'Start Date';
static const String contractEndDate = 'End Date';
static const String contractAmount = 'Amount';
static const String contractCurrency = 'Currency';
static const String contractNotes = 'Notes';

// Location Fields
static const String locationLabel = 'Location Label';
static const String locationAddress = 'Address';
static const String locationCity = 'City';
static const String locationCountry = 'Country';
static const String locationCoordinates = 'Coordinates';

// Audit
static const String auditAction = 'Action';
static const String auditAdminUser = 'Admin User';
static const String auditTimestamp = 'Timestamp';
static const String auditMemo = 'Memo';

// Messages
static const String partnerApprovedSuccess = 'Partner approved successfully';
static const String partnerRejectedSuccess = 'Partner rejected successfully';
static const String partnerSuspendedSuccess = 'Partner suspended successfully';
static const String partnerActivatedSuccess = 'Partner activated successfully';
static const String partnerCreatedSuccess = 'Partner created successfully';
static const String partnerUpdatedSuccess = 'Partner updated successfully';
static const String contractAddedSuccess = 'Contract added successfully';
static const String locationAddedSuccess = 'Location added successfully';
static const String locationRemovedSuccess = 'Location removed successfully';
```

### 12.2 AdminAssets Additions
**Location**: `lib/admin/core/constants/admin_assets.dart`

```dart
static const String jsonPartners = 'assets/dummy_data/admin/partners.json';
```

---

## 13. Integration Points

### 13.1 AdminMainPage Integration
- Add Partners tab to sidebar navigation
- Use IndexedStack for tab switching (NOT navigation)
- PartnersListPage as one of the indexed children

### 13.2 Features Barrel Export
**Location**: `lib/admin/features/features.dart`

```dart
export 'partners/partners.dart';
```

### 13.3 AdminRoutes Enum
**Location**: Already configured in `admin_routes.dart`
- `partners` route exists
- Sub-routes (detail, create, edit) exist but NOT used (ModelSheet only)

---

## 14. Implementation Checklist

### Phase 1: Foundation
- [ ] Create feature folder structure
- [ ] Define models (PartnerModel, PartnerLocationModel, PartnerContractModel, PartnerAuditModel)
- [ ] Define enums (PartnerType, PartnerStatus, ContractStatus, AuditActionType)
- [ ] Create JSON dummy data file (50 partners with locations, contracts, audit logs)
- [ ] Implement PartnersRepository interface
- [ ] Implement PartnersLocalMock with CRUD operations

### Phase 2: BLoC Implementation
- [ ] Create PartnersBloc (events, state)
- [ ] Create PartnerDetailBloc (events, state)
- [ ] Implement pagination, filtering, sorting, searching
- [ ] Implement status update operations
- [ ] Implement contract operations
- [ ] Implement location operations
- [ ] Implement audit logging

### Phase 3: UI Components
- [ ] Create PartnersListPage with AdminDataTable
- [ ] Create PartnerDetailPage (ModelSheet)
- [ ] Create PartnerCreatePage (ModelSheet)
- [ ] Create PartnerEditPage (ModelSheet)
- [ ] Create reusable widgets (summary card, metrics card, contracts list, locations list, audit timeline)
- [ ] Create AddContractSheet (ModelSheet)
- [ ] Create ManageLocationsSheet (ModelSheet)
- [ ] Create AuditLogsSheet (ModelSheet)

### Phase 4: Integration
- [ ] Add Partners tab to AdminMainPage sidebar
- [ ] Update features.dart barrel export
- [ ] Add AdminStrings constants
- [ ] Add AdminAssets constants
- [ ] Create PartnersFeatureProvider
- [ ] Test all flows (list, detail, create, edit, contracts, locations, audit)

### Phase 5: Polish
- [ ] Add loading states
- [ ] Add error handling
- [ ] Add empty states
- [ ] Add confirmation dialogs
- [ ] Add success messages
- [ ] Test responsive layout (mobile, tablet, desktop)
- [ ] Verify ModelSheet behavior
- [ ] Verify audit logging on all actions

---

## 15. Technical Notes

### 15.1 No Unit Tests
- As per requirements, skip unit tests
- Focus on functional implementation only

### 15.2 No Freezed
- Use manual `copyWith` methods
- Use `Equatable` for state comparison
- Follow existing project patterns

### 15.3 json_serializable
- All models use `@JsonSerializable()`
- Generate code with `flutter pub run build_runner build --delete-conflicting-outputs`

### 15.4 ScreenUtil Sizing
- All UI sizing via ScreenUtil (.sp, .h, .w, .r)
- No hardcoded pixel values
- Responsive breakpoints via AdminResponsive

### 15.5 Material 3 Design
- Use Material 3 components
- Follow admin theme (AdminColors, AdminTextStyles)
- Consistent spacing and typography

---

## End of Feature Outline

This outline provides a complete blueprint for implementing the Partners Management feature following all project rules and patterns.
