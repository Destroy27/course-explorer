import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/breakpoint.dart';
import 'core/student_identity.dart';
import 'models/course.dart';
import 'providers/course_provider.dart';
import 'screens/courses_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'widgets/app_shell.dart';
import 'widgets/identity_header.dart';

void main() {
  runApp(const CourseExplorerApp());
}

/// Course Explorer v2: state dikelola [CourseProvider] (ChangeNotifier)
/// melalui package provider. Tidak ada lagi prop drilling — setiap screen
/// membaca state dengan `context.watch` dan mengubahnya dengan
/// `context.read`.
class CourseExplorerApp extends StatefulWidget {
  const CourseExplorerApp({super.key, this.courseLoader});

  /// Sumber data yang dapat diganti, dipakai oleh widget test.
  ///
  /// Bila null, data dibaca dari assets/data/course_data.json.
  final Future<List<Course>> Function()? courseLoader;

  @override
  State<CourseExplorerApp> createState() => _CourseExplorerAppState();
}

class _CourseExplorerAppState extends State<CourseExplorerApp> {
  late final CourseProvider _provider;

  @override
  void initState() {
    super.initState();
    // Satu-satunya tempat provider dibuat; pemuatan data dimulai di sini
    // (Tahap 11: async state lewat provider, bukan FutureBuilder di shell).
    _provider = CourseProvider(loader: widget.courseLoader)..loadCourses();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider dipasang DI ATAS MaterialApp sehingga seluruh
    // screen, termasuk route yang di-push, mendapat state yang sama.
    return ChangeNotifierProvider<CourseProvider>.value(
      value: _provider,
      child: MaterialApp(
        title: 'Course Explorer v2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
          useMaterial3: true,
        ),
        home: const CourseExplorerShell(),
      ),
    );
  }
}

/// Shell navigasi: hanya menyimpan local state index tab (Tahap 1).
class CourseExplorerShell extends StatefulWidget {
  const CourseExplorerShell({super.key});

  @override
  State<CourseExplorerShell> createState() => _CourseExplorerShellState();
}

class _CourseExplorerShellState extends State<CourseExplorerShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Shared state courses + favorites dibaca dari provider.
    final CourseProvider provider = context.watch<CourseProvider>();

    if (provider.isLoading) {
      return const _LoadingView();
    }
    if (provider.error != null) {
      return _ErrorView(
        message: provider.error!,
        onRetry: provider.loadCourses,
      );
    }

    final List<Widget> pages = <Widget>[
      const HomePage(),
      const CoursesPage(),
      const ProfilePage(),
    ];

    return AppShell(
      currentIndex: _currentIndex,
      onDestinationSelected: (int index) {
        setState(() => _currentIndex = index);
      },
      pages: pages,
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