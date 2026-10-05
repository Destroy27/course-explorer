import 'package:flutter/material.dart';

import '../core/breakpoint.dart';

/// Kerangka aplikasi yang memilih navigasi sesuai lebar layar.
///
/// Pada compact dan medium memakai NavigationBar di bawah.
/// Pada expanded memakai NavigationRail di samping.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.pages,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<Widget> pages;

  static const List<_Destination> _destinations = <_Destination>[
    _Destination(icon: Icons.home_outlined, selected: Icons.home, label: 'Home'),
    _Destination(
      icon: Icons.school_outlined,
      selected: Icons.school,
      label: 'Courses',
    ),
    _Destination(
      icon: Icons.person_outline,
      selected: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final LayoutCategory category = layoutCategoryOf(constraints.maxWidth);
        final Widget content = pages[currentIndex];

        if (category == LayoutCategory.expanded) {
          return Scaffold(
            body: Row(
              children: <Widget>[
                _rail(category),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: content),
              ],
            ),
          );
        }

        return Scaffold(
          body: content,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: _destinations
                .map(
                  (_Destination d) => NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selected),
                    label: d.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget _rail(LayoutCategory category) {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: category == LayoutCategory.expanded
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,
      destinations: _destinations
          .map(
            (_Destination d) => NavigationRailDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selected),
              label: Text(d.label),
            ),
          )
          .toList(),
    );
  }
}

class _Destination {
  const _Destination({
    required this.icon,
    required this.selected,
    required this.label,
  });

  final IconData icon;
  final IconData selected;
  final String label;
}