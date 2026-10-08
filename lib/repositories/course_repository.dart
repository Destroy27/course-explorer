import '../models/course.dart';
import '../services/course_service.dart';

/// Repository: abstraksi antara Provider dan sumber data.
///
/// Tahap 10. Provider cukup memanggil getCourses() tanpa tahu apakah data
/// berasal dari JSON asset, REST API, Supabase, atau database lokal.
class CourseRepository {
  const CourseRepository({CourseService? service})
      : _service = service ?? const CourseService();

  final CourseService _service;

  /// Menyediakan daftar course bagi Provider.
  Future<List<Course>> getCourses() => _service.loadCourses();
}