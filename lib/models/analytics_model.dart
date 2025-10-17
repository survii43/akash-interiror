import 'package:flutter/material.dart';

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
