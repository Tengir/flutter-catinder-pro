import 'package:flutter/foundation.dart';

import 'package:hw_1/data/services/cat_api_service.dart';
import 'package:hw_1/data/services/likes_storage.dart';
import 'package:hw_1/domain/entities/app_error.dart';
import 'package:hw_1/domain/entities/cat_profile.dart';

class TinderController extends ChangeNotifier {
  TinderController({required this.apiService, required this.likesStorage});

  final CatApiService apiService;
  final LikesStorage likesStorage;

  CatProfile? _currentCat;
  bool _isLoading = false;
  AppError? _error;
  int _likes = 0;
  bool _initialized = false;

  CatProfile? get currentCat => _currentCat;
  bool get isLoading => _isLoading;
  int get likesCount => _likes;

  AppError? consumeError() {
    final error = _error;
    _error = null;
    return error;
  }

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _likes = await likesStorage.loadLikes();
    await loadNextCat();
  }

  Future<void> loadNextCat({bool forceError = false}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentCat = await apiService.fetchRandomCat(forceError: forceError);
    } on AppError catch (error) {
      _error = error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> likeCat() async {
    _likes += 1;
    await likesStorage.saveLikes(_likes);
    await loadNextCat();
  }

  Future<void> dislikeCat() => loadNextCat();
}
