import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/breakpoint.dart';
import '../core/student_identity.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_header.dart';

/// Halaman daftar course dengan grid/list responsif (v2).
///
/// State favorit dan daftar course dibaca dari CourseProvider; aksi clear
/// favorit memakai dialog konfirmasi lalu memanggil provider.clearFavorites().
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

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

  Future<void> _confirmClearFavorites(BuildContext context) async {
    final CourseProvider provider = context.read<CourseProvider>();
    if (provider.favoriteCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada course favorit.')),
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text(
          'Hapus ${provider.favoriteCount} course dari daftar favorit?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    context.read<CourseProvider>().clearFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Daftar favorit dikosongkan.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CourseProvider provider = context.watch<CourseProvider>();
    final List<Course> courses = provider.courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _confirmClearFavorites(context),
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
                          isFavorite: provider.isFavorite(course.code),
                          onTap: () => _openDetail(context, course),
                          onToggleFavorite: () =>
                              _toggleFavorite(context, course),
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
                        isFavorite: provider.isFavorite(course.code),
                        onTap: () => _openDetail(context, course),
                        onToggleFavorite: () =>
                            _toggleFavorite(context, course),
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