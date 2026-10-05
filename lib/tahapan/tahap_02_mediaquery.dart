import 'package:flutter/material.dart';

import '../core/student_identity.dart';

/// Tahap 2: MediaQuery untuk membaca karakteristik layar.
///
/// Jalankan dalam portrait dan landscape untuk melihat perubahan nilai.
void main() => runApp(const Tahap2App());

class Tahap2App extends StatelessWidget {
  const Tahap2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tahap 2 - MediaQuery')),
        body: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              // MediaQuery membaca ukuran layar dan orientation.
              final Size size = MediaQuery.of(context).size;
              final Orientation orientation =
                  MediaQuery.of(context).orientation;
              final EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
              final bool isCompact = size.width < 600;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Identitas: $identityLine',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _Row(
                              label: 'Width',
                              value: size.width.toStringAsFixed(0),
                            ),
                            _Row(
                              label: 'Height',
                              value: size.height.toStringAsFixed(0),
                            ),
                            _Row(label: 'Orientation', value: '$orientation'),
                            _Row(
                              label: 'Mode',
                              value: isCompact ? 'Compact' : 'Wide',
                            ),
                            _Row(
                              label: 'View padding',
                              value:
                                  '${viewPadding.top.toStringAsFixed(0)} / '
                                  '${viewPadding.bottom.toStringAsFixed(0)}',
                            ),
                            _Row(
                              label: 'Device pixel ratio',
                              value: MediaQuery.of(context)
                                  .devicePixelRatio
                                  .toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isCompact
                          ? 'Lebar di bawah 600, tampilkan teks Compact.'
                          : 'Lebar 600 atau lebih, tampilkan teks Wide.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCompact
                            ? Colors.amber.shade100
                            : Colors.lightGreen.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$identityLine - ${isCompact ? 'Compact' : 'Wide'} '
                        '(lebar ${size.width.toStringAsFixed(0)} px)',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 160,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}