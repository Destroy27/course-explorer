import 'dart:convert';

import 'package:flutter/services.dart';

import 'course.dart';

/// Sumber data course: memuat collection/JSON statis dari folder assets.
class CourseRepository {
  const CourseRepository({this.assetPath = defaultAssetPath});

  /// Lokasi file JSON di dalam folder assets.
  static const String defaultAssetPath = 'assets/data/course_data.json';

  final String assetPath;

  /// Memuat daftar course dari file JSON statis.
  ///
  /// Jika file tidak berisi key `courses`, maka FormatException dilempar agar
  /// pemanggil dapat menampilkannya sebagai error state yang jelas.
  Future<List<Course>> loadCourses() async {
    final String raw = await rootBundle.loadString(assetPath);
    final Object? decoded = jsonDecode(raw);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Struktur JSON harus berupa objek.');
    }

    final Object? list = decoded['courses'];
    if (list is! List<dynamic>) {
      throw const FormatException('Key "courses" tidak ditemukan atau bukan array.');
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map(Course.fromJson)
        .toList(growable: false);
  }
}