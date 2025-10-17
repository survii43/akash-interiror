import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/analytics_model.dart';
import '../utils/responsive_utils.dart';

/// Reusable analytics card widget
class AnalyticsCard extends StatelessWidget {
  final AnalyticsCardData data;
  final bool isLoading;
  final double? width;

  const AnalyticsCard({
    super.key,
    required this.data,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = ResponsiveUtils.responsivePadding(context);
    final responsiveElevation = ResponsiveUtils.responsiveElevation(context);
    final responsiveBorderRadius = ResponsiveUtils.responsiveBorderRadius(context);
    final responsiveMargin = ResponsiveUtils.responsiveMargin(context);
    
    return Container(
      width: width,
      margin: responsiveMargin,
      child: Card(
        elevation: responsiveElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsiveBorderRadius),
        ),
        child: InkWell(
          onTap: data.onTap,
          borderRadius: BorderRadius.circular(responsiveBorderRadius),
          child: Padding(
            padding: responsivePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      data.icon,
                      color: data.color,
                      size: 24,
                    ),
                    if (isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.grey400,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    data.value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: data.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (data.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      data.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Analytics grid widget for displaying multiple cards
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
    
    if (isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) => AnalyticsCard(
          data: cards[index],
          isLoading: true,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => AnalyticsCard(
        data: cards[index],
      ),
    );
  }
}

/// Analytics summary widget with key metrics
class AnalyticsSummary extends StatelessWidget {
  final AnalyticsData data;
  final bool isLoading;

  const AnalyticsSummary({
    super.key,
    required this.data,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: AppColors.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Business Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Total Clients',
                  data.totalClients.toString(),
                  Icons.people,
                  AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Total Projects',
                  data.totalProjects.toString(),
                  Icons.work,
                  AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Completion Rate',
                  '${data.completionPercentage.toStringAsFixed(1)}%',
                  Icons.check_circle,
                  AppColors.success,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Payment Rate',
                  '${data.paymentCompletionPercentage.toStringAsFixed(1)}%',
                  Icons.payment,
                  AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
