import 'package:flutter/material.dart';

import '../core/student_identity.dart';
import '../widgets/feedback_form.dart';
import '../widgets/identity_header.dart';

/// Tahap 13: form input dengan validasi.
void main() => runApp(const Tahap13App());

class Tahap13App extends StatelessWidget {
  const Tahap13App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tahap 13 - Form dan Validasi')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const IdentityHeader(),
                const SizedBox(height: 8),
                Text(
                  'Kosongkan kolom komentar lalu tekan Kirim untuk melihat '
                  'pesan validasi. Nama dan NIM sudah terisi otomatis dari '
                  'konstanta identitas ($identityLine).',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: FeedbackForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}