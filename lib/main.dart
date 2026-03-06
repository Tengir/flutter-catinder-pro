import 'package:flutter/material.dart';

import 'package:hw_1/app/app.dart';
import 'package:hw_1/data/services/analytics_service.dart';
import 'package:hw_1/domain/utils/app_strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const apiKey = String.fromEnvironment('CAT_API_KEY');
  const metricaKey = String.fromEnvironment('METRICA_KEY', defaultValue: '');
  if (apiKey.isEmpty) {
    debugPrint(AppStrings.debugApiKeyEmpty);
  }
  final analytics = AnalyticsService(apiKey: metricaKey);
  await analytics.init();
  runApp(CatinderApp(apiKey: apiKey, analytics: analytics));
}
