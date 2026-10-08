import 'package:flutter/material.dart';

import '../widgets/identity_header.dart';

/// Tahap 2 Pertemuan 6: keterbatasan setState() untuk shared state.
///
/// Demonstrasi prop drilling: state `favorites` dimiliki parent (single
/// source), lalu nilai dan callback diteruskan ke dua child melalui
/// constructor. Kode terlihat berulang: setiap child harus menerima
/// `isFavorite` dan `onToggleFavorite` secara eksplisit.
///
/// 2415051074 - Gede Pasek Ary Sugiantara
void main() => runApp(const Tahap06Stage2App());

class Tahap06Stage2App extends StatelessWidget {
  const Tahap06Stage2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 2 - Masalah setState',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _PropDrillingDemo(),
    );
  }
}

/// Pemilik state: favorites hanya boleh berubah di sini (lifting state up
/// akan dibahas di Tahap 3).
class _PropDrillingDemo extends StatefulWidget {
  const _PropDrillingDemo();

  @override
  State<_PropDrillingDemo> createState() => _PropDrillingDemoState();
}

class _PropDrillingDemoState extends State<_PropDrillingDemo> {
  final Set<String> _favorites = <String>{'MOB05'};

  void _toggle(String code) {
    setState(() {
      if (!_favorites.remove(code)) {
        _favorites.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 2 - Prop Drilling')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const IdentityHeader(),
          const SizedBox(height: 16),
          Text(
            'State favorit hidup di parent (_PropDrillingDemoState). '
            'Setiap child menerima nilai DAN callback melalui constructor '
            '— itulah prop drilling.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          // Prop drilling: nilai diteruskan lewat constructor.
          _FavoriteRow(
            label: 'MOB04 - Responsive Layout',
            isFavorite: _favorites.contains('MOB04'),
            onToggleFavorite: () => _toggle('MOB04'),
          ),
          const SizedBox(height: 8),
          _FavoriteRow(
            label: 'MOB05 - State Management',
            isFavorite: _favorites.contains('MOB05'),
            onToggleFavorite: () => _toggle('MOB05'),
          ),
          const SizedBox(height: 8),
          _FavoriteRow(
            label: 'MOB06 - Mobile Service dan API',
            isFavorite: _favorites.contains('MOB06'),
            onToggleFavorite: () => _toggle('MOB06'),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Kesimpulan: duplikasi parameter constructor di dua child '
                'mulai terasa. Semakin dalam pohon widget, semakin panjang '
                'rantai isFavorite/onToggleFavorite yang harus ditulis ulang.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Child widget. Ia TIDAK menyimpan state sendiri — hanya menerima nilai dan
/// callback dari parent. Perhatikan: dua parameter yang sama harus ditulis
/// ulang untuk setiap child (sumber duplikasi kode).
class _FavoriteRow extends StatelessWidget {
  const _FavoriteRow({
    required this.label,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final String label;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          color: isFavorite ? Colors.amber.shade700 : theme.colorScheme.outline,
        ),
        title: Text(label),
        subtitle: Text(isFavorite ? 'Sudah favorit' : 'Belum favorit'),
        trailing: IconButton(
          onPressed: onToggleFavorite,
          icon: const Icon(Icons.swap_horiz),
          tooltip: 'Toggle dari child ini',
        ),
      ),
    );
  }
}