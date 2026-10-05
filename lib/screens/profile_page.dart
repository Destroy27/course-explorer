import 'package:flutter/material.dart';

import '../core/student_identity.dart';
import '../widgets/feedback_form.dart';
import '../widgets/identity_header.dart';

/// Halaman profil mahasiswa sekaligus form umpan balik.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.totalCredits});

  final int totalCredits;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const IdentityHeader(),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Nama'),
                      subtitle: Text(studentName),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: const Text('NIM'),
                      subtitle: Text(studentId),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.school_outlined),
                      title: const Text('Kelas dan Program Studi'),
                      subtitle: Text('$studentClass - $studentProgram'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.workspace_premium_outlined),
                      title: const Text('Total SKS Terambil'),
                      subtitle: Text('$totalCredits SKS'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Feedback Praktikum',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Komentar minimal 5 karakter. Data terisi otomatis dari '
                'konstanta identitas.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: FeedbackForm(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Repository: $repositoryUrl',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}