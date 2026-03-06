import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/foundation.dart';

import 'package:hw_1/domain/utils/app_strings.dart';

/// Сервис аналитики (Data Layer). Обёртка над AppMetrica.
class AnalyticsService {
  AnalyticsService({required this.apiKey});

  final String apiKey;

  bool _initialized = false;

  /// Инициализация AppMetrica. Если apiKey пустой, активация не выполняется.
  Future<void> init() async {
    if (_initialized) return;
    if (apiKey.isEmpty) return;
    await AppMetrica.activate(AppMetricaConfig(apiKey));
    _initialized = true;
  }

  /// Универсальная отправка события с опциональными параметрами.
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    debugPrint(
      'STDOUT_LOG: Отправка события $name с параметрами $parameters',
    );
    if (!_initialized && apiKey.isEmpty) return;
    if (parameters == null || parameters.isEmpty) {
      await AppMetrica.reportEvent(name);
    } else {
      await AppMetrica.reportEventWithMap(name, parameters);
    }
    debugPrint(
      'AnalyticsService: event sent — name: $name, params: ${parameters ?? {}}',
    );
  }

  /// Событие регистрации (успех или ошибка).
  Future<void> logRegistration(bool success, [String? error]) async {
    final params = <String, Object>{
      AppStrings.analyticsParamSuccess: success,
    };
    if (error != null && error.isNotEmpty) {
      params[AppStrings.analyticsParamError] = error;
    }
    await logEvent(
      success
          ? AppStrings.analyticsEventRegistrationSuccess
          : AppStrings.analyticsEventRegistrationError,
      params,
    );
  }

  /// Событие входа (успех или ошибка).
  Future<void> logLogin(bool success, [String? error]) async {
    final params = <String, Object>{
      AppStrings.analyticsParamSuccess: success,
    };
    if (error != null && error.isNotEmpty) {
      params[AppStrings.analyticsParamError] = error;
    }
    await logEvent(
      success
          ? AppStrings.analyticsEventLoginSuccess
          : AppStrings.analyticsEventLoginError,
      params,
    );
  }

  /// Онбординг завершён.
  Future<void> logOnboardingComplete() async {
    await logEvent(AppStrings.analyticsEventOnboardingFinished);
  }
}
