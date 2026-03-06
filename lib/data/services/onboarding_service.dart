import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const _keyCompleted = 'onboarding_completed';

  Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCompleted) ?? false;
  }

  Future<void> setCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompleted, value);
  }
}
