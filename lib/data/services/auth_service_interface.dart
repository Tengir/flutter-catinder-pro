/// Абстрактный интерфейс сервиса авторизации для DI и тестов.
abstract interface class AuthServiceInterface {
  Future<void> signUp(String email, String password);
  Future<void> login(String email, String password);
  Future<bool> isLoggedIn();
  Future<void> logout();
}
