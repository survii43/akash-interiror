# 🚀 Quick Start Guide - Akash Manager

## Installation & Setup (5 minutes)

### Step 1: Get Dependencies
```bash
cd /Users/macbook/Desktop/uniways/akash_app
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

Or for specific platforms:
```bash
# iOS
flutter run -d iphone

# Android
flutter run -d emulator-5554

# Web (future)
flutter run -d chrome
```

## 📱 First Time User Guide

### 1️⃣ **Add Your First Client**
   - Tap the **Clients** tab (bottom navigation)
   - Tap the **+** button (floating action button)
   - Fill in:
     - **Client Name**: Full name of the client
     - **Email**: Valid email address
     - **Phone**: Contact number
     - **Address**: (Optional) Physical address
     - **Company**: (Optional) Company name
   - Tap **Add** button

### 2️⃣ **Create Your First Project**
   - Tap the **Projects** tab (bottom navigation)
   - Tap the **+** button
   - Fill in:
     - **Project Name**: Name of the project
     - **Select Client**: Choose from your clients
     - **Status**: Active, Pending, Completed, or On Hold
     - **Description**: (Optional) Project details
     - **Start Date**: Tap to select date
     - **End Date**: Tap to select date
     - **Budget**: (Optional) Project budget amount
   - Tap **Add** button

### 3️⃣ **Search & Filter**
   - Use the search bar on any list screen
   - Type to search by name, email, description, etc.
   - Results update in real-time
   - Clear button appears when text is entered

### 4️⃣ **Edit Items**
   - Tap an item in the list, OR
   - Tap the menu (⋮) on a client card
   - Tap **Edit**
   - Modify details
   - Tap **Edit** button to save

### 5️⃣ **Delete Items**
   - Tap an item or menu (⋮)
   - Tap **Delete**
   - Confirm deletion in dialog

## 🎨 Theme & UI

The app automatically detects your device's theme preference:
- **Light Theme**: Blue primary, clean white backgrounds
- **Dark Theme**: Dark backgrounds, adjusted colors for OLED displays

Toggle your device's theme in settings to see both themes!

## 📊 Project Structure Overview

```
akash_app/
├── lib/
│   ├── config/           # Colors, Strings, Theme
│   ├── models/           # Data structures
│   ├── services/         # Database & State management
│   ├── screens/          # UI screens
│   └── main.dart        # App entry point
│
├── pubspec.yaml         # Dependencies
├── README.md            # Full documentation
└── QUICKSTART.md        # This file
```

## 🔍 Features at a Glance

| Feature | Location | How to Use |
|---------|----------|-----------|
| Manage Clients | Bottom tab - Clients | Add/Edit/Delete clients |
| Manage Projects | Bottom tab - Projects | Add/Edit/Delete projects |
| Search | Search bar on each screen | Type keywords to filter |
| Add New | + Button (FAB) | Tap to create new item |
| Edit | Tap item or menu | Modify and save changes |
| Delete | Tap menu (⋮) | Confirm deletion |
| Theme | Device settings | Automatic light/dark switch |

## 💾 Data Storage

- **Location**: Device local storage (SQLite database)
- **Persistence**: All data saved automatically
- **Offline**: Full functionality without internet
- **No Cloud Sync**: Currently local only (feature for future)

## 🛠️ Troubleshooting

### App Won't Run
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Dependencies Issue
```bash
# Update dependencies
flutter pub upgrade
flutter run
```

### Database Error
- Data is stored locally in SQLite
- First run creates database automatically
- If corrupted, data can be cleared from app settings

## 🎯 Tips & Tricks

✅ **Email Validation**: Email must be valid format (user@domain.com)
✅ **Phone Validation**: Phone number must contain only numbers, spaces, hyphens, +, (), or commas
✅ **Unique Emails**: Each client must have a unique email address
✅ **Cascading Delete**: Deleting a client also deletes associated projects
✅ **Status Colors**: 
   - 🟢 Green = Active/Completed
   - 🟡 Yellow = On Hold
   - 🔵 Blue = Pending

## 🔄 Navigation Guide

```
┌─────────────────────────┐
│   Home Screen           │
│  (Bottom Navigation)    │
├──────────┬──────────────┤
│ Clients  │  Projects    │
├──────────┼──────────────┤
│  List    │    List      │
│  Add     │    Add       │
│  Edit    │    Edit      │
│  Delete  │    Delete    │
│  Search  │    Search    │
└──────────┴──────────────┘
```

## 📝 Common Tasks

### Task: Add 5 test clients
1. Tap Clients tab
2. Tap + button
3. Enter test data
4. Tap Add
5. Repeat 5 times

### Task: Link projects to clients
1. Tap Projects tab
2. Tap + button
3. Select client from dropdown
4. Add project details
5. Tap Add

### Task: Find a specific client
1. Go to Clients tab
2. Use search bar
3. Type partial name/email
4. Results filter in real-time

## ⚙️ App Settings & Preferences

Currently, the app uses device-level settings:
- **Theme**: Light/Dark (from device settings)
- **Language**: System language (from device settings)
- **Date Format**: MM/DD/YYYY (configurable in intl package)

## 🎓 Learning Resources

- **Flutter Documentation**: https://flutter.dev
- **Provider Package**: https://pub.dev/packages/provider
- **SQLite in Flutter**: https://pub.dev/packages/sqflite

## 🐛 Report Issues

If you encounter any bugs:
1. Note what you were doing
2. Check the console for errors (bottom of VS Code/Android Studio)
3. Try clearing data and running again
4. Report with steps to reproduce

## 🎉 You're All Set!

Enjoy using **Akash Manager**! Your app is now ready to manage clients and projects efficiently.

For detailed documentation, see `README.md`

---

**Need Help?** Check README.md for comprehensive documentation.  
**Found a Bug?** Report it with steps to reproduce.  
**Have Ideas?** Check "Future Enhancements" section in README.md
