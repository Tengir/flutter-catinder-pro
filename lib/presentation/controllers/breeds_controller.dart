import 'package:flutter/foundation.dart';

import 'package:hw_1/data/services/cat_api_service.dart';
import 'package:hw_1/domain/entities/app_error.dart';
import 'package:hw_1/domain/entities/breed.dart';

class BreedsController extends ChangeNotifier {
  BreedsController({required this.apiService});

  final CatApiService apiService;

  final List<Breed> _breeds = [];
  List<Breed> _visibleBreeds = [];
  bool _isLoading = false;
  AppError? _error;
  bool _initialized = false;
  String _search = '';

  List<Breed> get breeds => List.unmodifiable(_visibleBreeds);
  bool get isLoading => _isLoading;
  AppError? get error => _error;
  bool get hasData => _breeds.isNotEmpty;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    await _loadBreeds();
  }

  Future<void> retry() => _loadBreeds();

  Future<void> _loadBreeds() async {
    _isLoading = true;
    _error = null;
    Future.microtask(notifyListeners);
    try {
      final items = await apiService.fetchBreeds();
      _breeds
        ..clear()
        ..addAll(items);
      _applySearch(_search);
    } on AppError catch (error) {
      _error = error;
    } finally {
      _isLoading = false;
      Future.microtask(notifyListeners);
    }
  }

  void search(String value) {
    _search = value;
    _applySearch(value);
    notifyListeners();
  }

  void _applySearch(String value) {
    if (value.isEmpty) {
      _visibleBreeds = List.of(_breeds);
      return;
    }
    final query = value.toLowerCase();
    _visibleBreeds = _breeds
        .where(
          (breed) =>
              breed.name.toLowerCase().contains(query) ||
              breed.origin.toLowerCase().contains(query),
        )
        .toList();
  }
}
