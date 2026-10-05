import 'package:flutter/material.dart';

import '../core/student_identity.dart';

/// Tahap 4: Expanded, Flexible, dan Wrap.
void main() => runApp(const Tahap4App());

const List<String> skills = <String>[
  'MediaQuery',
  'LayoutBuilder',
  'Expanded',
  'Flexible',
  'Wrap',
  'GridView',
  'SingleChildScrollView',
  'Navigator.push',
  'Navigator.pop',
  'NavigationRail',
];

class Tahap4App extends StatelessWidget {
  const Tahap4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tahap 4 - Expanded, Flexible, Wrap')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Identitas: $identityLine',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                const Text(
                  '1. Row dengan Expanded(flex: 2) dan Expanded(flex: 1). '
                  'Ruas berubah mengikuti lebar layar.',
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: _box('Panel A (flex 2)', Colors.indigo),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: _box('Panel B (flex 1)', Colors.indigo)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '2. Row dengan Flexible. Flexible tidak wajib mengisi '
                  'seluruh sisa ruang, sehingga Panel B tidak melebar penuh.',
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: _box('Panel A (flex 2)', Colors.teal),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: _box('Panel B (Flexible)', Colors.teal),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '3. Wrap untuk Chip. Item pindah ke baris berikutnya '
                  'ketika ruang tidak cukup.',
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills
                      .map((String e) => Chip(label: Text(e)))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Jumlah skill: ${skills.length}. Pada Row biasa, '
                  '${skills.length} chip tidak muat satu baris dan memicu overflow.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _box(String label, MaterialColor color) {
    return Container(
      height: 96,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}