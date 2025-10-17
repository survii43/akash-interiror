import 'package:flutter/material.dart';

/// Centralized color system for the entire application
/// All colors are defined here to ensure consistency and easy maintenance
class AppColors {
  // ===== PRIMARY COLORS =====
  static const Color primary = Color(0xFF2563EB); // Blue
  static const Color primaryLight = Color(0xFFDBEAFE);
  static const Color primaryDark = Color(0xFF1E40AF);

  // ===== SECONDARY COLORS =====
  static const Color secondary = Color(0xFF10B981); // Emerald Green
  static const Color secondaryLight = Color(0xFFD1FAE5);
  static const Color secondaryDark = Color(0xFF059669);

  // ===== ACCENT COLORS =====
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentLight = Color(0xFFFEF3C7);
  static const Color accentDark = Color(0xFFD97706);

  // ===== STATUS COLORS =====
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFCD34D);
  static const Color info = Color(0xFF3B82F6);

  // ===== NEUTRAL COLORS =====
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Grey scale (50-900)
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ===== SURFACE COLORS =====
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  // ===== BACKGROUND COLORS =====
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF111827);

  // ===== SEMANTIC COLORS =====
  // Text colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Border colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color borderDark = Color(0xFF9CA3AF);

  // ===== COMPONENT SPECIFIC COLORS =====
  // Card colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF1F2937);
  
  // Button colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonSuccess = success;
  static const Color buttonError = error;
  static const Color buttonWarning = warning;
  static const Color buttonInfo = info;
  
  // Status specific colors
  static const Color statusActive = success;
  static const Color statusPending = warning;
  static const Color statusCompleted = secondary;
  static const Color statusOnHold = error;
  static const Color statusCancelled = grey500;

  // ===== UTILITY METHODS =====
  /// Get status color based on status string
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return statusActive;
      case 'pending':
        return statusPending;
      case 'completed':
        return statusCompleted;
      case 'on hold':
        return statusOnHold;
      case 'cancelled':
        return statusCancelled;
      default:
        return grey500;
    }
  }

  /// Get text color based on background color
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance to determine if text should be light or dark
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimary : textInverse;
  }

  /// Get border color based on theme
  static Color getBorderColor(bool isDark) {
    return isDark ? grey600 : borderLight;
  }

  /// Get surface color based on theme
  static Color getSurfaceColor(bool isDark) {
    return isDark ? grey800 : surface;
  }
}
