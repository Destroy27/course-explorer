import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../models/course.dart';
import '../data/course_repository.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_header.dart';

/// Tahap 5: GridView responsif dengan jumlah kolom mengikuti breakpoint.
void main() => runApp(const Tahap5App());

class Tahap5App extends StatelessWidget {
  const Tahap5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tahap 5 - GridView Responsif')),
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

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Gagal memuat data: ${snapshot.error}'),
                  ),
                );
              }

              final List<Course> courses = snapshot.data ?? const <Course>[];

              return Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: IdentityHeader(dense: true),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (
                        BuildContext context,
                        BoxConstraints constraints,
                      ) {
                        final LayoutCategory category =
                            layoutCategoryOf(constraints.maxWidth);
                        final int columns = gridColumnsFor(category);

                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 210,
                          ),
                          itemCount: courses.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CourseCard(course: courses[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}