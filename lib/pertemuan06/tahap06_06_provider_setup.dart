import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';

/// Tahap 6: memasang Provider pada widget tree.
///
/// CourseProvider dibuat sekali di root (ChangeNotifierProvider.create) lalu
/// diakses oleh widget mana pun di bawahnya — di sini lewat context.watch
/// untuk menampilkan jumlah favorit dan context.read untuk aksi toggle.
void main() {
  runApp(
    ChangeNotifierProvider<CourseProvider>(
      create: (_) => CourseProvider(),
      child: const Tahap06Stage6App(),
    ),
  );
}

class Tahap06Stage6App extends StatelessWidget {
  const Tahap06Stage6App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 6 - Provider Setup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _ProviderSetupHome(),
    );
  }
}

class _ProviderSetupHome extends StatelessWidget {
  const _ProviderSetupHome();

  static const List<String> _demoCourses = <String>[
    'MOB04 - Responsive Layout',
    'MOB05 - State Management',
    'MOB06 - Mobile Service dan API',
  ];

  @override
  Widget build(BuildContext context) {
    // watch: rebuild saat state berubah (jumlah favorit).
    final CourseProvider provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 6 - Provider di Root')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const IdentityHeader(),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.extension),
              title: Text('${provider.favoriteCount} favorit'),
              subtitle: const Text(
                'nilai dibaca dengan context.watch<CourseProvider>()',
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final String course in _demoCourses)
            Card(
              child: ListTile(
                title: Text(course),
                trailing: IconButton(
                  onPressed: () =>
                      context.read<CourseProvider>().toggleFavorite(course),
                  icon: Icon(
                    provider.isFavorite(course)
                        ? Icons.star
                        : Icons.star_border,
                    color: provider.isFavorite(course)
                        ? Colors.amber.shade700
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'ChangeNotifierProvider dipasang pada runApp() di atas '
            'MaterialApp sehingga seluruh widget di bawahnya dapat '
            'mengakses CourseProvider.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}