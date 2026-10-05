import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/student_identity.dart';
import '../widgets/identity_header.dart';

/// Tahap 11: adaptive navigation NavigationBar versus NavigationRail.
///
/// Ubah ukuran jendela atau emulator untuk berpindah antar pola navigasi.
void main() => runApp(const Tahap11App());

class Tahap11App extends StatelessWidget {
  const Tahap11App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _AdaptiveScaffold(),
    );
  }
}

class _AdaptiveScaffold extends StatefulWidget {
  const _AdaptiveScaffold();

  @override
  State<_AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<_AdaptiveScaffold> {
  int _currentIndex = 0;

  static const List<String> _labels = <String>[
    'Home',
    'Courses',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final LayoutCategory category = layoutCategoryOf(constraints.maxWidth);
        final Widget body = _PageBody(
          label: _labels[_currentIndex],
          category: category,
        );

        if (category == LayoutCategory.expanded) {
          return Scaffold(
            body: Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _currentIndex,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (int index) {
                    setState(() => _currentIndex = index);
                  },
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: body),
              ],
            ),
          );
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() => _currentIndex = index);
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: 'Courses',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({required this.label, required this.category});

  final String label;
  final LayoutCategory category;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const IdentityHeader(dense: true),
            const SizedBox(height: 16),
            Text(
              'Destination aktif: $label',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Layout ${category.label}. Navigasi '
              '${category == LayoutCategory.expanded ? 'NavigationRail' : 'NavigationBar'}.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Pindah destination lalu ubah ukuran jendela: index aktif tetap sama.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              identityLine,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}