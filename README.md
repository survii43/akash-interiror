# Akash Manager - Flutter Application

A professional Flutter application for managing clients and projects with custom theming, local storage, and complete CRUD operations.

## 📋 Overview

**Akash Manager** is a comprehensive project management application built with Flutter. It allows users to:
- Manage clients (Create, Read, Update, Delete)
- Manage projects associated with clients
- Search and filter clients and projects
- Beautiful, modern UI with custom theming
- Local SQLite database for offline functionality
- Dark mode support

## 🎨 Features

### Custom Theme & Branding
- **Custom Color Palette**: Primary blue (#2563EB), secondary green (#10B981), accent amber (#F59E0B)
- **Typography**: Google Fonts (Inter) with carefully designed text hierarchy
- **Light & Dark Themes**: Complete theme support with Material 3 design
- **Responsive Design**: Optimized for all screen sizes

### Client Management
- ✅ Add new clients with name, email, phone, address, and company
- ✅ View all clients in an organized list
- ✅ Edit client information
- ✅ Delete clients
- ✅ Search clients by name, email, or phone

### Project Management
- ✅ Create projects linked to specific clients
- ✅ Manage project details (name, description, status, dates, budget)
- ✅ View all projects with client information
- ✅ Edit project details
- ✅ Delete projects
- ✅ Filter projects by status (Active, Pending, Completed, On Hold)
- ✅ Search projects

### Database & Storage
- 📱 Local SQLite database for persistent storage
- 🔄 Automatic database initialization on first run
- 🛡️ Foreign key constraints for data integrity
- 📊 Efficient query operations

### State Management
- 🎯 Provider pattern for state management
- 📢 ChangeNotifier for reactive updates
- 🔄 Automatic UI refresh on data changes

## 📁 Project Structure

```
lib/
├── config/
│   ├── app_colors.dart          # Color constants
│   ├── app_strings.dart         # String constants for localization
│   └── app_theme.dart           # Theme definitions (light & dark)
│
├── models/
│   ├── client_model.dart        # Client data model
│   └── project_model.dart       # Project data model
│
├── services/
│   ├── database_service.dart    # SQLite database operations
│   ├── client_provider.dart     # Client state management
│   └── project_provider.dart    # Project state management
│
├── screens/
│   ├── home_screen.dart         # Main navigation screen
│   ├── client_list_screen.dart  # Client list view
│   ├── client_form_screen.dart  # Client CRUD form
│   ├── project_list_screen.dart # Project list view
│   └── project_form_screen.dart # Project CRUD form
│
├── widgets/                     # Reusable widgets (for future use)
├── utils/                       # Utility functions (for future use)
└── main.dart                    # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK: 3.0.0 or higher
- Dart SDK: 3.0.0 or higher
- Android SDK / Xcode (for running on devices)

### Installation

1. **Navigate to the project directory:**
   ```bash
   cd akash_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `sqflite` | Local SQLite database |
| `path` | File path operations |
| `path_provider` | Platform-specific file paths |
| `intl` | Date/time formatting and localization |
| `go_router` | Navigation (reserved for future use) |
| `flutter_svg` | SVG image support |
| `google_fonts` | Beautiful Google Fonts integration |

## 🎯 Data Models

### Client Model
```dart
Client {
  int? id                    // Unique identifier
  String name                // Client full name
  String email              // Email address (unique)
  String phone              // Contact number
  String? address           // Physical address
  String? company           // Company name
  DateTime createdAt        // Creation timestamp
  DateTime? updatedAt       // Last update timestamp
}
```

### Project Model
```dart
Project {
  int? id                    // Unique identifier
  String name                // Project name
  String? description        // Project details
  int clientId               // Associated client
  String status              // Active, Pending, Completed, On Hold
  DateTime? startDate        // Project start date
  DateTime? endDate          // Project completion date
  double? budget             // Project budget
  DateTime createdAt         // Creation timestamp
  DateTime? updatedAt        // Last update timestamp
}
```

## 🎨 Color Scheme

### Primary Colors
- **Primary**: `#2563EB` (Blue)
- **Primary Light**: `#DBFEAE` (Light Blue)
- **Primary Dark**: `#1E40AF` (Dark Blue)

### Secondary Colors
- **Secondary**: `#10B981` (Emerald Green)
- **Accent**: `#F59E0B` (Amber)

### Status Colors
- **Success**: `#10B981` (Green)
- **Error**: `#EF4444` (Red)
- **Warning**: `#FCD34D` (Yellow)
- **Info**: `#3B82F6` (Blue)

### Neutral Colors
Complete grayscale from grey50 to grey900

## 🔤 String Management

All user-facing strings are centralized in `app_strings.dart` for easy localization:
- Navigation labels
- Common actions (Add, Edit, Delete, Save, Cancel)
- Client-related strings
- Project-related strings
- Validation messages
- Error messages
- Empty state messages

## 🗄️ Database Schema

### Clients Table
```sql
CREATE TABLE clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT NOT NULL,
  address TEXT,
  company TEXT,
  createdAt TEXT NOT NULL,
  updatedAt TEXT
)
```

### Projects Table
```sql
CREATE TABLE projects (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  clientId INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'Active',
  startDate TEXT,
  endDate TEXT,
  budget REAL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT,
  FOREIGN KEY (clientId) REFERENCES clients(id) ON DELETE CASCADE
)
```

## 🎮 Usage Examples

### Add a Client
1. Navigate to Clients tab
2. Tap the **+** button
3. Fill in client details
4. Tap Save

### Create a Project
1. Navigate to Projects tab
2. Tap the **+** button
3. Select a client from dropdown
4. Fill in project details
5. Select status and dates
6. Tap Save

### Search
1. Use the search bar on any list screen
2. Enter your search query (name, email, etc.)
3. Results update in real-time

## 🔄 State Management Flow

```
UI Layer (Screens)
    ↓
Providers (ClientProvider, ProjectProvider)
    ↓
Database Service
    ↓
SQLite Database
```

## 🚀 Future Enhancements

- [ ] Cloud synchronization
- [ ] Email notifications
- [ ] PDF report generation
- [ ] Advanced filtering options
- [ ] Data export/import
- [ ] User authentication
- [ ] Multi-user support
- [ ] Project tasks and milestones
- [ ] Time tracking
- [ ] Budget tracking and reports

## 📱 Platform Support

- ✅ iOS (iPhone, iPad)
- ✅ Android (Phone, Tablet)
- 🔜 Web (Future)
- 🔜 Windows (Future)
- 🔜 macOS (Future)

## 🛠️ Development

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

### Running Tests
```bash
flutter test
```

## 📝 Code Conventions

- Follow Dart naming conventions (camelCase for variables, PascalCase for classes)
- Use meaningful variable names
- Add comments for complex logic
- Keep methods focused and small
- Use const constructors where possible
- Organize imports alphabetically

## 🤝 Contributing

When adding new features:
1. Update the `AppStrings` for new text
2. Use `AppColors` for all colors
3. Follow the existing folder structure
4. Add appropriate validation
5. Test on both light and dark themes

## 📄 License

This project is proprietary and confidential.

## 👨‍💻 Author

Created as part of Uniways Project Management Suite.

## 📞 Support

For support or questions, please contact the development team.

---

**Version**: 1.0.0  
**Last Updated**: October 2025  
**Flutter SDK**: 3.0.0+
