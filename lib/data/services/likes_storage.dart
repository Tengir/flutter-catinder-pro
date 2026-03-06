import 'package:shared_preferences/shared_preferences.dart';

class LikesStorage {
  static const _likesKey = 'liked_cats';

  Future<int> loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_likesKey) ?? 0;
  }

  Future<void> saveLikes(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_likesKey, value);
  }
}
