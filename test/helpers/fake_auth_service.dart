import 'package:hw_1/data/services/auth_service.dart';
import 'package:hw_1/data/services/auth_service_interface.dart';

/// Фейковый AuthService с in-memory хранилищем для тестов.
class FakeAuthService implements AuthServiceInterface {
  String? _email;
  String? _password;
  bool _loggedIn = false;

  @override
  Future<void> signUp(String email, String password) async {
    _email = email;
    _password = password;
    _loggedIn = true;
  }

  @override
  Future<void> login(String email, String password) async {
    if (_email == null || _password == null) {
      throw AuthException(
        'Пользователь не найден. Сначала зарегистрируйтесь.',
      );
    }
    if (_email != email || _password != password) {
      throw AuthException('Неверный email или пароль.');
    }
    _loggedIn = true;
  }

  @override
  Future<bool> isLoggedIn() async => _loggedIn;

  @override
  Future<void> logout() async {
    _loggedIn = false;
  }
}
