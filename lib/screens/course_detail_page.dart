import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/student_identity.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

/// Halaman detail course (v2).
///
/// Klik favorite langsung mengubah [CourseProvider] (shared state), sehingga
/// daftar, halaman lain, dan halaman ini selalu konsisten — tanpa perlu
/// mengirim hasil balik lewat `Navigator.pop` seperti versi sebelumnya.
class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key, required this.course});

  final Course course;

  void _toggleFavorite(BuildContext context) {
    final CourseProvider provider = context.read<CourseProvider>();
    final bool isFavorite = !provider.isFavorite(course.code);
    provider.toggleFavorite(course.code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? '${course.code} ditandai sebagai favorit - $identityLine'
              : '${course.code} favorite dibatalkan - $identityLine',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final CourseProvider provider = context.watch<CourseProvider>();
    final bool favorite = provider.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: <Widget>[
          IconButton(
            tooltip: 'Tandai favorit',
            onPressed: () => _toggleFavorite(context),
            icon: Icon(
              favorite ? Icons.star : Icons.star_border,
              color: favorite ? Colors.amber.shade700 : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  Chip(label: Text('${course.credits} SKS')),
                  Chip(label: Text(course.statusLabel)),
                  Chip(label: Text(course.category)),
                  Chip(label: Text('Semester ${course.semester}')),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Deskripsi',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(course.description),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Kompetensi yang dilatih',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: course.skills
                    .map((String skill) => Chip(label: Text(skill)))
                    .toList(),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Dikirim oleh $identityLine',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _toggleFavorite(context),
                      icon: Icon(
                        favorite ? Icons.check_circle : Icons.star_outline,
                      ),
                      label: Text(
                        favorite ? 'Sudah Favorit' : 'Tandai Favorit',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}