import 'package:flutter/material.dart';

import '../widgets/identity_header.dart';

/// Tahap 4 Pertemuan 6: ValueNotifier dan ValueListenableBuilder.
///
/// Satu nilai (jumlah favorit) dipantau tanpa setState() di parent.
/// ValueNotifier memberi tahu listener; hanya widget di dalam
/// ValueListenableBuilder yang membangun ulang.
void main() => runApp(const Tahap06Stage4App());

class Tahap06Stage4App extends StatelessWidget {
  const Tahap06Stage4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 4 - ValueNotifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _ValueNotifierDemo(),
    );
  }
}

class _ValueNotifierDemo extends StatefulWidget {
  const _ValueNotifierDemo();

  @override
  State<_ValueNotifierDemo> createState() => _ValueNotifierDemoState();
}

class _ValueNotifierDemoState extends State<_ValueNotifierDemo> {
  // Jembatan menuju pola listener: satu nilai sederhana yang dapat dipantau.
  final ValueNotifier<int> _favoriteCount = ValueNotifier<int>(1);

  @override
  void dispose() {
    // ValueNotifier wajib dibuang agar tidak bocor (memory leak).
    _favoriteCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4 - ValueNotifier')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const IdentityHeader(),
          const SizedBox(height: 16),
          // Hanya bagian ini yang "mendengarkan" dan ikut rebuild.
          ValueListenableBuilder<int>(
            valueListenable: _favoriteCount,
            builder: (BuildContext context, int value, Widget? child) {
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.star,
                    color: Colors.amber.shade700,
                  ),
                  title: Text('$value course favorit'),
                  subtitle: Text(
                    'Nilai dibaca langsung dari ValueNotifier, '
                    'tanpa setState() di parent.',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _favoriteCount.value++,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah (+1)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _favoriteCount.value--,
                  icon: const Icon(Icons.remove),
                  label: const Text('Kurangi (-1)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Perbandingan dengan setState(): di sini parent TIDAK perlu '
            'stateful rebuild — hanya anak yang memakai '
            'ValueListenableBuilder yang berubah.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}