import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/controllers/auth_controller.dart';
import 'package:hw_1/presentation/widgets/auth_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AuthController>();
    return AuthForm(
      title: AppStrings.authSignUp,
      primaryButtonText: AppStrings.authButtonSignUp,
      switchText: AppStrings.authSwitchToLogin,
      onSubmit: (email, password) async {
        await controller.signUp(email, password);
        if (context.mounted && controller.isLoggedIn) {
          Navigator.of(context).pop();
        }
      },
      onSwitch: () => Navigator.of(context).pop(),
    );
  }
}
