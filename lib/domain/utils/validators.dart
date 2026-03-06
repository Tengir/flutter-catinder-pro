import 'package:hw_1/domain/utils/app_strings.dart';

/// Централизованные валидаторы (Domain Layer).
class AppValidators {
  AppValidators._();

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
    r'[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
    r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );

  static const int minPasswordLength = 6;

  static String? validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return AppStrings.validationEmailEmpty;
    }
    if (!_emailRegex.hasMatch(text)) {
      return AppStrings.validationEmailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return AppStrings.validationPasswordEmpty;
    }
    if (text.length < minPasswordLength) {
      return AppStrings.validationPasswordTooShort;
    }
    return null;
  }
}
