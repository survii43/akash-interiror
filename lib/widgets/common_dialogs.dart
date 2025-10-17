import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_strings.dart';

/// Common dialog utilities to eliminate duplication
class CommonDialogs {
  /// Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: confirmColor ?? AppColors.error,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show delete confirmation dialog
  static Future<bool> showDeleteDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    return showConfirmationDialog(
      context,
      title: title,
      message: message,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
      confirmColor: AppColors.error,
    );
  }

  /// Show info dialog
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Show loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Show action sheet
  static Future<T?> showActionSheet<T>(
    BuildContext context, {
    required List<ActionSheetItem<T>> items,
    String? title,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => ActionSheet(
        title: title,
        items: items,
      ),
    );
  }
}

/// Action sheet item model
class ActionSheetItem<T> {
  final String title;
  final IconData? icon;
  final T value;
  final Color? color;

  const ActionSheetItem({
    required this.title,
    required this.value,
    this.icon,
    this.color,
  });
}

/// Action sheet widget
class ActionSheet<T> extends StatelessWidget {
  final String? title;
  final List<ActionSheetItem<T>> items;

  const ActionSheet({
    super.key,
    this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...items.map((item) => ListTile(
                leading: item.icon != null
                    ? Icon(
                        item.icon,
                        color: item.color,
                      )
                    : null,
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: item.color,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(item.value),
              )),
        ],
      ),
    );
  }
}

/// Generic confirmation dialog widget
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: confirmColor ?? AppColors.error,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
