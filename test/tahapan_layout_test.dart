// Uji sapuan layout untuk seluruh entry point per tahap.
//
// Setiap aplikasi per tahap dijalankan pada beberapa lebar nyata (ponsel
// kecil, ponsel, tablet, dan layar lebar) untuk memastikan tidak ada
// overflow pada compact maupun expanded.

import 'package:course_explorer/tahapan/tahap_01_hardcoded.dart';
import 'package:course_explorer/tahapan/tahap_02_mediaquery.dart';
import 'package:course_explorer/tahapan/tahap_03_layoutbuilder.dart';
import 'package:course_explorer/tahapan/tahap_04_expanded_wrap.dart';
import 'package:course_explorer/tahapan/tahap_05_gridview.dart';
import 'package:course_explorer/tahapan/tahap_06_scroll.dart';
import 'package:course_explorer/tahapan/tahap_07_navigation.dart';
import 'package:course_explorer/tahapan/tahap_08_passing_data.dart';
import 'package:course_explorer/tahapan/tahap_09_returning_data.dart';
import 'package:course_explorer/tahapan/tahap_10_navigationbar.dart';
import 'package:course_explorer/tahapan/tahap_11_adaptive_nav.dart';
import 'package:course_explorer/tahapan/tahap_12_interaction.dart';
import 'package:course_explorer/tahapan/tahap_13_form.dart';
import 'package:course_explorer/tahapan/tahap_14_feedback.dart';
import 'package:course_explorer/tahapan/tahap_15_integrasi.dart';
import 'package:course_explorer/tahapan/tahap_16_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Lebar logis dan device pixel ratio untuk tiap kategori layar.
const List<(Size, double)> _targets = <(Size, double)>[
  (Size(320, 640), 2), // ponsel kecil, compact
  (Size(360, 800), 3), // ponsel, compact
  (Size(640, 900), 2), // tablet, medium
  (Size(2560, 1440), 1), // laptop, expanded
];

List<Widget> _apps() => <Widget>[
      const Tahap1App(),
      const Tahap2App(),
      const Tahap3App(),
      const Tahap4App(),
      const Tahap5App(),
      const Tahap6App(),
      const Tahap7App(),
      const Tahap8App(),
      const Tahap9App(),
      const Tahap10App(),
      const Tahap11App(),
      const Tahap12App(),
      const Tahap13App(),
      const Tahap14App(),

      // Tahap 15 memakai aplikasi utama dengan data yang disuntikkan agar
      // sapuan layout tidak bergantung pada pembacaan asset.
      Tahap15App(courseLoader: loadDemoCourses),
      const Tahap16App(),
    ];

void main() {
  for (final Widget app in _apps()) {
    for (final (Size logical, double ratio) in _targets) {
      testWidgets(
          'Tanpa error layout: ${app.runtimeType} '
          'lebar ${logical.width.toInt()} px', (WidgetTester tester) async {
        tester.view.devicePixelRatio = ratio;
        tester.view.physicalSize = Size(
          logical.width * ratio,
          logical.height * ratio,
        );
        addTearDown(tester.view.reset);

        // Menangkap pesan error layout yang dilaporkan Flutter.
        final List<String> layoutErrors = <String>[];
        final void Function(FlutterErrorDetails)? previousHandler =
            FlutterError.onError;
        FlutterError.onError = (FlutterErrorDetails details) {
          layoutErrors.add(details.toString());
        };

        await tester.pumpWidget(app);
        for (int frame = 0; frame < 25; frame++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // Handler dikembalikan sebelum expect agar assertion tetap terbaca.
        FlutterError.onError = previousHandler;

        expect(
          layoutErrors,
          isEmpty,
          reason: 'Terdapat error layout pada ${app.runtimeType} '
              'lebar ${logical.width.toInt()} px: '
              '${layoutErrors.isEmpty ? '' : layoutErrors.first}',
        );
      });
    }
  }
}