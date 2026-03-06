import 'package:flutter_test/flutter_test.dart';
import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/domain/utils/validators.dart';

void main() {
  group('AppValidators.validateEmail', () {
    test('возвращает ошибку для null', () {
      expect(
        AppValidators.validateEmail(null),
        AppStrings.validationEmailEmpty,
      );
    });

    test('возвращает ошибку для пустой строки', () {
      expect(
        AppValidators.validateEmail(''),
        AppStrings.validationEmailEmpty,
      );
    });

    test('возвращает ошибку для строки из пробелов', () {
      expect(
        AppValidators.validateEmail('   '),
        AppStrings.validationEmailEmpty,
      );
    });

    test('возвращает ошибку при отсутствии @', () {
      expect(
        AppValidators.validateEmail('user.example.com'),
        AppStrings.validationEmailInvalid,
      );
    });

    test('возвращает ошибку при некорректном формате (только @)', () {
      expect(
        AppValidators.validateEmail('@'),
        AppStrings.validationEmailInvalid,
      );
    });

    test('возвращает ошибку при некорректном домене (точка в начале)', () {
      expect(
        AppValidators.validateEmail('user@.com'),
        AppStrings.validationEmailInvalid,
      );
    });

    test('возвращает null для валидного email', () {
      expect(AppValidators.validateEmail('a@b.co'), isNull);
      expect(AppValidators.validateEmail('user@example.com'), isNull);
      expect(AppValidators.validateEmail('user.name+tag@example.co.uk'), isNull);
    });

    test('триммирует пробелы и валидирует', () {
      expect(AppValidators.validateEmail('  user@example.com  '), isNull);
    });
  });

  group('AppValidators.validatePassword', () {
    test('возвращает ошибку для null', () {
      expect(
        AppValidators.validatePassword(null),
        AppStrings.validationPasswordEmpty,
      );
    });

    test('возвращает ошибку для пустой строки', () {
      expect(
        AppValidators.validatePassword(''),
        AppStrings.validationPasswordEmpty,
      );
    });

    test('возвращает ошибку для пароля короче 6 символов', () {
      expect(
        AppValidators.validatePassword('12345'),
        AppStrings.validationPasswordTooShort,
      );
      expect(
        AppValidators.validatePassword('1'),
        AppStrings.validationPasswordTooShort,
      );
    });

    test('возвращает null для пароля ровно 6 символов', () {
      expect(AppValidators.validatePassword('123456'), isNull);
      expect(AppValidators.validatePassword('abcdef'), isNull);
    });

    test('возвращает null для длинного пароля', () {
      expect(AppValidators.validatePassword('password123'), isNull);
    });
  });
}
