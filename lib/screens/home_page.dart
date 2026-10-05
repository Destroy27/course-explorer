import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/student_identity.dart';
import '../data/course.dart';
import '../data/course_repository.dart';
import '../widgets/course_card.dart';
import '../widgets/feedback_form.dart';
import '../widgets/identity_header.dart';

/// Halaman utama Course Explorer.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.courses,
    required this.favoriteCodes,
    required this.onOpenCourse,
    required this.onToggleFavorite,
  });

  final List<Course> courses;
  final Set<String> favoriteCodes;
  final ValueChanged<Course> onOpenCourse;
  final ValueChanged<Course> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        actions: <Widget>[
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
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final LayoutCategory category = layoutCategoryOf(constraints.maxWidth);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const IdentityHeader(),
                  const SizedBox(height: 16),
                  _Ringkasan(category: category, courses: courses),
                  const SizedBox(height: 20),
                  _SectionTitle(
                    title: 'Course Terhighlight',
                    subtitle: 'Klik card untuk membuka halaman detail.',
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints innerConstraints,
                    ) {
                      final int columns = gridColumnsFor(
                        layoutCategoryOf(innerConstraints.maxWidth),
                      );
                      final List<Course> active = courses
                          .where((Course c) => c.status == 'active')
                          .toList();
                      final List<Course> shown = active.isEmpty
                          ? courses.take(2).toList()
                          : active;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 210,
                        ),
                        itemCount: shown.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Course course = shown[index];
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
                  const SizedBox(height: 24),
                  _SectionTitle(
                    title: 'Feedback Praktikum',
                    subtitle: 'Form dengan validasi nama, NIM, dan komentar.',
                  ),
                  const SizedBox(height: 12),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: FeedbackForm(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Data course dimuat dari '
                    '${CourseRepository.defaultAssetPath}.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _Ringkasan extends StatelessWidget {
  const _Ringkasan({required this.category, required this.courses});

  final LayoutCategory category;
  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    final int done = courses.where((Course c) => c.status == 'done').length;
    final int credits = courses.fold<int>(
      0,
      (int total, Course c) => total + c.credits,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            LayoutBadge(category: category),
            _Stat(label: 'Total course', value: '${courses.length}'),
            _Stat(label: 'Selesai', value: '$done'),
            _Stat(label: 'Total SKS', value: '$credits'),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Responsive Layout, Navigation, dan User Interaction. '
          'Praktikan oleh $identityLine.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: theme.textTheme.labelSmall),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}