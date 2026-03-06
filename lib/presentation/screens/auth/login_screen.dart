import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/controllers/auth_controller.dart';
import 'package:hw_1/presentation/screens/auth/signup_screen.dart';
import 'package:hw_1/presentation/widgets/auth_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AuthController>();
    return AuthForm(
      title: AppStrings.authLogin,
      primaryButtonText: AppStrings.authButtonLogin,
      switchText: AppStrings.authSwitchToSignUp,
      onSubmit: (email, password) => controller.login(email, password),
      onSwitch: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const SignUpScreen()));
      },
    );
  }
}
