import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../widgets/app_shell.dart';
import '../widgets/identity_header.dart';

/// Tahap 10: NavigationBar sebagai navigasi utama tiga destination.
void main() => runApp(const Tahap10App());

class Tahap10App extends StatelessWidget {
  const Tahap10App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _NavigationDemo(),
    );
  }
}

class _NavigationDemo extends StatefulWidget {
  const _NavigationDemo();

  @override
  State<_NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<_NavigationDemo> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Pola adaptif lengkap ada di lib/widgets/app_shell.dart.
    // Pada lebar expanded, AppShell otomatis memakai NavigationRail.
    return AppShell(
      currentIndex: _currentIndex,
      onDestinationSelected: (int index) {
        setState(() => _currentIndex = index);
      },
      pages: const <Widget>[
        _Page(
          title: 'Home',
          body: 'Beranda Course Explorer. Index aktif: 0.',
        ),
        _Page(
          title: 'Courses',
          body: 'Daftar course. Index aktif: 1.',
        ),
        _Page(
          title: 'Profile',
          body: 'Profil mahasiswa. Index aktif: 2.',
        ),
      ],
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const IdentityHeader(dense: true),
            const SizedBox(height: 16),
            Text(body, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final LayoutCategory category =
                    layoutCategoryOf(constraints.maxWidth);
                return Text(
                  'Lebar ${constraints.maxWidth.toStringAsFixed(0)} px '
                  'dikategorikan ${category.label}.',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}