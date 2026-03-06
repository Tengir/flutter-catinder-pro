import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hw_1/data/services/analytics_service.dart';
import 'package:hw_1/data/services/onboarding_service.dart';
import 'package:hw_1/presentation/controllers/auth_controller.dart';
import 'package:hw_1/presentation/screens/home_screen.dart';
import 'package:hw_1/presentation/screens/onboarding_screen.dart';
import 'package:hw_1/presentation/screens/auth/login_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool _isLoading = true;
  bool _onboardingCompleted = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final onboarding = context.read<OnboardingService>();
    final auth = context.read<AuthController>();

    final completed = await onboarding.isCompleted();
    await auth.checkAuthStatus();

    if (!mounted) return;

    setState(() {
      _onboardingCompleted = completed;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Consumer<AuthController>(
      builder: (context, auth, _) {
        if (!_onboardingCompleted) {
          final analytics = context.read<AnalyticsService>();
          final onboardingService = context.read<OnboardingService>();
          return OnboardingScreen(
            onFinished: () async {
              await analytics.logOnboardingComplete();
              await onboardingService.setCompleted(true);
              if (!mounted) return;
              setState(() {
                _onboardingCompleted = true;
              });
            },
          );
        }

        if (!auth.isLoggedIn) {
          return const LoginScreen();
        }

        return const HomeScreen();
      },
    );
  }
}
