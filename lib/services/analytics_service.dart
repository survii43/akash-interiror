import '../models/analytics_model.dart';
import '../models/client_model.dart';
import '../models/project_model.dart';
import 'database_service.dart';

/// Service for calculating analytics data
class AnalyticsService {
  final DatabaseService _databaseService;

  AnalyticsService(this._databaseService);

  /// Calculate comprehensive analytics data
  Future<AnalyticsData> getAnalyticsData() async {
    try {
      // Get all clients and projects
      final clients = await _databaseService.getAllClients();
      final projects = await _databaseService.getAllProjects();

      // Calculate basic counts
      final totalClients = clients.length;
      final totalProjects = projects.length;

      // Calculate project status counts
      int completedProjects = 0;
      int pendingProjects = 0;
      int ongoingProjects = 0;
      double totalPaid = 0.0;
      double totalBalance = 0.0;

      for (final project in projects) {
        switch (project.status.toLowerCase()) {
          case 'completed':
            completedProjects++;
            break;
          case 'pending':
            pendingProjects++;
            break;
          case 'active':
            ongoingProjects++;
            break;
        }

        // Calculate financial data
        if (project.budget != null) {
          // For demo purposes, assume 70% paid for completed projects
          // and 30% paid for ongoing projects
          if (project.status.toLowerCase() == 'completed') {
            totalPaid += project.budget! * 0.7;
            totalBalance += project.budget! * 0.3;
          } else if (project.status.toLowerCase() == 'active') {
            totalPaid += project.budget! * 0.3;
            totalBalance += project.budget! * 0.7;
          } else {
            // Pending projects - no payment yet
            totalBalance += project.budget!;
          }
        }
      }

      return AnalyticsData(
        totalClients: totalClients,
        totalProjects: totalProjects,
        completedProjects: completedProjects,
        pendingProjects: pendingProjects,
        ongoingProjects: ongoingProjects,
        totalPaid: totalPaid,
        totalBalance: totalBalance,
      );
    } catch (e) {
      // Return empty data on error
      return AnalyticsData.empty();
    }
  }

  /// Get clients by status (for detailed views)
  Future<List<Client>> getClientsByStatus(String status) async {
    try {
      final clients = await _databaseService.getAllClients();
      // For demo purposes, filter by company status
      return clients.where((client) => 
        client.company?.toLowerCase().contains(status.toLowerCase()) ?? false
      ).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get projects by status (for detailed views)
  Future<List<Project>> getProjectsByStatus(String status) async {
    try {
      final projects = await _databaseService.getAllProjects();
      return projects.where((project) => 
        project.status.toLowerCase() == status.toLowerCase()
      ).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get financial summary
  Future<Map<String, double>> getFinancialSummary() async {
    try {
      final analytics = await getAnalyticsData();
      return {
        'totalPaid': analytics.totalPaid,
        'totalBalance': analytics.totalBalance,
        'totalRevenue': analytics.totalRevenue,
        'paymentCompletion': analytics.paymentCompletionPercentage,
      };
    } catch (e) {
      return {
        'totalPaid': 0.0,
        'totalBalance': 0.0,
        'totalRevenue': 0.0,
        'paymentCompletion': 0.0,
      };
    }
  }
}
