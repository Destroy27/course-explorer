import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/student_identity.dart';
import '../data/course.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_header.dart';

/// Halaman daftar course dengan grid/list responsif.
class CoursesPage extends StatelessWidget {
  const CoursesPage({
    super.key,
    required this.courses,
    required this.favoriteCodes,
    required this.onOpenCourse,
    required this.onToggleFavorite,
    required this.onClearFavorites,
  });

  final List<Course> courses;
  final Set<String> favoriteCodes;
  final ValueChanged<Course> onOpenCourse;
  final ValueChanged<Course> onToggleFavorite;

  /// Aksi menghapus seluruh course dari daftar favorit.
  final VoidCallback onClearFavorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: <Widget>[
          IconButton(
            onPressed: onClearFavorites,
            tooltip: 'Kosongkan favorit',
            icon: const Icon(Icons.playlist_remove),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                studentId,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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

                  if (columns == 1) {
                    // Compact: satu kolom, jadi list.
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: courses.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final Course course = courses[index];
                        return CourseCard(
                          course: course,
                          isFavorite: favoriteCodes.contains(course.code),
                          onTap: () => onOpenCourse(course),
                          onToggleFavorite: () => onToggleFavorite(course),
                        );
                      },
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 230,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Course course = courses[index];
                      return CourseCard(
                        course: course,
                        isFavorite: favoriteCodes.contains(course.code),
                        onTap: () => onOpenCourse(course),
                        onToggleFavorite: () => onToggleFavorite(course),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}