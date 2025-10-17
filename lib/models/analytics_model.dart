import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../utils/responsive_utils.dart';
import '../widgets/responsive_components.dart';

/// Analytics data model for dashboard statistics
class AnalyticsData {
  final int totalClients;
  final int totalProjects;
  final int completedProjects;
  final int pendingProjects;
  final int ongoingProjects;
  final double totalPaid;
  final double totalBalance;

  const AnalyticsData({
    required this.totalClients,
    required this.totalProjects,
    required this.completedProjects,
    required this.pendingProjects,
    required this.ongoingProjects,
    required this.totalPaid,
    required this.totalBalance,
  });

  factory AnalyticsData.empty() {
    return const AnalyticsData(
      totalClients: 0,
      totalProjects: 0,
      completedProjects: 0,
      pendingProjects: 0,
      ongoingProjects: 0,
      totalPaid: 0.0,
      totalBalance: 0.0,
    );
  }

  /// Calculate completion percentage
  double get completionPercentage {
    if (totalProjects == 0) return 0.0;
    return (completedProjects / totalProjects) * 100;
  }

  /// Calculate pending percentage
  double get pendingPercentage {
    if (totalProjects == 0) return 0.0;
    return (pendingProjects / totalProjects) * 100;
  }

  /// Calculate ongoing percentage
  double get ongoingPercentage {
    if (totalProjects == 0) return 0.0;
    return (ongoingProjects / totalProjects) * 100;
  }

  /// Calculate total revenue
  double get totalRevenue => totalPaid + totalBalance;

  /// Calculate payment completion percentage
  double get paymentCompletionPercentage {
    if (totalRevenue == 0) return 0.0;
    return (totalPaid / totalRevenue) * 100;
  }

  AnalyticsData copyWith({
    int? totalClients,
    int? totalProjects,
    int? completedProjects,
    int? pendingProjects,
    int? ongoingProjects,
    double? totalPaid,
    double? totalBalance,
  }) {
    return AnalyticsData(
      totalClients: totalClients ?? this.totalClients,
      totalProjects: totalProjects ?? this.totalProjects,
      completedProjects: completedProjects ?? this.completedProjects,
      pendingProjects: pendingProjects ?? this.pendingProjects,
      ongoingProjects: ongoingProjects ?? this.ongoingProjects,
      totalPaid: totalPaid ?? this.totalPaid,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }
}

/// Individual analytics card data
class AnalyticsCardData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const AnalyticsCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

/// Enhanced analytics grid widget with responsive design
class AnalyticsGrid extends StatelessWidget {
  final List<AnalyticsCardData> cards;
  final bool isLoading;
  final int crossAxisCount;
  final double childAspectRatio;

  const AnalyticsGrid({
    super.key,
    required this.cards,
    this.isLoading = false,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.responsiveSpacing(context);
    final isMobile = ResponsiveUtils.isMobile(context);
    
    if (isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(isMobile ? spacing * 0.5 : spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: isMobile ? 1.0 : childAspectRatio,
          crossAxisSpacing: isMobile ? spacing * 0.5 : spacing,
          mainAxisSpacing: isMobile ? spacing * 0.5 : spacing,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) => _AnalyticsCard(
          data: cards[index],
          isLoading: true,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(isMobile ? spacing * 0.5 : spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: isMobile ? 1.0 : childAspectRatio,
        crossAxisSpacing: isMobile ? spacing * 0.5 : spacing,
        mainAxisSpacing: isMobile ? spacing * 0.5 : spacing,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => _AnalyticsCard(data: cards[index]),
    );
  }
}

/// Enhanced analytics card widget with responsive design
class _AnalyticsCard extends StatelessWidget {
  final AnalyticsCardData data;
  final bool isLoading;

  const _AnalyticsCard({
    required this.data,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    if (isLoading) {
      return ResponsiveComponents.responsiveCard(
        context: context,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResponsiveComponents.responsiveProgressIndicator(
              context,
              valueColor: AppColors.lightPrimary,
            ),
            SizedBox(height: isMobile ? ResponsiveUtils.responsiveSpacing(context) * 0.5 : ResponsiveUtils.responsiveSpacing(context)),
            ResponsiveComponents.responsiveText(
              context,
              'Loading...',
              style: ResponsiveTextStyle.responsive(
                context,
                mobileFontSize: 10.0,
                tabletFontSize: 12.0,
                smallDesktopFontSize: 14.0,
                largeDesktopFontSize: 16.0,
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      );
    }

    return ResponsiveComponents.responsiveCard(
      context: context,
      onTap: data.onTap,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ResponsiveComponents.responsiveIcon(
                  context,
                  data.icon,
                  color: data.color,
                  size: isMobile ? ResponsiveUtils.responsiveIconSize(context) * 0.7 : ResponsiveUtils.responsiveIconSize(context),
                ),
                const Spacer(),
                if (data.onTap != null)
                  ResponsiveComponents.responsiveIcon(
                    context,
                    Icons.arrow_forward_ios,
                    color: data.color,
                    size: isMobile ? ResponsiveUtils.responsiveIconSize(context) * 0.3 : ResponsiveUtils.responsiveIconSize(context) * 0.5,
                  ),
              ],
            ),
            SizedBox(height: isMobile ? ResponsiveUtils.responsiveSpacing(context) * 0.5 : ResponsiveUtils.responsiveSpacing(context)),
            ResponsiveComponents.responsiveText(
              context,
              data.title,
              style: ResponsiveTextStyle.responsive(
                context,
                mobileFontSize: 10.0,
                tabletFontSize: 12.0,
                smallDesktopFontSize: 14.0,
                largeDesktopFontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isMobile ? ResponsiveUtils.responsiveSpacing(context) * 0.25 : ResponsiveUtils.responsiveSpacing(context) * 0.5),
            ResponsiveComponents.responsiveText(
              context,
              data.value,
              style: ResponsiveTextStyle.responsive(
                context,
                mobileFontSize: 14.0,
                tabletFontSize: 16.0,
                smallDesktopFontSize: 18.0,
                largeDesktopFontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: data.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (data.subtitle.isNotEmpty) ...[
              SizedBox(height: isMobile ? ResponsiveUtils.responsiveSpacing(context) * 0.125 : ResponsiveUtils.responsiveSpacing(context) * 0.25),
              ResponsiveComponents.responsiveText(
                context,
                data.subtitle,
                style: ResponsiveTextStyle.responsive(
                  context,
                  mobileFontSize: 8.0,
                  tabletFontSize: 10.0,
                  smallDesktopFontSize: 12.0,
                  largeDesktopFontSize: 14.0,
                  color: AppColors.grey500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}