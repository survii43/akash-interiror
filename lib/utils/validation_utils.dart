import '../config/app_strings.dart';

/// Utility class for common form validations
class ValidationUtils {
  /// Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Phone validation regex pattern
  static final RegExp _phoneRegex = RegExp(
    r'^[0-9\s\-\+\(\)]+$',
  );

  /// Validates if a field is required and not empty
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!_emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  /// Validates phone number format
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!_phoneRegex.hasMatch(value)) {
      return AppStrings.invalidPhone;
    }
    return null;
  }

  /// Validates name field (required)
  static String? validateName(String? value) {
    return validateRequired(value, 'Name');
  }

  /// Validates client selection
  static String? validateClient(int? value) {
    if (value == null) {
      return AppStrings.clientRequired;
    }
    return null;
  }

  /// Validates budget amount (optional but must be valid number if provided)
  static String? validateBudget(String? value) {
    if (value != null && value.isNotEmpty) {
      final budget = double.tryParse(value);
      if (budget == null) {
        return 'Please enter a valid budget amount';
      }
      if (budget < 0) {
        return 'Budget cannot be negative';
      }
    }
    return null;
  }

  /// Validates date range (end date should be after start date)
  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate != null && endDate != null) {
      if (endDate.isBefore(startDate)) {
        return 'End date must be after start date';
      }
    }
    return null;
  }
}
