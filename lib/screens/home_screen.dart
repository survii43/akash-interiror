import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_strings.dart';
import '../services/client_provider.dart';
import '../services/project_provider.dart';
import '../services/image_compression_service.dart';
import '../widgets/responsive_components.dart';
import 'client_list_screen.dart';
import 'project_list_screen.dart';
import 'image_management_screen.dart';
import 'analytics_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AnalyticsDashboardScreen(),
    const ClientListScreen(),
    const ProjectListScreen(),
    const ImageManagementScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data
    Future.microtask(() {
      context.read<ClientProvider>().loadClients();
      context.read<ProjectProvider>().loadProjects();
      // Start background image compression
      context.read<ImageCompressionService>().startBackgroundCompression();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: ResponsiveComponents.responsiveBottomNavigationBar(
        context: context,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ResponsiveComponents.responsiveIcon(context, Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: ResponsiveComponents.responsiveIcon(context, Icons.people),
            label: AppStrings.clients,
          ),
          BottomNavigationBarItem(
            icon: ResponsiveComponents.responsiveIcon(context, Icons.work),
            label: AppStrings.projects,
          ),
          BottomNavigationBarItem(
            icon: ResponsiveComponents.responsiveIcon(context, Icons.image),
            label: 'Images',
          ),
        ],
      ),
    );
  }
}
