import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/controllers/auth_controller.dart';
import 'package:hw_1/presentation/widgets/auth_form.dart';

import '../helpers/fake_auth_service.dart';

Widget wrapWithProviders(Widget child) {
  return MaterialApp(
    home: ChangeNotifierProvider<AuthController>.value(
      value: AuthController(authService: FakeAuthService()),
      child: child,
    ),
  );
}

void main() {
  group('AuthForm виджет', () {
    testWidgets('отображает заголовок и кнопку входа', (tester) async {
      await tester.pumpWidget(
        wrapWithProviders(
          const AuthForm(
            title: AppStrings.authLogin,
            primaryButtonText: AppStrings.authButtonLogin,
            switchText: AppStrings.authSwitchToSignUp,
            onSubmit: _noopSubmit,
            onSwitch: _noop,
          ),
        ),
      );

      expect(find.text(AppStrings.authLogin), findsOneWidget);
      expect(find.text(AppStrings.authButtonLogin), findsOneWidget);
      expect(find.text(AppStrings.authSwitchToSignUp), findsOneWidget);
    });

    testWidgets('при пустом email сабмит показывает ошибку валидации',
        (tester) async {
      final controller = AuthController(authService: FakeAuthService());
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthController>.value(
            value: controller,
            child: const AuthForm(
              title: AppStrings.authLogin,
              primaryButtonText: AppStrings.authButtonLogin,
              switchText: AppStrings.authSwitchToSignUp,
              onSubmit: _noopSubmit,
              onSwitch: _noop,
            ),
          ),
        ),
      );

      await tester.tap(find.text(AppStrings.authButtonLogin));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.validationEmailEmpty), findsOneWidget);
    });

    testWidgets('при невалидном email сабмит показывает ошибку формата',
        (tester) async {
      final controller = AuthController(authService: FakeAuthService());
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthController>.value(
            value: controller,
            child: const AuthForm(
              title: AppStrings.authLogin,
              primaryButtonText: AppStrings.authButtonLogin,
              switchText: AppStrings.authSwitchToSignUp,
              onSubmit: _noopSubmit,
              onSwitch: _noop,
            ),
          ),
        ),
      );

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.first, 'not-an-email');
      await tester.enterText(fields.at(1), '123456');
      await tester.tap(find.text(AppStrings.authButtonLogin));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.validationEmailInvalid), findsOneWidget);
    });

    testWidgets('при коротком пароле сабмит показывает ошибку', (tester) async {
      final controller = AuthController(authService: FakeAuthService());
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthController>.value(
            value: controller,
            child: const AuthForm(
              title: AppStrings.authLogin,
              primaryButtonText: AppStrings.authButtonLogin,
              switchText: AppStrings.authSwitchToSignUp,
              onSubmit: _noopSubmit,
              onSwitch: _noop,
            ),
          ),
        ),
      );

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.first, 'user@test.com');
      await tester.enterText(fields.at(1), '12345');
      await tester.tap(find.text(AppStrings.authButtonLogin));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.validationPasswordTooShort), findsOneWidget);
    });

    testWidgets('успешный логин после регистрации не показывает ошибку',
        (tester) async {
      final fake = FakeAuthService();
      final controller = AuthController(authService: fake);
      await controller.signUp('u@t.com', 'pass12');
      await controller.logout();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthController>.value(
            value: controller,
            child: AuthForm(
              title: AppStrings.authLogin,
              primaryButtonText: AppStrings.authButtonLogin,
              switchText: AppStrings.authSwitchToSignUp,
              onSubmit: (email, password) => controller.login(email, password),
              onSwitch: _noop,
            ),
          ),
        ),
      );

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.first, 'u@t.com');
      await tester.enterText(fields.at(1), 'pass12');
      await tester.tap(find.text(AppStrings.authButtonLogin));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('при неверном пароле форма остаётся на экране',
        (tester) async {
      final fake = FakeAuthService();
      final controller = AuthController(authService: fake);
      await controller.signUp('u@t.com', 'correct');
      await controller.logout();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthController>.value(
            value: controller,
            child: AuthForm(
              title: AppStrings.authLogin,
              primaryButtonText: AppStrings.authButtonLogin,
              switchText: AppStrings.authSwitchToSignUp,
              onSubmit: (email, password) => controller.login(email, password),
              onSwitch: _noop,
            ),
          ),
        ),
      );

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.first, 'u@t.com');
      await tester.enterText(fields.at(1), 'wrong');
      await tester.tap(find.text(AppStrings.authButtonLogin));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.authLogin), findsOneWidget);
      expect(find.text(AppStrings.authButtonLogin), findsOneWidget);
    });

    testWidgets('кнопка переключения на регистрацию присутствует',
        (tester) async {
      await tester.pumpWidget(
        wrapWithProviders(
          const AuthForm(
            title: AppStrings.authSignUp,
            primaryButtonText: AppStrings.authButtonSignUp,
            switchText: AppStrings.authSwitchToLogin,
            onSubmit: _noopSubmit,
            onSwitch: _noop,
          ),
        ),
      );

      expect(find.text(AppStrings.authButtonSignUp), findsOneWidget);
      expect(find.text(AppStrings.authSwitchToLogin), findsOneWidget);
    });
  });
}

Future<void> _noopSubmit(String email, String password) async {}
void _noop() {}
