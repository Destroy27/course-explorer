/// Model data satu course yang dibaca dari assets/data/course_data.json.
///
/// Dipindah dari lib/data/course.dart ke lib/models/course.dart pada refactor
/// Tahap 8: parsing JSON dipusatkan di factory fromJson sehingga UI tidak
/// pernah menyentuh key string secara langsung.
class Course {
  const Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    required this.category,
    required this.semester,
    required this.description,
    required this.skills,
  });

  final String code;
  final String title;
  final int credits;
  final String status;
  final String category;
  final String semester;
  final String description;
  final List<String> skills;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String? ?? '-',
      title: json['title'] as String? ?? 'Tanpa Judul',
      credits: json['credits'] as int? ?? 0,
      status: json['status'] as String? ?? 'planned',
      category: json['category'] as String? ?? 'Umum',
      semester: json['semester'] as String? ?? '-',
      description: json['description'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic e) => e.toString())
          .toList(),
    );
  }

  /// Label status yang lebih enak dibaca manusia.
  String get statusLabel {
    switch (status) {
      case 'done':
        return 'Selesai';
      case 'active':
        return 'Sedang Berjalan';
      default:
        return 'Direncanakan';
    }
  }
}