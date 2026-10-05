import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/student_identity.dart';
import '../widgets/identity_header.dart';

/// Tahap 3: LayoutBuilder dan breakpoint compact / medium / expanded.
void main() => runApp(const Tahap3App());

class Tahap3App extends StatelessWidget {
  const Tahap3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tahap 3 - LayoutBuilder')),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final LayoutCategory category =
                  layoutCategoryOf(constraints.maxWidth);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LayoutBadge(category: category),
                    const SizedBox(height: 12),
                    Text(
                      'Lebar tersedia: '
                      '${constraints.maxWidth.toStringAsFixed(0)} px',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    if (category == LayoutCategory.compact)
                      const _CompactLayout()
                    else if (category == LayoutCategory.medium)
                      const _MediumLayout()
                    else
                      const _ExpandedLayout(),
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

/// Layout compact: satu kolom.
class _CompactLayout extends StatelessWidget {
  const _CompactLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Panel(
          title: 'Compact (< 600)',
          color: Colors.amber,
          lines: const <String>[
            'Satu kolom.',
            'Navigasi bawah.',
            'Card satu per baris.',
          ],
        ),
        const SizedBox(height: 8),
        _Panel(
          title: identityLine,
          color: Colors.blueGrey,
          lines: const <String>['Identitas tetap terlihat pada semua layout.'],
        ),
      ],
    );
  }
}

/// Layout medium: dua kolom.
class _MediumLayout extends StatelessWidget {
  const _MediumLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _Panel(
                title: 'Kiri',
                color: Colors.lightBlue,
                lines: const <String>['Kolom kiri pada layout medium.'],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Panel(
                title: 'Kanan',
                color: Colors.lightBlue,
                lines: const <String>['Kolom kanan pada layout medium.'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _Panel(
          title: identityLine,
          color: Colors.blueGrey,
          lines: const <String>['Layout: Medium (600 - 839).'],
        ),
      ],
    );
  }
}

/// Layout expanded: tiga kolom dan panel samping.
class _ExpandedLayout extends StatelessWidget {
  const _ExpandedLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _Panel(
                title: 'Kolom 1',
                color: Colors.teal,
                lines: const <String>['Tiga kolom pada layout expanded.'],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Panel(
                title: 'Kolom 2',
                color: Colors.teal,
                lines: const <String>['Rail navigasi muncul di sisi.'],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Panel(
                title: 'Kolom 3',
                color: Colors.teal,
                lines: const <String>['Master-detail lebih nyaman.'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _Panel(
          title: identityLine,
          color: Colors.blueGrey,
          lines: const <String>['Layout: Expanded (>= 840).'],
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.color,
    required this.lines,
  });

  final String title;

  /// MaterialColor supaya bisa memakai shade100 untuk latar panel.
  final MaterialColor color;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          ...lines.map(
            (String line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(line),
            ),
          ),
        ],
      ),
    );
  }
}