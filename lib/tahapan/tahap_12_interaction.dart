import 'package:flutter/material.dart';

import '../core/student_identity.dart';
import '../data/course.dart';
import '../data/course_repository.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_header.dart';

/// Tahap 12: Button, InkWell, dan GestureDetector.
void main() => runApp(const Tahap12App());

class Tahap12App extends StatelessWidget {
  const Tahap12App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _InteractionDemo(),
    );
  }
}

class _InteractionDemo extends StatefulWidget {
  const _InteractionDemo();

  @override
  State<_InteractionDemo> createState() => _InteractionDemoState();
}

class _InteractionDemoState extends State<_InteractionDemo> {
  final Set<String> _favoriteCodes = <String>{};
  int _tapCount = 0;

  void _toggleFavorite(Course course) {
    setState(() {
      if (!_favoriteCodes.remove(course.code)) {
        _favoriteCodes.add(course.code);
      }
    });
  }

  Future<void> _showInfo(Course course) async {
    // long press memicu GestureDetector.onLongPress.
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(course.code),
        content: Text(
          '${course.title}\n${course.credits} SKS - ${course.statusLabel}\n\n'
          'Dipanggil dari $identityLine',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 12 - Interaction')),
      body: SafeArea(
        child: FutureBuilder<List<Course>>(
          future: const CourseRepository().loadCourses(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Course>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<Course> courses = snapshot.data ?? const <Course>[];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                const IdentityHeader(dense: true),
                const SizedBox(height: 12),
                Text(
                  'Jumlah tap tombol: $_tapCount',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: () => setState(() => _tapCount++),
                      icon: const Icon(Icons.touch_app),
                      label: const Text('Tambah tap'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _tapCount = 0),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Klik ikon bintang untuk favorite. Long press card untuk '
                  'informasi tambahan.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                ...courses.map(
                  (Course course) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onLongPress: () => _showInfo(course),
                      child: CourseCard(
                        course: course,
                        isFavorite: _favoriteCodes.contains(course.code),
                        onTap: () => _showInfo(course),
                        onToggleFavorite: () => _toggleFavorite(course),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}