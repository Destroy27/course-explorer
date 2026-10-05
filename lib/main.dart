import 'package:flutter/material.dart';

import 'core/breakpoint.dart';
import 'core/student_identity.dart';
import 'data/course.dart';
import 'data/course_repository.dart';
import 'screens/course_detail_page.dart';
import 'screens/courses_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'widgets/app_shell.dart';
import 'widgets/identity_header.dart';

void main() {
  runApp(const CourseExplorerApp());
}

/// Aplikasi Course Explorer: responsive layout, navigation, dan interaction.
class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key, this.courseLoader});

  /// Sumber data yang dapat diganti, dipakai oleh widget test.
  ///
  /// Bila null, data dibaca dari assets/data/course_data.json.
  final Future<List<Course>> Function()? courseLoader;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E5E8C),
    );

    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: colors, useMaterial3: true),
      home: CourseExplorerShell(courseLoader: courseLoader),
    );
  }
}

/// Shell aplikasi yang memuat data, mengatur index navigasi, dan favorites.
class CourseExplorerShell extends StatefulWidget {
  const CourseExplorerShell({super.key, this.courseLoader});

  /// Sumber data yang dapat diganti, dipakai oleh widget test.
  final Future<List<Course>> Function()? courseLoader;

  @override
  State<CourseExplorerShell> createState() => _CourseExplorerShellState();
}

class _CourseExplorerShellState extends State<CourseExplorerShell> {
  static const CourseRepository _repository = CourseRepository();

  late Future<List<Course>> _future = _loadCourses();

  final Set<String> _favoriteCodes = <String>{};
  int _currentIndex = 0;

  Future<List<Course>> _loadCourses() {
    return widget.courseLoader?.call() ?? _repository.loadCourses();
  }

  void _reload() {
    setState(() => _future = _loadCourses());
  }

  void _toggleFavorite(Course course) {
    setState(() {
      if (!_favoriteCodes.remove(course.code)) {
        _favoriteCodes.add(course.code);
      }
    });

    final bool isFavorite = _favoriteCodes.contains(course.code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${course.code} ${isFavorite ? 'ditambahkan ke' : 'dihapus dari'} '
          'favorit - $identityLine',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openCourse(Course course) async {
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => CourseDetailPage(
          course: course,
          isFavorite: _favoriteCodes.contains(course.code),
        ),
      ),
    );

    // Returning data: detail page mengirim hasil favorite kembali.
    if (result == null || !mounted) {
      return;
    }

    setState(() {
      if (result) {
        _favoriteCodes.add(course.code);
      } else {
        _favoriteCodes.remove(course.code);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result
              ? '${course.code} ditandai sebagai favorit'
              : '${course.code} favorite dibatalkan',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmClearFavorites() async {
    if (_favoriteCodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada course favorit.')),
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text(
          'Hapus ${_favoriteCodes.length} course dari daftar favorit?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(_favoriteCodes.clear);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Daftar favorit dikosongkan.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingView();
        }

        if (snapshot.hasError) {
          return _ErrorView(
            message: '${snapshot.error}',
            onRetry: _reload,
          );
        }

        final List<Course> courses = snapshot.data ?? const <Course>[];
        final int totalCredits = courses.fold<int>(
          0,
          (int total, Course course) => total + course.credits,
        );

        final List<Widget> pages = <Widget>[
          HomePage(
            courses: courses,
            favoriteCodes: _favoriteCodes,
            onOpenCourse: _openCourse,
            onToggleFavorite: _toggleFavorite,
          ),
          CoursesPage(
            courses: courses,
            favoriteCodes: _favoriteCodes,
            onOpenCourse: _openCourse,
            onToggleFavorite: _toggleFavorite,
            onClearFavorites: _confirmClearFavorites,
          ),
          ProfilePage(totalCredits: totalCredits),
        ];

        return AppShell(
          currentIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() => _currentIndex = index);
          },
          pages: pages,
        );
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Memuat data course $identityLine'),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Gagal memuat data course',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const IdentityHeader(dense: true),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper kecil untuk breakpoint agar bisa dipakai pada contoh terpisah.
LayoutCategory categoryOf(double width) => layoutCategoryOf(width);