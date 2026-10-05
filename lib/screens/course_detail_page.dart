import 'package:flutter/material.dart';

import '../core/student_identity.dart';
import '../data/course.dart';

/// Halaman detail course. Data course dikirim lewat constructor.
class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({
    super.key,
    required this.course,
    required this.isFavorite,
  });

  final Course course;
  final bool isFavorite;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late bool _isFavorite = widget.isFavorite;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Course course = widget.course;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: <Widget>[
          IconButton(
            tooltip: 'Tandai favorit',
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? Colors.amber.shade700 : null,
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
                      onPressed: () {
                        // Returning data: kirim hasil favorite ke list.
                        Navigator.pop(context, _isFavorite);
                      },
                      icon: Icon(
                        _isFavorite ? Icons.check_circle : Icons.star_outline,
                      ),
                      label: Text(
                        _isFavorite ? 'Sudah Favorit' : 'Tandai Favorit',
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