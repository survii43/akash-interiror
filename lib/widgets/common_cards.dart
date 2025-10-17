import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../utils/responsive_utils.dart';
import 'responsive_components.dart';

/// Common card widgets to eliminate duplication
/// Note: CommonCard functionality is now provided by ResponsiveComponents.responsiveCard
/// This class is kept for backward compatibility but delegates to ResponsiveComponents
class CommonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const CommonCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Delegate to ResponsiveComponents for consistency
    return ResponsiveComponents.responsiveCard(
      context: context,
      child: child,
      padding: padding,
      margin: margin,
      elevation: elevation,
      color: color,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }
}

/// Status chip widget
class StatusChip extends StatelessWidget {
  final String status;
  final Color? color;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.status,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? _getDefaultColor(status);
    final fontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 12.0,
      tablet: 14.0,
      smallDesktop: 16.0,
      largeDesktop: 18.0,
    );
    final padding = ResponsiveUtils.responsiveSpacing(context);
    final borderRadius = ResponsiveUtils.responsiveBorderRadius(context);
    final iconSize = ResponsiveUtils.responsiveIconSize(context) * 0.5;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding * 0.5,
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(borderRadius * 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: chipColor),
            SizedBox(width: padding * 0.25),
          ],
          Text(
            status,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDefaultColor(String status) {
    return AppColors.getStatusColor(status);
  }
}

/// Info card widget
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: AppColors.grey600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Metric card widget for analytics
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.grey400,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.grey500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// List tile card widget
class ListTileCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ListTileCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      onTap: onTap,
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: trailing,
        onTap: onTap,
        onLongPress: onLongPress,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

/// Action buttons card
class ActionButtonsCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<ActionButton> actions;

  const ActionButtonsCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                color: AppColors.grey600,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: actions.map((action) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: action,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

/// Action button model
class ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isOutlined;

  const ActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 14.0,
      tablet: 16.0,
      smallDesktop: 18.0,
      largeDesktop: 20.0,
    );
    final iconSize = ResponsiveUtils.responsiveIconSize(context) * 0.6;
    final buttonHeight = ResponsiveUtils.responsiveButtonHeight(context);
    final borderRadius = ResponsiveUtils.responsiveBorderRadius(context);
    final padding = ResponsiveUtils.responsiveSpacing(context);

    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: iconSize) : const SizedBox.shrink(),
        label: Text(label, style: TextStyle(fontSize: fontSize)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          minimumSize: Size(0, buttonHeight),
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: iconSize) : const SizedBox.shrink(),
      label: Text(label, style: TextStyle(fontSize: fontSize)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: color != null ? Colors.white : null,
        minimumSize: Size(0, buttonHeight),
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
