import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/student_identity.dart';

/// Widget identitas yang dipakai ulang di banyak halaman.
///
/// Dipisah menjadi file sendiri karena widget ini merupakan salah satu
/// bagian UI reusable yang diminta pada spesifikasi mini project.
class IdentityHeader extends StatelessWidget {
  const IdentityHeader({super.key, this.subtitle, this.dense = false});

  /// Baris kedua opsional, misalnya nama repository atau materi.
  final String? subtitle;

  /// Versi ringkas untuk dipakai di dalam list atau card.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: dense ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: dense ? 16 : 20,
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            child: Text(
              studentInitials,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: dense ? 12 : 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  studentName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle ?? '$studentId | $studentClass | $studentProgram',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onPrimaryContainer,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Panel kecil yang menampilkan nama kategori layout hasil breakpoint.
class LayoutBadge extends StatelessWidget {
  const LayoutBadge({super.key, required this.category});

  final LayoutCategory category;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Layout: ${category.label}',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}