import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

/// State holder Course Explorer v2 (ChangeNotifier).
///
/// Tahap 5: favorites (shared state) dengan notifyListeners().
/// Tahap 11: async state loading/error/data melalui repository.
/// Provider ini TIDAK mengandung widget dan TIDAK menyimpan BuildContext.
class CourseProvider extends ChangeNotifier {
  CourseProvider({CourseRepository? repository})
      : _repository = repository ?? const CourseRepository();

  final CourseRepository _repository;

  // ---- shared state: favorites (Tahap 5) ----
  final Set<String> _favorites = <String>{};

  Set<String> get favorites => Set<String>.unmodifiable(_favorites);
  bool isFavorite(String code) => _favorites.contains(code);
  int get favoriteCount => _favorites.length;

  void toggleFavorite(String code) {
    if (!_favorites.remove(code)) {
      _favorites.add(code);
    }
    notifyListeners();
  }

  void clearFavorites() {
    if (_favorites.isEmpty) {
      return;
    }
    _favorites.clear();
    notifyListeners();
  }

  // ---- async state: courses dari repository (Tahap 11) ----
  List<Course> courses = <Course>[];
  bool isLoading = false;
  String? error;

  List<Course> get favoriteCourses =>
      courses.where((Course c) => _favorites.contains(c.code)).toList();

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      courses = await _repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}