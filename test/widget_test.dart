// Uji untuk aplikasi Course Explorer: identitas, navigasi adaptif,
// validasi form, dan pemetaan data.
//
// Widget test memakai courseLoader yang disuntikkan agar tidak bergantung
// pada pembacaan file asset di dalam fake async widget test.

import 'package:course_explorer/core/breakpoint.dart';
import 'package:course_explorer/core/student_identity.dart';
import 'package:course_explorer/models/course.dart';
import 'package:course_explorer/data/course_repository.dart';
import 'package:course_explorer/main.dart';
import 'package:course_explorer/widgets/feedback_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Data contoh untuk widget test, bentuknya sama dengan isi JSON asli.
List<Course> _sampleCourses() => <Course>[
      const Course(
        code: 'MOB01',
        title: 'Responsive Layout, Navigation, dan User Interaction',
        credits: 4,
        status: 'active',
        category: 'Mobile',
        semester: '5',
        description: 'Mempelajari layout adaptif dan navigasi lintas platform.',
        skills: <String>['Layout', 'Navigation'],
      ),
      const Course(
        code: 'MOB02',
        title: 'State Management',
        credits: 3,
        status: 'planned',
        category: 'Mobile',
        semester: '6',
        description: 'Mengelola state aplikasi dengan Provider.',
        skills: <String>['Provider'],
      ),
    ];

Future<List<Course>> _fakeLoader() async => _sampleCourses();

