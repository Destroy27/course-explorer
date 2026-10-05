/// Identitas mahasiswa untuk mata kuliah Pemrograman Mobile.
///
/// Seluruh halaman dan screenshot bukti memakai nilai dari file ini,
/// sehingga NIM dan Nama selalu konsisten di seluruh aplikasi.
class Student {
  const Student({
    required this.name,
    required this.id,
    required this.major,
    required this.className,
    required this.initials,
  });

  final String name;
  final String id;
  final String major;
  final String className;

  /// Inisial nama untuk avatar pada UI.
  final String initials;
}

/// Data identitas mahasiswa praktikum ini.
const Student student = Student(
  name: 'Gede Pasek Ary Sugiantara',
  id: '2415051074',
  major: 'Teknik Informatika',
  className: 'PTI 5C',
  initials: 'PA',
);

/// Nama repository praktikum.
const String repositoryUrl = 'https://github.com/Destroy27/course-explorer';

/// Nama mahasiswa.
String get studentName => student.name;

/// NIM mahasiswa.
String get studentId => student.id;

/// Kelas mahasiswa.
String get studentClass => student.className;

/// Program studi mahasiswa.
String get studentProgram => student.major;

/// Inisial nama untuk avatar.
String get studentInitials => student.initials;

/// Teks identitas ringkas untuk header dan screenshot bukti.
String get identityLine => '${student.id} - ${student.name}';