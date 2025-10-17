# 🏗️ Architecture & Design Patterns

## Application Architecture

The **Akash Manager** follows a **layered architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│         UI Layer (Screens)              │
│  (StatefulWidget / StatelessWidget)     │
├─────────────────────────────────────────┤
│     State Management (Providers)        │
│  (ChangeNotifier + Provider Pattern)    │
├─────────────────────────────────────────┤
│    Business Logic (Services)            │
│ (ClientProvider, ProjectProvider)       │
├─────────────────────────────────────────┤
│    Data Layer (Database Service)        │
│        (SQLite Operations)              │
├─────────────────────────────────────────┤
│     Database (SQLite)                   │
│  (Local Storage, Persistence)           │
└─────────────────────────────────────────┘
```

## Key Design Patterns

### 1. **Provider Pattern (State Management)**

```dart
// ClientProvider extends ChangeNotifier
class ClientProvider extends ChangeNotifier {
  List<Client> _clients = [];
  
  Future<void> loadClients() async {
    _clients = await _databaseService.getAllClients();
    notifyListeners(); // Notify UI of changes
  }
}

// Usage in UI
Consumer<ClientProvider>(
  builder: (context, clientProvider, child) {
    return ListView(
      children: clientProvider.clients.map(...).toList(),
    );
  },
)
```

**Benefits:**
- ✅ Reactive state management
- ✅ Automatic UI rebuild on state change
- ✅ Separation of UI and business logic
- ✅ Easy testing and debugging

### 2. **Repository Pattern (Data Access)**

```dart
// DatabaseService acts as repository
class DatabaseService {
  // Abstracts database operations
  Future<List<Client>> getAllClients() async { ... }
  Future<int> insertClient(Client client) async { ... }
  Future<int> updateClient(Client client) async { ... }
  Future<int> deleteClient(int id) async { ... }
}
```

**Benefits:**
- ✅ Centralized data access
- ✅ Easy to mock for testing
- ✅ Database implementation details hidden
- ✅ Consistent error handling

### 3. **Singleton Pattern (Database)**

```dart
class DatabaseService {
  static Database? _database; // Singleton instance
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
}
```

**Benefits:**
- ✅ Single database connection
- ✅ Resource efficiency
- ✅ Consistent state
- ✅ Prevents multiple database handles

### 4. **Factory Pattern (Model Creation)**

```dart
class Client {
  // Convert from database map to model
  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as int?,
      name: map['name'] as String,
      // ... other fields
    );
  }
  
  // Convert model to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // ... other fields
    };
  }
}
```

**Benefits:**
- ✅ Flexible object creation
- ✅ Type-safe conversion
- ✅ Reusable logic
- ✅ Clean API

## Folder Structure & Responsibilities

### 📁 `config/` - Configuration
**Purpose**: Centralized configuration constants

```dart
app_colors.dart      // Color palette definitions
app_strings.dart     // Localized strings (i18n ready)
app_theme.dart       // Light/Dark theme definitions
```

**Why separated?**
- Easy to maintain branding
- Support for theming
- Quick localization
- Reusability across screens

### 📁 `models/` - Data Models
**Purpose**: Define data structures and transformations

```dart
client_model.dart    // Client entity definition
project_model.dart   // Project entity definition
```

**Responsibilities:**
- ✅ Define data structure
- ✅ Provide serialization (toMap/fromMap)
- ✅ Implement copyWith for immutability
- ✅ Provide toString for debugging

### 📁 `services/` - Business Logic
**Purpose**: Handle data operations and state

**Three types of services:**

1. **DatabaseService** (Data Access)
   - SQL operations
   - Query optimization
   - Error handling
   - CRUD operations

2. **ClientProvider** (State Management)
   - Client list state
   - Loading states
   - Error handling
   - Reactive updates

3. **ProjectProvider** (State Management)
   - Project list state
   - Loading states
   - Error handling
   - Reactive updates

### 📁 `screens/` - UI Layer
**Purpose**: User interface and user interaction

```dart
home_screen.dart         // Navigation hub
client_list_screen.dart  // Client list view
client_form_screen.dart  // Client CRUD form
project_list_screen.dart // Project list view
project_form_screen.dart // Project CRUD form
```

**Responsibilities:**
- ✅ Display UI
- ✅ Handle user input
- ✅ Call provider methods
- ✅ Navigate between screens

## Data Flow Diagram

### Create Client Flow
```
User Input (Form)
    ↓
ClientFormScreen (validates)
    ↓
ClientProvider.addClient()
    ↓
DatabaseService.insertClient()
    ↓
SQLite Database
    ↓
ClientProvider.loadClients() [reload]
    ↓
UI Updated (Consumer widget)
    ↓
Success Snackbar
```

### Read Operation Flow
```
HomeScreen.initState()
    ↓
ClientProvider.loadClients()
    ↓
DatabaseService.getAllClients()
    ↓
SQLite Query
    ↓
Client.fromMap() [conversion]
    ↓
