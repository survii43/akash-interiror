import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_strings.dart';
import 'config/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/client_provider.dart';
import 'services/database_service.dart';
import 'services/project_provider.dart';
import 'services/image_compression_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();

    return MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => databaseService),
        Provider<ImageCompressionService>(
          create: (_) => ImageCompressionService(databaseService),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientProvider(databaseService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectProvider(databaseService),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: const HomeScreen(),
      ),
    );
  }
}
