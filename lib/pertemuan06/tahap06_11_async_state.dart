import 'package:flutter/material.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../repositories/course_repository.dart';
import '../services/course_service.dart';
import '../widgets/identity_header.dart';

/// Tahap 11: Provider untuk async state (loading / error / data).
///
/// Dua provider didemokan: satu dengan service normal (sukses) dan satu dengan
/// path asset yang salah (error). Keduanya menampilkan loading saat memuat,
/// lalu berubah menjadi daftar atau pesan error + tombol coba lagi.
void main() => runApp(const Tahap06Stage11App());

class Tahap06Stage11App extends StatelessWidget {
  const Tahap06Stage11App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 11 - Async State',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _AsyncStateDemo(),
    );
  }
}

class _AsyncStateDemo extends StatefulWidget {
  const _AsyncStateDemo();

  @override
  State<_AsyncStateDemo> createState() => _AsyncStateDemoState();
}

class _AsyncStateDemoState extends State<_AsyncStateDemo> {
  late final CourseProvider _goodProvider;
  late final CourseProvider _badProvider;

  @override
  void initState() {
    super.initState();
    _goodProvider = CourseProvider(repository: const CourseRepository())
      ..loadCourses();
    // Service sengaja menunjuk path yang tidak ada -> error state.
    _badProvider = CourseProvider(
      repository: CourseRepository(
        service: const CourseService(
          assetPath: 'assets/data/tidak_ada.json',
        ),
      ),
    )..loadCourses();
  }

  @override
  void dispose() {
    _goodProvider.dispose();
    _badProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 11 - Async State')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const IdentityHeader(),
          const SizedBox(height: 16),
          Text(
            'Dua CourseProvider: kiri normal (success), kanan sengaja '
            'salah path (error). Keduanya punya state loading → data/error.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          _StateCard(
            title: 'Success (service normal)',
            provider: _goodProvider,
            onReload: _goodProvider.loadCourses,
          ),
          const SizedBox(height: 12),
          _StateCard(
            title: 'Error (path salah)',
            provider: _badProvider,
            onReload: _badProvider.loadCourses,
          ),
        ],
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.title,
    required this.provider,
    required this.onReload,
  });

  final String title;
  final CourseProvider provider;
  final Future<void> Function() onReload;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: provider,
      builder: (BuildContext context, Widget? child) {
        Widget body;
        if (provider.isLoading) {
          body = const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 12),
                Text('Memuat data...'),
              ],
            ),
          );
        } else if (provider.error != null) {
          body = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(height: 4),
              Text(
                provider.error!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: onReload,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          );
        } else {
          body = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${provider.courses.length} course berhasil dimuat.'),
              for (final Course course in provider.courses.take(3))
                Text('• ${course.code} - ${course.title}'),
            ],
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                body,
              ],
            ),
          ),
        );
      },
    );
  }
}