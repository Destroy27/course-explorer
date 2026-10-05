import 'package:flutter/material.dart';

import '../data/course.dart';

/// Kartu course yang bisa dipakai di dalam GridView maupun ListView.
///
/// Widget ini menerima aksi tap dan toggle favorite dari luar sehingga
/// bisa dipakai pada halaman list (Tahap 5) dan pada integrasi akhir.
///
/// Deskripsi memakai LayoutBuilder agar aman di dua kondisi:
/// saat tinggi card dibatasi (GridView) maupun saat tinggi card bebas
/// mengikuti isi (ListView). Tanpa penanganan ini, card dapat memicu
/// RenderFlex overflow pada grid dengan mainAxisExtent kecil.
class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
    this.trailing,
  });

  final Course course;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  /// Widget tambahan di pojok bawah card, misalnya tombol aksi lain.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool hasFixedHeight = constraints.maxHeight.isFinite;

            return Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: hasFixedHeight ? MainAxisSize.max : MainAxisSize.min,
                children: <Widget>[
                  _header(context),
                  const SizedBox(height: 8),
                  _title(context),
                  const SizedBox(height: 8),
                  _tags(),
                  const SizedBox(height: 10),
                  if (hasFixedHeight)
                    // Height dibatasi: deskripsi mengisi sisa ruang.
                    Expanded(
                      child: Text(
                        course.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    Text(
                      course.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (trailing != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft, child: trailing),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            course.code,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onToggleFavorite != null)
          IconButton(
            onPressed: onToggleFavorite,
            visualDensity: VisualDensity.compact,
            tooltip: isFavorite
                ? 'Hapus dari favorit'
                : 'Tambahkan ke favorit',
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber.shade700 : null,
            ),
          ),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      course.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _tags() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: <Widget>[
        _Tag(label: '${course.credits} SKS'),
        _Tag(label: course.statusLabel),
        _Tag(label: 'Semester ${course.semester}'),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: theme.textTheme.labelSmall),
    );
  }
}