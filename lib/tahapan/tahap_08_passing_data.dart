import 'package:flutter/material.dart';

import '../core/student_identity.dart';
import '../data/course.dart';
import '../data/course_repository.dart';

/// Tahap 8: passing data dari list ke detail page lewat constructor.
void main() => runApp(const Tahap8App());

class Tahap8App extends StatelessWidget {
  const Tahap8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _ListPage(),
    );
  }
}

class _ListPage extends StatelessWidget {
  const _ListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 8 - Passing Data')),
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

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Identitas: $identityLine',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  );
                }

                final Course course = courses[index - 1];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(course.code)),
                    title: Text(course.title),
                    subtitle: Text(
                      '${course.credits} SKS - ${course.statusLabel}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Map course dikirim ke detail lewat constructor.
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              _DetailPage(course: course),
                        ),
                      );
                    },
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

class _DetailPage extends StatelessWidget {
  const _DetailPage({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(course.code)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              course.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Kode: ${course.code}'),
            Text('SKS: ${course.credits}'),
            Text('Status: ${course.statusLabel}'),
            const SizedBox(height: 16),
            Text(course.description),
            const SizedBox(height: 16),
            Text(
              'Mahasiswa: $identityLine',
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}