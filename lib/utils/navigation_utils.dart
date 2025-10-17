import 'package:flutter/material.dart';

/// Navigation utilities to eliminate duplication
class NavigationUtils {
  /// Navigate to a screen with standard transition
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    Widget screen, {
    bool fullscreenDialog = false,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (context) => screen,
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  /// Navigate and replace current screen
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget screen, {
    TO? result,
  }) {
    return Navigator.of(context).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (context) => screen),
      result: result,
    );
  }

  /// Navigate and clear all previous screens
  static Future<T?> pushAndClearStack<T extends Object?>(
    BuildContext context,
    Widget screen,
  ) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  /// Pop current screen
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  /// Pop until specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  /// Pop to root
  static void popToRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// Show modal bottom sheet
  static Future<T?> showBottomSheet<T>(
    BuildContext context,
    Widget child, {
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => child,
    );
  }

  /// Show dialog
  static Future<T?> showCustomDialog<T>(
    BuildContext context,
    Widget child, {
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  /// Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Show error snackbar
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Show info snackbar
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  /// Show warning snackbar
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }
}


/// Navigation mixin for common navigation patterns
mixin NavigationMixin {
  /// Navigate to form screen
  Future<T?> navigateToForm<T extends Object?>(
    BuildContext context,
    Widget formScreen,
  ) {
    return NavigationUtils.push<T>(context, formScreen);
  }

  /// Navigate to detail screen
  Future<T?> navigateToDetail<T extends Object?>(
    BuildContext context,
    Widget detailScreen,
  ) {
    return NavigationUtils.push<T>(context, detailScreen);
  }

  /// Show confirmation and navigate
  Future<bool> showConfirmationAndNavigate(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    // This would use CommonDialogs.showConfirmationDialog
    // Implementation depends on the dialog utility
    return false; // Placeholder
  }
}
