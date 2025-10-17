import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../models/analytics_model.dart';
import '../services/analytics_service.dart';
import '../services/database_service.dart';
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

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with TickerProviderStateMixin {
  AnalyticsData _analyticsData = AnalyticsData.empty();
  bool _isLoading = true;
  late AnalyticsService _analyticsService;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _analyticsService = AnalyticsService(context.read<DatabaseService>());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadAnalytics();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      _animationController.forward();
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
        color: AppColors.lightPrimary,
        onTap: () => _showClientDetails(),
      ),
      AnalyticsCardData(
        title: 'Total Projects',
        value: _analyticsData.totalProjects.toString(),
        subtitle: 'All projects',
        icon: Icons.work,
        color: AppColors.lightSecondary,
        onTap: () => _showProjectDetails(),
      ),
      AnalyticsCardData(
        title: 'Completed',
        value: _analyticsData.completedProjects.toString(),
        subtitle: '${_analyticsData.completionPercentage.toStringAsFixed(1)}% completion',
        icon: Icons.check_circle,
        color: AppColors.success,
        onTap: () => _showProjectDetails('Completed'),
      ),
      AnalyticsCardData(
        title: 'Pending',
        value: _analyticsData.pendingProjects.toString(),
        subtitle: '${_analyticsData.pendingPercentage.toStringAsFixed(1)}% pending',
        icon: Icons.hourglass_empty,
        color: AppColors.warning,
        onTap: () => _showProjectDetails('Pending'),
      ),
      AnalyticsCardData(
        title: 'Ongoing',
        value: _analyticsData.ongoingProjects.toString(),
        subtitle: '${_analyticsData.ongoingPercentage.toStringAsFixed(1)}% ongoing',
        icon: Icons.play_circle_outline,
        color: AppColors.info,
        onTap: () => _showProjectDetails('Active'),
      ),
      AnalyticsCardData(
        title: 'Total Paid',
        value: '\$${_analyticsData.totalPaid.toStringAsFixed(0)}',
        subtitle: '${_analyticsData.paymentCompletionPercentage.toStringAsFixed(1)}% of total',
        icon: Icons.payments,
        color: AppColors.success,
        onTap: _showFinancialDetails,
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

  void _showProjectDetails([String? status]) {
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
        title: ResponsiveComponents.responsiveText(
          context,
          'Financial Details',
          style: ResponsiveTextStyle.responsive(
            context,
            mobileFontSize: 18.0,
            tabletFontSize: 20.0,
            smallDesktopFontSize: 22.0,
            largeDesktopFontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: AppColors.grey900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFinancialRow('Total Paid', '\$${_analyticsData.totalPaid.toStringAsFixed(2)}'),
            _buildFinancialRow('Outstanding', '\$${_analyticsData.totalBalance.toStringAsFixed(2)}'),
            _buildFinancialRow('Total Revenue', '\$${_analyticsData.totalRevenue.toStringAsFixed(2)}'),
            _buildFinancialRow('Payment Completion', '${_analyticsData.paymentCompletionPercentage.toStringAsFixed(1)}%'),
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
      backgroundColor: AppColors.background,
      appBar: ResponsiveComponents.responsiveAppBar(
        context: context,
        title: 'Analytics Dashboard',
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        actions: [
          IconButton(
            icon: ResponsiveComponents.responsiveIcon(context, Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAnalytics,
        child: _isLoading 
            ? Center(
                child: ResponsiveComponents.responsiveProgressIndicator(
                  context,
                  valueColor: AppColors.lightPrimary,
                ),
              )
            : FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced Header Section
                      _buildHeaderSection(context),
                      
                      SizedBox(height: ResponsiveUtils.responsiveSpacing(context) * 2),
                      
                      // Analytics Cards Section
                      _buildAnalyticsSection(context),
                      
                      SizedBox(height: ResponsiveUtils.responsiveSpacing(context) * 2),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return ResponsiveComponents.responsiveCard(
      context: context,
      color: AppColors.lightPrimary,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightPrimary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(ResponsiveUtils.responsiveBorderRadius(context)),
        ),
        child: Padding(
          padding: ResponsiveUtils.responsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ResponsiveComponents.responsiveIcon(
                    context,
                    Icons.analytics,
                    color: AppColors.white,
                  ),
                  SizedBox(width: ResponsiveUtils.responsiveSpacing(context) * 0.5),
                  Expanded(
                    child: ResponsiveComponents.responsiveText(
                      context,
                      'Business Overview',
                      style: ResponsiveTextStyle.responsive(
                        context,
                        mobileFontSize: 20.0,
                        tabletFontSize: 22.0,
                        smallDesktopFontSize: 24.0,
                        largeDesktopFontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.responsiveSpacing(context)),
              ResponsiveComponents.responsiveText(
                context,
                'Track your business performance and key metrics',
                style: ResponsiveTextStyle.responsive(
                  context,
                  mobileFontSize: 14.0,
                  tabletFontSize: 16.0,
                  smallDesktopFontSize: 18.0,
                  largeDesktopFontSize: 20.0,
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
              SizedBox(height: ResponsiveUtils.responsiveSpacing(context) * 1.5),
              // Quick stats in header
              ResponsiveUtils.isMobile(context)
                  ? Column(
                      children: [
                        _buildHeaderStat('Clients', _analyticsData.totalClients.toString(), Icons.people),
                        SizedBox(height: ResponsiveUtils.responsiveSpacing(context) * 0.5),
                        _buildHeaderStat('Projects', _analyticsData.totalProjects.toString(), Icons.work),
                        SizedBox(height: ResponsiveUtils.responsiveSpacing(context) * 0.5),
                        _buildHeaderStat('Revenue', '\$${_analyticsData.totalRevenue.toStringAsFixed(0)}', Icons.attach_money),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildHeaderStat('Clients', _analyticsData.totalClients.toString(), Icons.people)),
                        SizedBox(width: ResponsiveUtils.responsiveSpacing(context)),
                        Expanded(child: _buildHeaderStat('Projects', _analyticsData.totalProjects.toString(), Icons.work)),
                        SizedBox(width: ResponsiveUtils.responsiveSpacing(context)),
                        Expanded(child: _buildHeaderStat('Revenue', '\$${_analyticsData.totalRevenue.toStringAsFixed(0)}', Icons.attach_money)),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Padding(
      padding: EdgeInsets.all(isMobile ? ResponsiveUtils.responsiveSpacing(context) * 0.5 : ResponsiveUtils.responsiveSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveComponents.responsiveText(
            context,
            'Key Metrics',
            style: ResponsiveTextStyle.responsive(
              context,
              mobileFontSize: 16.0,
              tabletFontSize: 18.0,
              smallDesktopFontSize: 20.0,
              largeDesktopFontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: isMobile ? ResponsiveUtils.responsiveSpacing(context) * 0.5 : ResponsiveUtils.responsiveSpacing(context)),
          AnalyticsGrid(
            cards: _buildAnalyticsCards(),
            isLoading: _isLoading,
            crossAxisCount: ResponsiveUtils.responsiveGridCount(context),
            childAspectRatio: isMobile ? 1.0 : 1.1,
          ),
        ],
      ),
    );
  }


  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Row(
      children: [
        ResponsiveComponents.responsiveIcon(
          context,
          icon,
          color: AppColors.white,
          size: ResponsiveUtils.responsiveIconSize(context) * 0.8,
        ),
        SizedBox(width: ResponsiveUtils.responsiveSpacing(context) * 0.5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveComponents.responsiveText(
                context,
                label,
                style: ResponsiveTextStyle.responsive(
                  context,
                  mobileFontSize: 12.0,
                  tabletFontSize: 14.0,
                  smallDesktopFontSize: 16.0,
                  largeDesktopFontSize: 18.0,
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
              ResponsiveComponents.responsiveText(
                context,
                value,
                style: ResponsiveTextStyle.responsive(
                  context,
                  mobileFontSize: 16.0,
                  tabletFontSize: 18.0,
                  smallDesktopFontSize: 20.0,
                  largeDesktopFontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}