/// Memompa sejumlah frame untuk menunggu Future dan animasi sederhana selesai.
Future<void> _pumpFrames(WidgetTester tester, {int frames = 5}) async {
  for (int i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  // Binding dipakai agar channel asset tersedia saat menguji repository.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Repository dan model', () {
    test('JSON asset terbaca dan berisi enam course', () async {
      final List<Course> courses =
          await const CourseRepository().loadCourses();

      expect(courses, hasLength(6));
      expect(courses.first.code, 'MOB01');
      expect(courses.map((Course c) => c.code), contains('MOB06'));
    });

    test('Course.fromJson memetakan field dan status', () {
      final Course course = Course.fromJson(<String, dynamic>{
        'code': 'MOB07',
        'title': 'Git dan GitHub',
        'credits': 2,
        'status': 'done',
        'category': 'Tooling',
        'semester': '1',
        'description': 'Deskripsi uji.',
        'skills': <dynamic>['Git'],
      });

      expect(course.code, 'MOB07');
      expect(course.credits, 2);
      expect(course.statusLabel, 'Selesai');
      expect(course.skills, <String>['Git']);
    });
  });

  group('Breakpoint', () {
    test('kategori layout mengikuti lebar', () {
      expect(layoutCategoryOf(400), LayoutCategory.compact);
      expect(layoutCategoryOf(700), LayoutCategory.medium);
      expect(layoutCategoryOf(1200), LayoutCategory.expanded);
    });

    test('jumlah kolom grid sesuai breakpoint', () {
      expect(gridColumnsFor(LayoutCategory.compact), 1);
      expect(gridColumnsFor(LayoutCategory.medium), 2);
      expect(gridColumnsFor(LayoutCategory.expanded), 3);
    });
  });

  group('Course Explorer', () {
    testWidgets('menampilkan identitas dan daftar course',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const CourseExplorerApp(courseLoader: _fakeLoader),
      );
      await _pumpFrames(tester);

      // Identitas wajib terlihat pada UI.
      expect(find.text(studentName), findsWidgets);
      expect(find.text(studentId), findsWidgets);

      // Berpindah ke tab Courses, lalu pastikan data tampil.
      await tester.tap(find.text('Courses'));
      await _pumpFrames(tester);

      expect(find.text('MOB01'), findsWidgets);
      expect(find.text('Responsive Layout, Navigation, dan User Interaction'),
          findsWidgets);
    });

    testWidgets('favorite ditandai dan diteruskan kembali ke list',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const CourseExplorerApp(courseLoader: _fakeLoader),
      );
      await _pumpFrames(tester);

      await tester.tap(find.text('Courses'));
      await _pumpFrames(tester);

      await tester.tap(find.byTooltip('Tambahkan ke favorit').first);
      await _pumpFrames(tester);

      // Ikon berubah menjadi bintang terisi dan SnackBar menyebut identitas.
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byTooltip('Hapus dari favorit'), findsOneWidget);
      expect(find.textContaining(studentId), findsWidgets);
    });

    testWidgets('compact memakai satu kolom dan NavigationBar',
        (WidgetTester tester) async {
      // 1080 x 2400 dengan dpr 3 menghasilkan ruang logis 360 x 800.
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const CourseExplorerApp(courseLoader: _fakeLoader),
      );
      await _pumpFrames(tester);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);

      await tester.tap(find.text('Courses'));
      await _pumpFrames(tester);

      expect(find.text('MOB01'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('expanded memakai NavigationRail dan tiga kolom',
        (WidgetTester tester) async {
      // 2560 x 1440 dengan dpr 1 menghasilkan ruang logis di atas 840.
      tester.view.physicalSize = const Size(2560, 1440);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const CourseExplorerApp(courseLoader: _fakeLoader),
      );
      await _pumpFrames(tester);

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(find.text('Courses'));
      await _pumpFrames(tester);

      expect(find.text('MOB01'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('dialog konfirmasi dapat dibatalkan dan disetujui',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const CourseExplorerApp(courseLoader: _fakeLoader),
      );
      await _pumpFrames(tester);

      await tester.tap(find.text('Courses'));
      await _pumpFrames(tester);
      await tester.tap(find.byTooltip('Tambahkan ke favorit').first);
      await _pumpFrames(tester);

      // Membatalkan dialog tidak mengubah daftar favorit.
      await tester.tap(find.byTooltip('Kosongkan favorit'));
      await _pumpFrames(tester);

      expect(find.text('Konfirmasi'), findsOneWidget);

      await tester.tap(find.text('Batal'));
      await _pumpFrames(tester);

      expect(find.text('Konfirmasi'), findsNothing);
      expect(find.byTooltip('Hapus dari favorit'), findsOneWidget);

      // Menyetujui dialog: SnackBar baru tampil setelah SnackBar sebelumnya
      // selesai, karena ScaffoldMessenger mengantrekan notifikasi.
      await tester.tap(find.byTooltip('Kosongkan favorit'));
      await _pumpFrames(tester);
      await tester.tap(find.text('Hapus'));
      await tester.pump(const Duration(seconds: 5));
      await _pumpFrames(tester);

      expect(find.text('Daftar favorit dikosongkan.'), findsWidgets);
      expect(find.byTooltip('Tambahkan ke favorit'), findsNWidgets(2));

      // Snackbar dibaca penuh agar tidak ada timer yang menggantung.
      await tester.pump(const Duration(seconds: 5));
    });
  });

  group('Form umpan balik', () {
    testWidgets('validasi gagal pada kolom kosong dan tidak meluber',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedbackForm()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Nama dan NIM sudah terisi, komentar masih kosong.
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Komentar wajib diisi'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('komentar terlalu pendek ditolak, data valid diterima',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedbackForm()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tiga karakter masih di bawah batas minimal lima karakter.
      await tester.enterText(find.byType(TextFormField).last, 'bag');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Komentar minimal 5 karakter'), findsOneWidget);

      // Data valid: proses kirim berjalan lalu SnackBar menampilkan hasil.
      await tester.enterText(
          find.byType(TextFormField).last, 'Materi responsive mudah dipahami.');
      await tester.tap(find.byType(FilledButton));
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pump(const Duration(seconds: 5));

      expect(tester.takeException(), isNull);
      expect(find.textContaining(studentName), findsWidgets);
    });
  });
}