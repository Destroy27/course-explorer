import 'package:flutter/material.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';
import '../widgets/identity_header.dart';

/// Tahap 10: Repository Pattern.
///
/// CourseRepository membungkus CourseService dan menyediakan API sederhana
/// getCourses() bagi Provider/screen. UI tidak tahu dari mana data berasal.
void main() => runApp(const Tahap06Stage10App());

class Tahap06Stage10App extends StatelessWidget {
  const Tahap06Stage10App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 10 - CourseRepository',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _RepositoryDemo(),
    );
  }
}

class _RepositoryDemo extends StatelessWidget {
  const _RepositoryDemo();

  static final CourseRepository _repository = CourseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 10 - CourseRepository')),
      body: FutureBuilder<List<Course>>(
        future: _repository.getCourses(),
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
              Card(
                child: ListTile(
                  leading: const Icon(Icons.hub),
                  title: Text('${courses.length} course via repository'),
                  subtitle: const Text(
                    'Screen → CourseRepository.getCourses() → '
                    'CourseService.loadCourses()',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final Course course in courses)
                Card(
                  child: ListTile(
                    title: Text('${course.code} - ${course.title}'),
                    subtitle: Text('${course.credits} SKS · Semester ${course.semester}'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}