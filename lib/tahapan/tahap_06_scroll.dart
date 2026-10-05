import 'package:flutter/material.dart';

import '../core/student_identity.dart';

/// Tahap 6: SingleChildScrollView dan perilaku keyboard.
///
/// Tombol di bawah menyalakan atau mematikan SingleChildScrollView
/// sehingga overflow dapat diamati secara langsung.
void main() => runApp(const Tahap6App());

class Tahap6App extends StatelessWidget {
  const Tahap6App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tahap 6 - Scrollable Content')),
        body: const _ProfileBody(),
      ),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  bool _useScrollView = true;

  @override
  Widget build(BuildContext context) {
    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Identitas: $identityLine',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'Form di bawah dibuat lebih tinggi dari layar. '
          'Tanpa SingleChildScrollView, bagian bawah tidak dapat dijangkau.',
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Catatan',
            hintText: 'Buka keyboard untuk menguji area bawah',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        ...List<Widget>.generate(
          6,
          (int index) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('Bagian ${index + 1}'),
              subtitle: Text(
                'Konten tambahan untuk memaksa halaman menjadi panjang. '
                'Bagian ${index + 1} dari 6.',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Form tersimpan - $identityLine'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Text('Simpan'),
        ),
      ],
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Gunakan SingleChildScrollView'),
              subtitle: const Text('Matikan untuk melihat overflow'),
              value: _useScrollView,
              onChanged: (bool value) {
                setState(() => _useScrollView = value);
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: _useScrollView
                  ? SingleChildScrollView(child: content)
                  : content,
            ),
          ],
        ),
      ),
    );
  }
}