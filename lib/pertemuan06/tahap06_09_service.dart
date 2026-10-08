import 'package:flutter/material.dart';

import '../models/course.dart';
import '../services/course_service.dart';
import '../widgets/identity_header.dart';

/// Tahap 9: Service / Data Source.
///
/// CourseService bertanggung jawab pada detail teknis membaca JSON asset
/// (rootBundle + jsonDecode + validasi). UI hanya menerima `Future<List<Course>>`.
void main() => runApp(const Tahap06Stage9App());

class Tahap06Stage9App extends StatelessWidget {
  const Tahap06Stage9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 9 - CourseService',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _ServiceDemo(),
    );
  }
}

class _ServiceDemo extends StatelessWidget {
  const _ServiceDemo();

  static final CourseService _service = CourseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 9 - CourseService')),
      body: FutureBuilder<List<Course>>(
        future: _service.loadCourses(),
        builder: (BuildContext context, AsyncSnapshot<List<Course>> snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final List<Course> courses = snap.data ?? const <Course>[];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const IdentityHeader(),
              const SizedBox(height: 16),
              Text(
                '${courses.length} course dimuat melalui CourseService '
                '(rootBundle di service, bukan di UI).',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              for (final Course course in courses)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: Text('${course.code} - ${course.title}'),
                    subtitle: Text(
                      '${course.credits} SKS · ${course.statusLabel}',
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}