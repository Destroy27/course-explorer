import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';

/// Tahap 13: shared favorites di beberapa screen.
///
/// Satu CourseProvider menjadi source of truth. Toggle dari List (tab Courses)
/// maupun DetailPage (route push) langsung menyinkronkan FavoritesPage karena
/// semuanya membaca provider yang sama — tanpa menyalin state.
void main() {
  runApp(
    ChangeNotifierProvider<CourseProvider>(
      create: (_) => CourseProvider()..loadCourses(),
      child: const Tahap06Stage13App(),
    ),
  );
}

class Tahap06Stage13App extends StatelessWidget {
  const Tahap06Stage13App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 13 - Shared Favorites',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _FavoritesShell(),
    );
  }
}

class _FavoritesShell extends StatefulWidget {
  const _FavoritesShell();

  @override
  State<_FavoritesShell> createState() => _FavoritesShellState();
}

class _FavoritesShellState extends State<_FavoritesShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const _CoursesTab(),
      const _FavoritesTab(),
      const _AboutTab(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 13 - Shared Favorites')),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int i) => setState(() => _index = i),
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.list), label: 'Courses'),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(icon: Icon(Icons.info), label: 'Tentang'),
        ],
      ),
    );
  }
}

class _CoursesTab extends StatelessWidget {
  const _CoursesTab();

  Future<void> _openDetail(BuildContext context, Course course) {
    // Route baru tetap membaca provider yang sama -> favorite konsisten.
    return Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _DetailPage(course: course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CourseProvider provider = context.watch<CourseProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(
        child: FilledButton.icon(
          onPressed: provider.loadCourses,
          icon: const Icon(Icons.refresh),
          label: const Text('Coba Lagi'),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        const IdentityHeader(),
        const SizedBox(height: 8),
        for (final Course course in provider.courses)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _DemoCourseCard(
              course: course,
              isFavorite: provider.isFavorite(course.code),
              onToggleFavorite: () =>
                  context.read<CourseProvider>().toggleFavorite(course.code),
              onTap: () => _openDetail(context, course),
            ),
          ),
      ],
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final CourseProvider provider = context.watch<CourseProvider>();
    final bool favorite = provider.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(title: Text(course.code)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            course.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text('${course.credits} SKS · ${course.statusLabel}'),
          const Divider(height: 24),
          Text(course.description),
          const SizedBox(height: 16),
          // Toggle di sini memakai provider yang sama -> list ikut berubah.
          FilledButton.icon(
            onPressed: () =>
                context.read<CourseProvider>().toggleFavorite(course.code),
            icon: Icon(favorite ? Icons.star : Icons.star_border),
            label: Text(favorite ? 'Batal Favorit' : 'Tandai Favorit'),
          ),
        ],
      ),
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  const _FavoritesTab();

  @override
  Widget build(BuildContext context) {
    final CourseProvider provider = context.watch<CourseProvider>();
    final List<Course> favorites = provider.favoriteCourses;

    if (favorites.isEmpty) {
      return const Center(child: Text('Belum ada course favorit.'));
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        const IdentityHeader(),
        const SizedBox(height: 8),
        for (final Course course in favorites)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _DemoCourseCard(
              course: course,
              isFavorite: true,
              onToggleFavorite: () =>
                  context.read<CourseProvider>().toggleFavorite(course.code),
            ),
          ),
      ],
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const IdentityHeader(),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.amber),
            title: Text(
              '${context.watch<CourseProvider>().favoriteCount} favorit',
            ),
            subtitle: const Text(
              'Satu CourseProvider = satu source of truth; list, detail, '
              'dan tab ini selalu konsisten.',
            ),
          ),
        ),
      ],
    );
  }
}

/// Kartu course khusus demo: menerima model baru dari lib/models sehingga
/// tidak bentrok dengan CourseCard lama (yang masih memakai lib/data).
class _DemoCourseCard extends StatelessWidget {
  const _DemoCourseCard({
    required this.course,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.onTap,
  });

  final Course course;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: <Widget>[
              Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite
                    ? Colors.amber.shade700
                    : Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${course.code} - ${course.title}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: onToggleFavorite,
                icon: const Icon(Icons.swap_horiz),
                tooltip: 'Toggle favorite',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

