import 'package:flutter/material.dart';

import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';

/// Tahap 5: ChangeNotifier dan notifyListeners().
///
/// CourseProvider menampung state favorit; UI mendengarkan lewat
/// ListenableBuilder. Ubah state tanpa notifyListeners() maka UI tidak
/// pernah tahu (dibuktikan pada Tahap 15 Kasus A).
void main() => runApp(const Tahap06Stage5App());

class Tahap06Stage5App extends StatelessWidget {
  const Tahap06Stage5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 5 - ChangeNotifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _ChangeNotifierDemo(),
    );
  }
}

class _ChangeNotifierDemo extends StatefulWidget {
  const _ChangeNotifierDemo();

  @override
  State<_ChangeNotifierDemo> createState() => _ChangeNotifierDemoState();
}

class _ChangeNotifierDemoState extends State<_ChangeNotifierDemo> {
  // Object state + method perubahan berada di class terpisah.
  final CourseProvider _provider = CourseProvider();

  static const List<String> _demoCourses = <String>[
    'MOB04 - Responsive Layout',
    'MOB05 - State Management',
    'MOB06 - Mobile Service dan API',
  ];

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 5 - ChangeNotifier')),
      body: ListenableBuilder(
        listenable: _provider,
        builder: (BuildContext context, Widget? child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const IdentityHeader(),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.amber.shade700,
                  ),
                  title: Text('${_provider.favoriteCount} course favorit'),
                  subtitle: const Text(
                    'Dibaca dari CourseProvider (ChangeNotifier) — '
                    'setiap toggle memanggil notifyListeners().',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final String course in _demoCourses)
                Card(
                  child: ListTile(
                    leading: Icon(
                      _provider.isFavorite(course)
                          ? Icons.star
                          : Icons.star_border,
                      color: _provider.isFavorite(course)
                          ? Colors.amber.shade700
                          : Theme.of(context).colorScheme.outline,
                    ),
                    title: Text(course),
                    trailing: IconButton(
                      onPressed: () => _provider.toggleFavorite(course),
                      icon: const Icon(Icons.swap_horiz),
                      tooltip: 'Toggle favorite',
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'State diubah lewat method toggleFavorite() pada class '
                'CourseProvider, bukan lewat constructor widget.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}