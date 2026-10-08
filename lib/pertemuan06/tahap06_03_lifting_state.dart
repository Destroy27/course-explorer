import 'package:flutter/material.dart';

import '../widgets/identity_header.dart';

/// Tahap 3 Pertemuan 6: lifting state up dan single source of truth.
///
/// Dua widget (_CounterA dan _CounterB) TIDAK menyimpan state sendiri.
/// Keduanya menerima nilai lewat constructor dan mengirim aksi lewat
/// callback. State tinggal di parent (_LiftingDemoState), sehingga A dan B
/// selalu menampilkan nilai yang sama — single source of truth.
void main() => runApp(const Tahap06Stage3App());

class Tahap06Stage3App extends StatelessWidget {
  const Tahap06Stage3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 3 - Lifting State Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _LiftingDemo(),
    );
  }
}

class _LiftingDemo extends StatefulWidget {
  const _LiftingDemo();

  @override
  State<_LiftingDemo> createState() => _LiftingDemoState();
}

class _LiftingDemoState extends State<_LiftingDemo> {
  // Single source of truth: satu-satunya pemilik nilai favorit.
  int _favoriteCount = 1;

  void _increment() => setState(() => _favoriteCount++);
  void _decrement() => setState(() => _favoriteCount--);
  void _reset() => setState(() => _favoriteCount = 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3 - Lifting State Up')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const IdentityHeader(),
          const SizedBox(height: 16),
          Text(
            'State tinggal di parent. Kedua kartu membaca data yang sama '
            'dan mengirim aksi lewat callback (bukan menyimpan salinan).',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _CounterCard(
            title: 'Counter A (Home)',
            value: _favoriteCount,
            onIncrement: _increment,
            onDecrement: _decrement,
          ),
          const SizedBox(height: 8),
          _CounterCard(
            title: 'Counter B (Detail)',
            value: _favoriteCount,
            onIncrement: _increment,
            onDecrement: _decrement,
          ),
          const SizedBox(height: 8),
          Text(
            'Ubah lewat A → B ikut berubah, karena keduanya membaca sumber '
            'yang sama. Tidak ada salinan yang bisa tidak sinkron.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: _reset,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reset ke 1'),
          ),
        ],
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.title,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String title;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    '$value course favorit',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle_outline),
              tooltip: 'Kurangi',
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Tambah',
            ),
          ],
        ),
      ),
    );
  }
}