Return List<Client>
    ↓
notifyListeners()
    ↓
UI Rebuilds (Consumer)
```

## State Management Flow

```
┌─────────────────┐
│  UI (Screens)   │
└────────┬────────┘
         │
    reads/writes
         │
┌────────▼──────────────────────────┐
│  Provider (ChangeNotifier)        │
│  - clients list                   │
│  - loading state                  │
│  - error messages                 │
└────────┬───────────────────────────┘
         │
      calls
         │
┌────────▼──────────────────────────┐
│  DatabaseService                 │
│  - CRUD operations               │
│  - Query execution               │
│  - Data transformation           │
└────────┬───────────────────────────┘
         │
    executes
         │
┌────────▼──────────────────────────┐
│  SQLite Database                 │
│  - Persistent storage            │
│  - Relational data               │
│  - Foreign keys                  │
└─────────────────────────────────┘
```

## Key Architectural Decisions

### 1. **Local SQLite Database**
- ✅ Offline support
- ✅ Fast local queries
- ✅ No network dependency
- ⚠️ Limited to single device

**Future:** Cloud synchronization layer can be added

### 2. **Provider for State Management**
- ✅ Simple and lightweight
- ✅ Good documentation
- ✅ Easy to understand
- ✅ Sufficient for current needs

**Alternative considered:** Bloc, Riverpod (over-engineered for this scope)

### 3. **Centralized String & Color Management**
- ✅ Easy theme changes
- ✅ i18n ready
- ✅ Consistency across app
- ✅ Single point of update

### 4. **Material 3 Design**
- ✅ Modern UI guidelines
- ✅ Built-in dark mode support
- ✅ Consistent with Flutter best practices
- ✅ Google Fonts integration

## Error Handling Strategy

### At Each Layer:

**UI Layer:**
```dart
try {
  await provider.addClient(client);
  showSuccessSnackbar();
} catch (e) {
  showErrorSnackbar(e.toString());
}
```

**Provider Layer:**
```dart
try {
  _clients = await _databaseService.getAllClients();
} catch (e) {
  _error = e.toString();
  notifyListeners();
}
```

**Database Layer:**
```dart
try {
  return await db.insert(_clientTable, client.toMap());
} catch (e) {
  // Log error
  rethrow; // Let provider handle
}
```

## Performance Considerations

### Database Optimization:
1. **Indexes** (Implicit)
   - Primary keys indexed by SQLite
   - Email unique constraint

2. **Query Optimization**
   - Eager loading of data
   - Ordered results (createdAt DESC)
   - Filtered queries with WHERE clauses

3. **Lazy Loading** (Future)
   - Pagination for large lists
   - Infinite scroll support

4. **Caching** (Current)
   - In-memory list caching
   - Reload on demand

### UI Optimization:
1. **Const Constructors**
   - Reduced rebuild overhead
   - Widget reusability

2. **Consumer Widgets**
   - Targeted rebuilds
   - Only affected widgets update

3. **ListView.builder**
   - Lazy rendering
   - Memory efficient for large lists

## Testing Strategy

### Unit Tests (Future):
```dart
test('Client model serialization', () {
  final client = Client(...);
  final map = client.toMap();
  final restored = Client.fromMap(map);
  expect(restored, client);
});
```

### Widget Tests (Future):
```dart
testWidgets('Client form validation', (tester) async {
  await tester.pumpWidget(MyApp());
  // Find form, enter invalid email
  // Verify error message
});
```

### Integration Tests (Future):
```dart
// Full app flow testing
// Database persistence testing
// Navigation testing
```

## Security Considerations

1. **Email Validation**
   - Regex pattern matching
   - Unique constraint in database

2. **Input Sanitization**
   - trim() on all inputs
   - Type checking (String, int, double)

3. **Data Privacy**
   - Local storage only
   - No external API calls
   - No analytics tracking

**Future**: Add password protection, biometric authentication

## Scalability & Future Growth

### Current Capacity:
- ✅ Thousands of clients
- ✅ Tens of thousands of projects
- ✅ Single device usage

### Future Enhancements:
1. **Backend Integration**
   - API layer
   - Server-side storage
   - Real-time sync

2. **Advanced Features**
   - User authentication
   - Role-based access
   - Team collaboration

3. **Analytics**
   - Usage tracking
   - Performance metrics
   - Error reporting

4. **Architecture Evolution**
   - Add Repository pattern
   - Implement Bloc/Riverpod
   - Add dependency injection

## Summary

The **Akash Manager** architecture is designed for:
- ✅ **Clarity**: Clear separation of concerns
- ✅ **Maintainability**: Easy to modify and extend
- ✅ **Testability**: Each layer can be tested independently
- ✅ **Performance**: Optimized for mobile devices
- ✅ **Scalability**: Foundation for future growth
- ✅ **User Experience**: Responsive and intuitive interface

---

**Questions about architecture?** Refer to the code comments and README.md for detailed explanations.
