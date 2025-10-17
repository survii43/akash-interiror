import 'package:flutter/material.dart';

/// Responsive design utilities for device-specific adaptations
class ResponsiveUtils {
  // Device breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Get device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return DeviceType.mobile;
    if (width < tabletBreakpoint) return DeviceType.tablet;
    if (width < desktopBreakpoint) return DeviceType.smallDesktop;
    return DeviceType.largeDesktop;
  }

  /// Get responsive value based on device type
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? smallDesktop,
    T? largeDesktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.smallDesktop:
        return smallDesktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? smallDesktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.all(responsive(
      context,
      mobile: 16.0,
      tablet: 24.0,
      smallDesktop: 32.0,
      largeDesktop: 48.0,
    ));
  }

  /// Get responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return EdgeInsets.all(responsive(
      context,
      mobile: 8.0,
      tablet: 12.0,
      smallDesktop: 16.0,
      largeDesktop: 24.0,
    ));
  }

  /// Get responsive font size
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? smallDesktop,
    double? largeDesktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      smallDesktop: smallDesktop ?? mobile * 1.2,
      largeDesktop: largeDesktop ?? mobile * 1.3,
    );
  }

  /// Get responsive icon size
  static double responsiveIconSize(BuildContext context) {
    return responsive(
      context,
      mobile: 24.0,
      tablet: 28.0,
      smallDesktop: 32.0,
      largeDesktop: 36.0,
    );
  }

  /// Get responsive border radius
  static double responsiveBorderRadius(BuildContext context) {
    return responsive(
      context,
      mobile: 8.0,
      tablet: 12.0,
      smallDesktop: 16.0,
      largeDesktop: 20.0,
    );
  }

  /// Get responsive grid cross axis count
  static int responsiveGridCount(BuildContext context) {
    return responsive(
      context,
      mobile: 1,
      tablet: 2,
      smallDesktop: 3,
      largeDesktop: 4,
    );
  }

  /// Get responsive card elevation
  static double responsiveElevation(BuildContext context) {
    return responsive(
      context,
      mobile: 2.0,
      tablet: 4.0,
      smallDesktop: 6.0,
      largeDesktop: 8.0,
    );
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.smallDesktop || 
           deviceType == DeviceType.largeDesktop;
  }

  /// Get responsive spacing
  static double responsiveSpacing(BuildContext context) {
    return responsive(
      context,
      mobile: 8.0,
      tablet: 12.0,
      smallDesktop: 16.0,
      largeDesktop: 20.0,
    );
  }

  /// Get responsive button height
  static double responsiveButtonHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 48.0,
      tablet: 52.0,
      smallDesktop: 56.0,
      largeDesktop: 60.0,
    );
  }

  /// Get responsive app bar height
  static double responsiveAppBarHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 56.0,
      tablet: 64.0,
      smallDesktop: 72.0,
      largeDesktop: 80.0,
    );
  }

  /// Get responsive bottom navigation height
  static double responsiveBottomNavHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 60.0,
      tablet: 70.0,
      smallDesktop: 80.0,
      largeDesktop: 90.0,
    );
  }
}

/// Device type enumeration
enum DeviceType {
  mobile,
  tablet,
  smallDesktop,
  largeDesktop,
}

/// Responsive text style builder
class ResponsiveTextStyle {
  static TextStyle responsive(
    BuildContext context, {
    required double mobileFontSize,
    double? tabletFontSize,
    double? smallDesktopFontSize,
    double? largeDesktopFontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    final fontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: mobileFontSize,
      tablet: tabletFontSize,
      smallDesktop: smallDesktopFontSize,
      largeDesktop: largeDesktopFontSize,
    );

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

/// Responsive layout builder
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? smallDesktop;
  final Widget? largeDesktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.smallDesktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.responsive(
      context,
      mobile: mobile,
      tablet: tablet,
      smallDesktop: smallDesktop,
      largeDesktop: largeDesktop,
    );
  }
}

/// Responsive grid builder
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.responsiveGridCount(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: ResponsiveUtils.isMobile(context) ? 1.2 : 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Responsive container with adaptive constraints
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Decoration? decoration;
  final double? elevation;
  final BorderRadius? borderRadius;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.decoration,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = ResponsiveUtils.responsivePadding(context);
    final responsiveMargin = ResponsiveUtils.responsiveMargin(context);
    final responsiveBorderRadius = ResponsiveUtils.responsiveBorderRadius(context);
    final responsiveElevation = ResponsiveUtils.responsiveElevation(context);

    return Container(
      width: width,
      height: height,
      padding: padding ?? responsivePadding,
      margin: margin ?? responsiveMargin,
      decoration: decoration ??
          BoxDecoration(
            color: color,
            borderRadius: borderRadius ?? BorderRadius.circular(responsiveBorderRadius),
            boxShadow: elevation != null
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: responsiveElevation,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
      child: child,
    );
  }
}
