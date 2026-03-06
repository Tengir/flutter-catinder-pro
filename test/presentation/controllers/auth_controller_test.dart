import 'package:flutter_test/flutter_test.dart';
import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/controllers/auth_controller.dart';

import '../../helpers/fake_auth_service.dart';

void main() {
  late AuthController controller;
  late FakeAuthService fakeService;

  setUp(() {
    fakeService = FakeAuthService();
    controller = AuthController(authService: fakeService);
  });

  group('AuthController валидация', () {
    test('validateEmail делегирует в AppValidators', () {
      expect(controller.validateEmail(null), AppStrings.validationEmailEmpty);
      expect(controller.validateEmail('bad'), AppStrings.validationEmailInvalid);
      expect(controller.validateEmail('a@b.co'), isNull);
    });

    test('validatePassword делегирует в AppValidators', () {
      expect(
        controller.validatePassword(''),
        AppStrings.validationPasswordEmpty,
      );
      expect(
        controller.validatePassword('12345'),
        AppStrings.validationPasswordTooShort,
      );
      expect(controller.validatePassword('123456'), isNull);
    });
  });

  group('AuthController signUp', () {
    test('успешная регистрация устанавливает isLoggedIn', () async {
      expect(controller.isLoggedIn, isFalse);

      final result = await controller.signUp('user@test.com', 'password1');

      expect(result, AuthResult.success);
      expect(controller.isLoggedIn, isTrue);
      expect(controller.errorMessage, isNull);
    });

    test('после signUp можно вызвать login с теми же данными', () async {
      await controller.signUp('u@t.com', 'pass12');
      await controller.logout();
      expect(controller.isLoggedIn, isFalse);

      final result = await controller.login('u@t.com', 'pass12');

      expect(result, AuthResult.success);
      expect(controller.isLoggedIn, isTrue);
    });
  });

  group('AuthController login', () {
    test('логин без регистрации возвращает failure и сообщение', () async {
      final result = await controller.login('nobody@test.com', 'any');

      expect(result, AuthResult.failure);
      expect(controller.isLoggedIn, isFalse);
      expect(controller.errorMessage, isNotNull);
      expect(
        controller.errorMessage,
        contains('Сначала зарегистрируйтесь'),
      );
    });

    test('неверный пароль возвращает failure', () async {
      await controller.signUp('u@t.com', 'correct');
      await controller.logout();

      final result = await controller.login('u@t.com', 'wrong');

      expect(result, AuthResult.failure);
      expect(controller.isLoggedIn, isFalse);
      expect(controller.errorMessage, isNotNull);
    });

    test('верные данные после signUp дают success', () async {
      await controller.signUp('u@t.com', 'secret1');
      await controller.logout();

      final result = await controller.login('u@t.com', 'secret1');

      expect(result, AuthResult.success);
      expect(controller.isLoggedIn, isTrue);
    });
  });

  group('AuthController checkAuthStatus', () {
    test('после signUp isLoggedIn true', () async {
      await controller.signUp('a@b.co', '123456');
      await controller.checkAuthStatus();
      expect(controller.isLoggedIn, isTrue);
    });

    test('после logout isLoggedIn false', () async {
      await controller.signUp('a@b.co', '123456');
      await controller.logout();
      expect(controller.isLoggedIn, isFalse);
    });
  });

  group('AuthController logout', () {
    test('logout сбрасывает isLoggedIn', () async {
      await controller.signUp('x@y.z', 'qwerty');
      expect(controller.isLoggedIn, isTrue);

      await controller.logout();

      expect(controller.isLoggedIn, isFalse);
    });
  });
}
