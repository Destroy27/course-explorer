import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/breakpoint.dart';
import '../core/student_identity.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';
import '../services/course_service.dart';
import '../widgets/course_card.dart';
import '../widgets/feedback_form.dart';
import '../widgets/identity_header.dart';

/// Halaman utama Course Explorer v2.
///
/// State (daftar course dan favorit) dibaca langsung dari CourseProvider
/// dengan `context.watch`; tidak ada prop drilling parameter dari induk.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Membuka halaman detail lewat arah navigasi; detail membaca provider
  /// yang sama sehingga favorit konsisten dengan halaman ini.
  Future<void> _openDetail(BuildContext context, Course course) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CourseDetailPage(course: course),
      ),
    );
  }

  void _toggleFavorite(BuildContext context, Course course) {
    final CourseProvider provider = context.read<CourseProvider>();
    final bool isFavorite = !provider.isFavorite(course.code);
    provider.toggleFavorite(course.code);
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

  @override
  Widget build(BuildContext context) {
    final CourseProvider provider = context.watch<CourseProvider>();
    final List<Course> courses = provider.courses;

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

                      Widget buildCard(Course course) {
                        return CourseCard(
                          course: course,
                          isFavorite: provider.isFavorite(course.code),
                          onTap: () => _openDetail(context, course),
                          onToggleFavorite: () =>
                              _toggleFavorite(context, course),
                        );
                      }

                      // Compact: satu kolom memakai Column, bukan grid dengan
                      // mainAxisExtent tetap. Pada lebar ponsel sempit tag
                      // membungkus ke dua baris sehingga tinggi isi kartu
                      // melebihi extent dan memicu RenderFlex overflow.
                      if (columns == 1) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            for (int index = 0; index < shown.length; index++)
                              ...<Widget>[
                                if (index > 0) const SizedBox(height: 12),
                                buildCard(shown[index]),
                              ],
                          ],
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 230,
                        ),
                        itemCount: shown.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildCard(shown[index]);
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
                    '${CourseService.defaultAssetPath}.',
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