import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:hw_1/data/services/analytics_service.dart';
import 'package:hw_1/data/services/auth_service.dart';
import 'package:hw_1/data/services/cat_api_service.dart';
import 'package:hw_1/data/services/likes_storage.dart';
import 'package:hw_1/data/services/onboarding_service.dart';
import 'package:hw_1/presentation/controllers/auth_controller.dart';
import 'package:hw_1/presentation/controllers/breeds_controller.dart';
import 'package:hw_1/presentation/controllers/tinder_controller.dart';

class AppDependencies extends StatefulWidget {
  const AppDependencies({
    super.key,
    required this.apiKey,
    required this.analytics,
    required this.child,
  });

  final String apiKey;
  final AnalyticsService analytics;
  final Widget child;

  @override
  State<AppDependencies> createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {
  late final http.Client _client;
  late final CatApiService _apiService;
  late final LikesStorage _likesStorage;
  late final AuthService _authService;
  late final OnboardingService _onboardingService;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _apiService = CatApiService(client: _client, apiKey: widget.apiKey);
    _likesStorage = LikesStorage();
    _authService = AuthService();
    _onboardingService = OnboardingService();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AnalyticsService>.value(value: widget.analytics),
        Provider<CatApiService>.value(value: _apiService),
        Provider<LikesStorage>.value(value: _likesStorage),
        Provider<AuthService>.value(value: _authService),
        Provider<OnboardingService>.value(value: _onboardingService),
        ChangeNotifierProvider(
          create: (_) => AuthController(
            authService: _authService,
            analyticsService: widget.analytics,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TinderController(
            apiService: _apiService,
            likesStorage: _likesStorage,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BreedsController(apiService: _apiService),
        ),
      ],
      child: widget.child,
    );
  }
}
