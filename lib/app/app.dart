import 'package:flutter/material.dart';

import 'package:hw_1/app/app_dependencies.dart';
import 'package:hw_1/app/app_theme.dart';
import 'package:hw_1/data/services/analytics_service.dart';
import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/screens/root_screen.dart';

class CatinderApp extends StatelessWidget {
  const CatinderApp({super.key, required this.apiKey, required this.analytics});

  final String apiKey;
  final AnalyticsService analytics;

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      apiKey: apiKey,
      analytics: analytics,
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: buildAppTheme(),
        debugShowCheckedModeBanner: false,
        home: const RootScreen(),
      ),
    );
  }
}
