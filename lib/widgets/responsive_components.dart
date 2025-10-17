import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../config/app_colors.dart';

/// Responsive common components for consistent UI across devices
class ResponsiveComponents {
  /// Responsive card widget - Enhanced version of CommonCard
  static Widget responsiveCard({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double? elevation,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    final responsivePadding = ResponsiveUtils.responsivePadding(context);
    final responsiveMargin = ResponsiveUtils.responsiveMargin(context);
    final responsiveElevation = ResponsiveUtils.responsiveElevation(context);
    final responsiveBorderRadius = ResponsiveUtils.responsiveBorderRadius(context);

    return Container(
      margin: margin ?? responsiveMargin,
      child: Card(
        elevation: elevation ?? responsiveElevation,
        color: color ?? AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(responsiveBorderRadius),
        ),
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: borderRadius ?? BorderRadius.circular(responsiveBorderRadius),
                child: Padding(
                  padding: padding ?? responsivePadding,
                  child: child,
                ),
              )
            : Padding(
                padding: padding ?? responsivePadding,
                child: child,
              ),
      ),
    );
  }

  /// Responsive text widget
  static Widget responsiveText(
    BuildContext context,
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Responsive button widget
  static Widget responsiveButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isOutlined = false,
    bool isFullWidth = false,
    EdgeInsetsGeometry? padding,
  }) {
    final buttonHeight = ResponsiveUtils.responsiveButtonHeight(context);
    final fontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 14.0,
      tablet: 16.0,
      smallDesktop: 18.0,
      largeDesktop: 20.0,
    );
    final borderRadius = ResponsiveUtils.responsiveBorderRadius(context);

    Widget button = isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: foregroundColor,
              side: BorderSide(color: backgroundColor ?? AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: padding ?? EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.responsiveSpacing(context) * 2,
                vertical: ResponsiveUtils.responsiveSpacing(context),
              ),
              minimumSize: Size(0, buttonHeight),
            ),
            child: icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: fontSize * 0.8),
                      SizedBox(width: ResponsiveUtils.responsiveSpacing(context) * 0.5),
                      Text(text, style: TextStyle(fontSize: fontSize)),
                    ],
                  )
                : Text(text, style: TextStyle(fontSize: fontSize)),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.primary,
              foregroundColor: foregroundColor ?? Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: padding ?? EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.responsiveSpacing(context) * 2,
                vertical: ResponsiveUtils.responsiveSpacing(context),
              ),
              minimumSize: Size(0, buttonHeight),
            ),
            child: icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: fontSize * 0.8),
                      SizedBox(width: ResponsiveUtils.responsiveSpacing(context) * 0.5),
                      Text(text, style: TextStyle(fontSize: fontSize)),
                    ],
                  )
                : Text(text, style: TextStyle(fontSize: fontSize)),
          );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  /// Responsive icon widget
  static Widget responsiveIcon(
    BuildContext context,
    IconData icon, {
    Color? color,
    double? size,
  }) {
    final iconSize = size ?? ResponsiveUtils.responsiveIconSize(context);
    return Icon(icon, size: iconSize, color: color);
  }

  /// Responsive spacing widget
  static Widget responsiveSpacing(BuildContext context, {double? height, double? width}) {
    final spacing = ResponsiveUtils.responsiveSpacing(context);
    return SizedBox(
      height: height ?? spacing,
      width: width ?? spacing,
    );
  }

  /// Responsive divider
  static Widget responsiveDivider(BuildContext context, {Color? color, double? thickness}) {
    return Divider(
      color: color ?? AppColors.grey200,
      thickness: thickness ?? 1.0,
      height: ResponsiveUtils.responsiveSpacing(context),
    );
  }

  /// Responsive list tile
  static Widget responsiveListTile({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    final fontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 14.0,
      tablet: 16.0,
      smallDesktop: 18.0,
      largeDesktop: 20.0,
    );
    final subtitleFontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 12.0,
      tablet: 14.0,
      smallDesktop: 16.0,
      largeDesktop: 18.0,
    );

    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: AppColors.grey600,
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      enabled: enabled,
      contentPadding: ResponsiveUtils.responsivePadding(context),
    );
  }

  /// Responsive chip
  static Widget responsiveChip({
    required BuildContext context,
    required String label,
    Color? backgroundColor,
    Color? labelColor,
    IconData? icon,
    VoidCallback? onDeleted,
    VoidCallback? onTap,
  }) {
    final fontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 12.0,
      tablet: 14.0,
      smallDesktop: 16.0,
      largeDesktop: 18.0,
    );
    final borderRadius = ResponsiveUtils.responsiveBorderRadius(context) * 0.5;

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: labelColor,
          ),
        ),
        backgroundColor: backgroundColor,
        avatar: icon != null ? Icon(icon, size: fontSize * 0.8) : null,
        onDeleted: onDeleted,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Responsive progress indicator
  static Widget responsiveProgressIndicator(
    BuildContext context, {
    double? value,
    Color? backgroundColor,
    Color? valueColor,
    double? strokeWidth,
  }) {
    final size = ResponsiveUtils.responsiveIconSize(context);
    final stroke = strokeWidth ?? (ResponsiveUtils.isMobile(context) ? 3.0 : 4.0);

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(
          valueColor ?? AppColors.primary,
        ),
        strokeWidth: stroke,
      ),
    );
  }

  /// Responsive app bar
  static PreferredSizeWidget responsiveAppBar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    double? elevation,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    final titleFontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 18.0,
      tablet: 20.0,
      smallDesktop: 22.0,
      largeDesktop: 24.0,
    );

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      elevation: elevation ?? ResponsiveUtils.responsiveElevation(context),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  /// Responsive bottom navigation bar
  static Widget responsiveBottomNavigationBar({
    required BuildContext context,
    required int currentIndex,
    required ValueChanged<int> onTap,
    required List<BottomNavigationBarItem> items,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
  }) {
    final fontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 12.0,
      tablet: 14.0,
      smallDesktop: 16.0,
      largeDesktop: 18.0,
    );

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      type: BottomNavigationBarType.fixed,
      elevation: ResponsiveUtils.responsiveElevation(context),
      selectedLabelStyle: TextStyle(fontSize: fontSize),
      unselectedLabelStyle: TextStyle(fontSize: fontSize),
    );
  }
}
