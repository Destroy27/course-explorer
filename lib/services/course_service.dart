import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/course.dart';

/// Service / data source: detail teknis membaca data course dari JSON asset.
///
/// Tahap 9. Layer ini satu-satunya yang menyentuh rootBundle dan jsonDecode,
/// sehingga kelak dapat diganti dengan API tanpa mengubah screen.
class CourseService {
  const CourseService({this.assetPath = defaultAssetPath});

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