# 🛠️ Installation & Setup Guide

## ✅ Prerequisites

Before you begin, ensure you have:

1. **Flutter SDK** (3.0.0 or higher)
2. **Dart SDK** (3.0.0 or higher)  
3. **iOS** (Xcode 12+) or **Android Studio** (2021.1+)
4. **Git** (optional, for version control)

### Verify Installation

```bash
flutter --version
dart --version
```

---

## 📥 Installation Steps

### Step 1: Navigate to Project

```bash
cd /Users/macbook/Desktop/uniways/akash_app
```

### Step 2: Get Flutter Packages

```bash
flutter pub get
```

This command will:
- ✅ Download all dependencies
- ✅ Create `.packages` file
- ✅ Generate platform-specific build files

### Step 3: Run the App

#### On iOS (Simulator)
```bash
flutter run
# Or specific device
flutter run -d "iPhone 15"
```

#### On Android (Emulator)
```bash
flutter run
# Or specific device
flutter run -d emulator-5554
```

#### Clean Build (if issues)
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🏗️ Project Setup

### Folder Structure
```
akash_app/
├── lib/
│   ├── config/              # Configuration (colors, strings, theme)
│   ├── models/              # Data models
│   ├── services/            # Business logic
│   ├── screens/             # UI screens
│   └── main.dart            # Entry point
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
├── web/                     # Web-specific files
├── pubspec.yaml            # Dependencies
└── README.md               # Documentation
```

---

## 📦 Dependencies Installed

All dependencies are automatically installed via `flutter pub get`:

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `sqflite` | SQLite database |
| `path_provider` | File system access |
| `intl` | Date/time formatting |
| `google_fonts` | Typography |
| And more... | See pubspec.yaml |

---

## ⚙️ Configuration

### No Additional Configuration Required!

The app is pre-configured with:
- ✅ SQLite database setup (auto-creates on first run)
- ✅ Provider state management
- ✅ Custom theme and colors
- ✅ String localization

### Optional Customization

#### Change App Title
Edit `lib/config/app_strings.dart`:
```dart
static const String appTitle = 'Your App Name';
```

#### Change Primary Color
Edit `lib/config/app_colors.dart`:
```dart
static const Color primary = Color(0xFFYOURCOLOR);
```

#### Change Theme
Edit `lib/main.dart`:
```dart
theme: AppTheme.lightTheme,
darkTheme: AppTheme.darkTheme,
themeMode: ThemeMode.system,
```

---

## 🚀 Running the App

### First Time Run
```bash
flutter pub get
flutter run
```

### Subsequent Runs
```bash
flutter run
```

### Run with Specific Configuration
```bash
# Release mode
flutter run --release

# Debug mode with hot reload
flutter run --debug

# Profile mode
flutter run --profile
```

---

## 🐛 Troubleshooting

### Issue: "Flutter not found"
**Solution:**
```bash
# Add Flutter to PATH
export PATH="$PATH:`flutter/bin`"
flutter doctor
```

### Issue: "Dependency resolution failed"
**Solution:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

### Issue: "Database error"
**Solution:**
```bash
# Clear app data
flutter clean

# Rebuild
flutter pub get
flutter run
```

### Issue: "Android SDK not found"
**Solution:**
```bash
flutter doctor
# Follow suggestions to install Android SDK
```

### Issue: "Xcode not installed" (iOS)
**Solution:**
```bash
xcode-select --install
# Or download from App Store
```

---

## 📱 Running on Different Devices

### List Available Devices
```bash
flutter devices
```

### Run on Specific Device
```bash
flutter run -d <device_id>
```

### iOS Options
```bash
# Simulator
flutter run -d "iPhone 15"

# Physical device
flutter run -d ios
```

### Android Options
```bash
# Emulator
flutter run -d emulator-5554

# Physical device
flutter run -d android
```

---

## 🔧 Development Workflow

### Hot Reload (Fast Development)
During `flutter run`, press:
- `r` - Hot reload (quick)
- `R` - Hot restart (full reload)
- `q` - Quit

### Build APK (Android)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build IPA (iOS)
```bash
flutter build ios --release
# Output in Xcode to create TestFlight/App Store build
```

### Build for Web
```bash
flutter build web --release
# Output: build/web/
```

---

## 📊 Development Tools

### View Logs
```bash
flutter logs
```

### Open DevTools
```bash
flutter pub global activate devtools
devtools
# Connects to running app at http://localhost:9100
```

### Analyze Code
```bash
flutter analyze
```

### Format Code
```bash
flutter format .
```

---

## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test
```bash
flutter test test/widget_test.dart
```

### Generate Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 🔐 Security Checklist

- ✅ Never commit `pubspec.lock` changes accidentally
- ✅ Use `.gitignore` for sensitive files
- ✅ Validate all user input (already done)
- ✅ Use HTTPS for any API calls
- ✅ Keep dependencies updated
- ✅ Review security advisories regularly

---

## 📚 Useful Resources

### Official Documentation
- [Flutter Official Docs](https://flutter.dev)
- [Dart Language Guide](https://dart.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [SQLite Package](https://pub.dev/packages/sqflite)

### Community Resources
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/Flutter](https://reddit.com/r/Flutter)

---

## ✨ What's Next?

After installation:

1. **Test the App**
   - Add a client
   - Create a project
   - Search and filter
   - Edit and delete

2. **Customize** (Optional)
   - Update app title
   - Change colors
   - Modify strings

3. **Extend Features**
   - Add new screens
   - Implement new functionality
   - Integrate with backend

4. **Deploy**
   - Build APK for Android
   - Build IPA for iOS
   - Test on devices
   - Publish to stores

---

## 💡 Tips & Tricks

- Use `flutter run -v` for verbose logging
- Enable `dart:developer` debugging in VSCode
- Use `flutter pub outdated` to check for updates
- Use `flutter pub upgrade` to update dependencies
- Keep your Flutter SDK updated: `flutter upgrade`

---

## 🆘 Getting Help

1. Check error messages carefully
2. Read official Flutter documentation
3. Search Stack Overflow
4. Check GitHub issues
5. Ask in Flutter community channels

---

## 📝 Notes

- First app launch creates SQLite database automatically
- No internet connection required for app functionality
- Data persists between app restarts
- Can delete all data by clearing app cache/data

---

**Ready to start?** 🎉

```bash
cd /Users/macbook/Desktop/uniways/akash_app
flutter pub get
flutter run
```

---

**Version**: 1.0.0  
**Last Updated**: October 2025  
**Status**: Ready for Development ✅
