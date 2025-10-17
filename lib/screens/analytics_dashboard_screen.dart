import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../models/analytics_model.dart';
import '../services/analytics_service.dart';
import '../services/database_service.dart';
import '../widgets/analytics_card.dart';
import '../utils/ui_utils.dart';
import '../utils/responsive_utils.dart';
import '../widgets/responsive_components.dart';
import 'client_list_screen.dart';
import 'project_list_screen.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  AnalyticsData _analyticsData = AnalyticsData.empty();
  bool _isLoading = true;
  late AnalyticsService _analyticsService;

  @override
  void initState() {
    super.initState();
    _analyticsService = AnalyticsService(context.read<DatabaseService>());
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _analyticsService.getAnalyticsData();
      setState(() {
        _analyticsData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        UIUtils.showErrorSnackBar(context, 'Failed to load analytics: $e');
      }
    }
  }

  List<AnalyticsCardData> _buildAnalyticsCards() {
    return [
      AnalyticsCardData(
        title: 'Total Clients',
        value: _analyticsData.totalClients.toString(),
        subtitle: 'Active clients',
        icon: Icons.people,
        color: AppColors.primary,
        onTap: () => _showClientDetails(),
      ),
      AnalyticsCardData(
        title: 'Completed Projects',
        value: _analyticsData.completedProjects.toString(),
        subtitle: '${_analyticsData.completionPercentage.toStringAsFixed(1)}% completion rate',
        icon: Icons.check_circle,
        color: AppColors.success,
        onTap: () => _showProjectDetails('completed'),
      ),
      AnalyticsCardData(
        title: 'Pending Projects',
        value: _analyticsData.pendingProjects.toString(),
        subtitle: '${_analyticsData.pendingPercentage.toStringAsFixed(1)}% of total',
        icon: Icons.schedule,
        color: AppColors.warning,
        onTap: () => _showProjectDetails('pending'),
      ),
      AnalyticsCardData(
        title: 'Ongoing Projects',
        value: _analyticsData.ongoingProjects.toString(),
        subtitle: '${_analyticsData.ongoingPercentage.toStringAsFixed(1)}% of total',
        icon: Icons.trending_up,
        color: AppColors.info,
        onTap: () => _showProjectDetails('active'),
      ),
      AnalyticsCardData(
        title: 'Total Paid',
        value: UIUtils.formatCurrency(_analyticsData.totalPaid),
        subtitle: '${_analyticsData.paymentCompletionPercentage.toStringAsFixed(1)}% payment rate',
        icon: Icons.payment,
        color: AppColors.success,
        onTap: () => _showFinancialDetails(),
      ),
      AnalyticsCardData(
        title: 'Outstanding Balance',
        value: UIUtils.formatCurrency(_analyticsData.totalBalance),
        subtitle: 'Pending payments',
        icon: Icons.account_balance_wallet,
        color: AppColors.accent,
        onTap: () => _showFinancialDetails(),
      ),
    ];
  }

  void _showClientDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClientListScreen(),
      ),
    );
  }

  void _showProjectDetails(String status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProjectListScreen(),
      ),
    );
  }

  void _showFinancialDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Financial Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFinancialRow('Total Revenue', UIUtils.formatCurrency(_analyticsData.totalRevenue)),
            _buildFinancialRow('Total Paid', UIUtils.formatCurrency(_analyticsData.totalPaid)),
            _buildFinancialRow('Outstanding Balance', UIUtils.formatCurrency(_analyticsData.totalBalance)),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _analyticsData.paymentCompletionPercentage / 100,
              backgroundColor: AppColors.grey200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
            const SizedBox(height: 8),
            Text(
              'Payment Completion: ${_analyticsData.paymentCompletionPercentage.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 12, color: AppColors.grey600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveComponents.responsiveAppBar(
        context: context,
        title: 'Analytics Dashboard',
        actions: [
          IconButton(
            icon: ResponsiveComponents.responsiveIcon(context, Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAnalytics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              AnalyticsSummary(
                data: _analyticsData,
                isLoading: _isLoading,
              ),
              
              // Analytics Cards Grid
              Padding(
                padding: ResponsiveUtils.responsivePadding(context),
                child: Text(
                  'Key Metrics',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.responsiveSpacing(context)),
              
              AnalyticsGrid(
                cards: _buildAnalyticsCards(),
                isLoading: _isLoading,
                crossAxisCount: ResponsiveUtils.responsiveGridCount(context),
                childAspectRatio: ResponsiveUtils.isMobile(context) ? 1.2 : 1.1,
              ),
              
              SizedBox(height: ResponsiveUtils.responsiveSpacing(context) * 2),
              
              // Quick Actions
              Padding(
                padding: ResponsiveUtils.responsivePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.responsiveSpacing(context)),
                    ResponsiveUtils.isMobile(context)
                        ? Column(
                            children: [
                              _buildQuickActionCard(
                                'View All Clients',
                                Icons.people,
                                AppColors.primary,
                                () => _showClientDetails(),
                              ),
                              SizedBox(height: ResponsiveUtils.responsiveSpacing(context)),
                              _buildQuickActionCard(
                                'View All Projects',
                                Icons.work,
                                AppColors.secondary,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProjectListScreen(),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: _buildQuickActionCard(
                                  'View All Clients',
                                  Icons.people,
                                  AppColors.primary,
                                  () => _showClientDetails(),
                                ),
                              ),
                              SizedBox(width: ResponsiveUtils.responsiveSpacing(context)),
                              Expanded(
                                child: _buildQuickActionCard(
                                  'View All Projects',
                                  Icons.work,
                                  AppColors.secondary,
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProjectListScreen(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              
              SizedBox(height: ResponsiveUtils.responsiveSpacing(context) * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
