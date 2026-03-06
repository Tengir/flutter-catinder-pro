import 'package:flutter/foundation.dart';

import 'package:hw_1/data/services/analytics_service.dart';
import 'package:hw_1/data/services/auth_service.dart';
import 'package:hw_1/data/services/auth_service_interface.dart';
import 'package:hw_1/domain/utils/validators.dart';

enum AuthResult { success, failure }

class AuthController extends ChangeNotifier {
  AuthController({
    required this.authService,
    AnalyticsService? analyticsService,
  }) : _analyticsService = analyticsService;

  final AuthServiceInterface authService;
  final AnalyticsService? _analyticsService;

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;

  String? validateEmail(String? value) => AppValidators.validateEmail(value);
  String? validatePassword(String? value) =>
      AppValidators.validatePassword(value);

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();
    try {
      _isLoggedIn = await authService.isLoggedIn();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthResult> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await authService.login(email, password);
      _isLoggedIn = true;
      await _analyticsService?.logLogin(true);
      return AuthResult.success;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      await _analyticsService?.logLogin(false, e.message);
      return AuthResult.failure;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthResult> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await authService.signUp(email, password);
      _isLoggedIn = true;
      await _analyticsService?.logRegistration(true);
      return AuthResult.success;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      await _analyticsService?.logRegistration(false, e.message);
      return AuthResult.failure;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
