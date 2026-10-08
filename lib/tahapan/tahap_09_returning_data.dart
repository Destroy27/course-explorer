import 'package:flutter/material.dart';

import '../core/student_identity.dart';
import '../models/course.dart';
import '../data/course_repository.dart';

/// Tahap 9: returning data dari screen (Navigator.pop dengan result).
void main() => runApp(const Tahap9App());

class Tahap9App extends StatelessWidget {
  const Tahap9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _ListPage(),
    );
  }
}

class _ListPage extends StatefulWidget {
  const _ListPage();

  @override
  State<_ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<_ListPage> {
  final Set<String> _favoriteCodes = <String>{};

  Future<void> _openDetail(Course course) async {
    // await Navigator.push dapat menerima nilai hasil pop.
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => _ConfirmPage(course: course),
      ),
    );

    if (!mounted || result == null) {
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
              ? '${course.code} ditandai sebagai favorit - $identityLine'
              : '${course.code} favorite dibatalkan',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 9 - Returning Data')),
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

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (BuildContext context, int index) {
                final Course course = courses[index];
                final bool isFavorite = _favoriteCodes.contains(course.code);

                return Card(
                  child: ListTile(
                    leading: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.amber.shade700 : null,
                    ),
                    title: Text(course.title),
                    subtitle: Text('${course.code} - $identityLine'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openDetail(course),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ConfirmPage extends StatelessWidget {
  const _ConfirmPage({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.code)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              course.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('Mahasiswa: $identityLine'),
            const Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      // pop dengan hasil true.
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.favorite),
                    label: const Text('Pilih / Favorite'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}