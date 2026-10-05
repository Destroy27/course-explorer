import 'package:flutter/material.dart';

import '../core/student_identity.dart';

/// Tahap 1: masalah layout yang tidak responsif.
///
/// Bandingkan `width: 500` (hard-coded) dengan `double.infinity`.
/// Ubah ukuran jendela atau putar emulator untuk melihat perbedaan.
void main() => runApp(const Tahap1App());

class Tahap1App extends StatelessWidget {
  const Tahap1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tahap 1 - Hard-coded vs Flexible')),
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
                  'A. Width tetap 500. Pada layar sempit terjadi overflow, '
                  'pada layar lebar muncul ruang kosong di kanan.',
                ),
                const SizedBox(height: 8),
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepOrange),
                  ),
                  child: Text('$identityLine - layout hard-coded'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'B. Width double.infinity. Mengisi ruang yang tersedia tanpa '
                  'overflow dan tanpa ruang kosong berlebih.',
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Text('$identityLine - layout fleksibel'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'C. Row dengan Expanded 2:1 membagi ruang sesuai flex, '
                  'berbeda dari Container(width: 500).',
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Panel A (flex 2)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Panel B'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}