import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:hw_1/domain/utils/app_strings.dart';

import 'auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  AuthService({FlutterSecureStorage? secureStorage})
    : _secureStorage =
          secureStorage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  static const _keyEmail = 'auth_email';
  static const _keyPassword = 'auth_password';
  static const _keyLoggedIn = 'auth_logged_in';

  final FlutterSecureStorage _secureStorage;

  Future<void> signUp(String email, String password) async {
    await _secureStorage.write(key: _keyEmail, value: email);
    await _secureStorage.write(key: _keyPassword, value: password);
    await _secureStorage.write(key: _keyLoggedIn, value: 'true');
  }

  Future<void> login(String email, String password) async {
    final storedEmail = await _secureStorage.read(key: _keyEmail);
    final storedPassword = await _secureStorage.read(key: _keyPassword);

    if (storedEmail == null || storedPassword == null) {
      throw AuthException(AppStrings.authErrorUserNotFound);
    }

    if (storedEmail != email || storedPassword != password) {
      throw AuthException(AppStrings.authErrorWrongCredentials);
    }

    await _secureStorage.write(key: _keyLoggedIn, value: 'true');
  }

  Future<bool> isLoggedIn() async {
    final flag = await _secureStorage.read(key: _keyLoggedIn);
    return flag == 'true';
  }

  Future<void> logout() async {
    await _secureStorage.write(key: _keyLoggedIn, value: 'false');
  }
}

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException($message)';
}
