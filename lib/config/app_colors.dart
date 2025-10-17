import 'package:flutter/material.dart';

/// Centralized color system for the entire application
/// Eye-safe, modern color palette with excellent contrast ratios
class AppColors {
  // ===== PRIMARY COLORS - Modern Blue =====
  static const Color primary = Color(0xFF4F46E5); // Indigo 600 - Modern, professional
  static const Color primaryLight = Color(0xFFE0E7FF); // Indigo 100 - Soft background
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800 - Deep accent
  static const Color primaryExtraLight = Color(0xFFF8FAFC); // Slate 50 - Very light

  // ===== SECONDARY COLORS - Emerald Green =====
  static const Color secondary = Color(0xFF059669); // Emerald 600 - Success, growth
  static const Color secondaryLight = Color(0xFFD1FAE5); // Emerald 100 - Soft success
  static const Color secondaryDark = Color(0xFF047857); // Emerald 700 - Deep success
  static const Color secondaryExtraLight = Color(0xFFF0FDF4); // Green 50 - Very light

  // ===== ACCENT COLORS - Warm Orange =====
  static const Color accent = Color(0xFFEA580C); // Orange 600 - Warm, energetic
  static const Color accentLight = Color(0xFFFED7AA); // Orange 200 - Soft accent
  static const Color accentDark = Color(0xFFC2410C); // Orange 700 - Deep accent
  static const Color accentExtraLight = Color(0xFFFFF7ED); // Orange 50 - Very light

  // ===== STATUS COLORS - Eye-Safe =====
  static const Color success = Color(0xFF16A34A); // Green 600 - Clear success
  static const Color successLight = Color(0xFFDCFCE7); // Green 100 - Soft success
  static const Color error = Color(0xFFDC2626); // Red 600 - Clear error
  static const Color errorLight = Color(0xFFFEE2E2); // Red 100 - Soft error
  static const Color warning = Color(0xFFD97706); // Amber 600 - Clear warning
  static const Color warningLight = Color(0xFFFEF3C7); // Amber 100 - Soft warning
  static const Color info = Color(0xFF0EA5E9); // Sky 500 - Clear info
  static const Color infoLight = Color(0xFFE0F2FE); // Sky 100 - Soft info

  // ===== NEUTRAL COLORS - Modern Grays =====
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Modern gray scale with better contrast
  static const Color grey50 = Color(0xFFF8FAFC);   // Slate 50 - Lightest
  static const Color grey100 = Color(0xFFF1F5F9);  // Slate 100 - Very light
  static const Color grey200 = Color(0xFFE2E8F0);  // Slate 200 - Light
  static const Color grey300 = Color(0xFFCBD5E1);  // Slate 300 - Medium light
  static const Color grey400 = Color(0xFF94A3B8);  // Slate 400 - Medium
  static const Color grey500 = Color(0xFF64748B);  // Slate 500 - Medium
  static const Color grey600 = Color(0xFF475569);  // Slate 600 - Medium dark
  static const Color grey700 = Color(0xFF334155);  // Slate 700 - Dark
  static const Color grey800 = Color(0xFF1E293B);  // Slate 800 - Very dark
  static const Color grey900 = Color(0xFF0F172A);  // Slate 900 - Darkest

  // ===== SURFACE COLORS =====
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFF1F5F9);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F0);

  // ===== BACKGROUND COLORS =====
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color backgroundContainer = Color(0xFFF8FAFC);

  // ===== SEMANTIC COLORS =====
  // Text colors with proper contrast
  static const Color textPrimary = Color(0xFF0F172A);    // Slate 900 - High contrast
  static const Color textSecondary = Color(0xFF475569);   // Slate 600 - Medium contrast
  static const Color textTertiary = Color(0xFF64748B);    // Slate 500 - Lower contrast
  static const Color textInverse = Color(0xFFFFFFFF);     // White - For dark backgrounds
  static const Color textDisabled = Color(0xFF94A3B8);    // Slate 400 - Disabled state

  // Border colors
  static const Color borderLight = Color(0xFFE2E8F0);     // Slate 200 - Light borders
  static const Color borderMedium = Color(0xFFCBD5E1);     // Slate 300 - Medium borders
  static const Color borderDark = Color(0xFF475569);       // Slate 600 - Dark borders

  // ===== COMPONENT SPECIFIC COLORS =====
  // Card colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF1E293B);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Button colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonSuccess = success;
  static const Color buttonError = error;
  static const Color buttonWarning = warning;
  static const Color buttonInfo = info;
  static const Color buttonDisabled = grey300;

  // Status specific colors
  static const Color statusActive = success;
  static const Color statusPending = warning;
  static const Color statusCompleted = secondary;
  static const Color statusOnHold = error;
  static const Color statusCancelled = grey500;

  // ===== THEME COLORS =====
  // Light theme colors
  static const Color lightPrimary = primary;
  static const Color lightOnPrimary = white;
  static const Color lightSecondary = secondary;
  static const Color lightOnSecondary = white;
  static const Color lightSurface = surface;
  static const Color lightOnSurface = textPrimary;
  static const Color lightBackground = background;
  static const Color lightOnBackground = textPrimary;

  // Dark theme colors
  static const Color darkPrimary = Color(0xFF6366F1); // Indigo 500 - Lighter for dark theme
  static const Color darkOnPrimary = white;
  static const Color darkSecondary = Color(0xFF10B981); // Emerald 500 - Lighter for dark theme
  static const Color darkOnSecondary = white;
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkOnSurface = Color(0xFFF1F5F9); // Slate 100
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkOnBackground = Color(0xFFF1F5F9); // Slate 100

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

  /// Get text color based on background color for optimal contrast
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
    return isDark ? darkSurface : surface;
  }

  /// Get background color based on theme
  static Color getBackgroundColor(bool isDark) {
    return isDark ? darkBackground : background;
  }

  /// Get primary color based on theme
  static Color getPrimaryColor(bool isDark) {
    return isDark ? darkPrimary : lightPrimary;
  }

  /// Get secondary color based on theme
  static Color getSecondaryColor(bool isDark) {
    return isDark ? darkSecondary : lightSecondary;
  }

  /// Get text color based on theme
  static Color getTextColor(bool isDark) {
    return isDark ? darkOnSurface : lightOnSurface;
  }

  /// Get muted text color based on theme
  static Color getMutedTextColor(bool isDark) {
    return isDark ? grey400 : grey600;
  }

  /// Get card background color based on theme
  static Color getCardBackgroundColor(bool isDark) {
    return isDark ? darkSurface : cardBackground;
  }

  /// Get elevation color based on theme
  static Color getElevationColor(bool isDark) {
    return isDark ? grey800.withValues(alpha: 0.3) : grey200.withValues(alpha: 0.5);
  }
}