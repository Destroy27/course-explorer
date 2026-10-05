import 'package:flutter/material.dart';

import '../core/student_identity.dart';

/// Tahap 7: Navigator.push() dan Navigator.pop().
void main() => runApp(const Tahap7App());

class Tahap7App extends StatelessWidget {
  const Tahap7App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 7 - Navigation')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                identityLine,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  // push menambahkan screen baru di atas stack.
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const _DetailPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Buka Detail'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Screen ini dibuat dengan Navigator.push. Tombol back bawaan '
              'AppBar memanggil Navigator.pop secara otomatis.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              identityLine,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali dengan pop()'),
            ),
          ],
        ),
      ),
    );
  }
}