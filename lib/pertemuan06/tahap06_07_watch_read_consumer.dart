import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';

/// Tahap 7: context.watch(), context.read(), dan Consumer.
///
/// - watch(): mendengarkan dan memicu rebuild (teks jumlah favorit).
/// - read(): mengambil object tanpa listen, cocok untuk aksi (tombol toggle).
/// - Consumer: membatasi rebuild pada area kecil (badge favorit).
///
/// Bukti visual: angka "Counter tetap" TIDAK berubah saat favorite di-toggle,
/// karena tidak memakai watch dan bukan bagian dari Consumer.
void main() {
  runApp(
    ChangeNotifierProvider<CourseProvider>(
      create: (_) => CourseProvider(),
      child: const Tahap06Stage7App(),
    ),
  );
}

class Tahap06Stage7App extends StatelessWidget {
  const Tahap06Stage7App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 7 - watch vs read vs Consumer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _WatchReadDemo(),
    );
  }
}

class _WatchReadDemo extends StatefulWidget {
  const _WatchReadDemo();

  @override
  State<_WatchReadDemo> createState() => _WatchReadDemoState();
}

class _WatchReadDemoState extends State<_WatchReadDemo> {
  // Nilai ini hanya berubah lewat tombolnya sendiri; toggle favorite TIDAK
  // menyentuhnya, membuktikan area rebuild ikut dibatasi.
  int _otherCounter = 0;

  static const List<String> _demoCourses = <String>[
    'MOB04 - Responsive Layout',
    'MOB05 - State Management',
    'MOB06 - Mobile Service dan API',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 7 - watch / read / Consumer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const IdentityHeader(),
          const SizedBox(height: 16),
          // 1. watch: ikut rebuild setiap kali state berubah.
          Card(
            child: ListTile(
              leading: const Icon(Icons.visibility),
              title: Text(
                '${context.watch<CourseProvider>().favoriteCount} favorit '
                '(watch)',
              ),
              subtitle: const Text('Rebuild setiap notifyListeners()'),
            ),
          ),
          const SizedBox(height: 8),
          // 2. Consumer: hanya badge ini yang rebuild saat jumlah berubah.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.center_focus_strong),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Badge (Consumer):')),
                  Consumer<CourseProvider>(
                    builder: (BuildContext context, CourseProvider p, _) {
                      return Badge(
                        label: Text('${p.favoriteCount}'),
                        child: const Icon(Icons.favorite, color: Colors.amber),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final String course in _demoCourses)
            Card(
              child: ListTile(
                title: Text(course),
                trailing: IconButton(
                  // 3. read: aksi tanpa listen, tidak memicu rebuild tombol.
                  onPressed: () =>
                      context.read<CourseProvider>().toggleFavorite(course),
                  icon: Icon(
                    context.watch<CourseProvider>().isFavorite(course)
                        ? Icons.star
                        : Icons.star_border,
                    color: context.watch<CourseProvider>().isFavorite(course)
                        ? Colors.amber.shade700
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.straighten),
              title: Text('Counter tetap: $_otherCounter'),
              subtitle: const Text(
                'Tidak pakai watch/Consumer → tidak ikut rebuild saat '
                'favorite ditoggle.',
              ),
              trailing: IconButton(
                onPressed: () => setState(() => _otherCounter++),
                icon: const Icon(Icons.add),
                tooltip: 'Naikkan counter tetap',
              ),
            ),
          ),
        ],
      ),
    );
  }
}