import 'package:flutter/material.dart';

import '../data/course.dart';
import '../main.dart';

/// Tahap 15: integrasi mini project Course Explorer.
///
/// Entry point ini menjalankan aplikasi utama apa adanya, yaitu gabungan
/// responsive layout, navigation adaptif, passing data, interaction, form, dan
/// feedback seperti pada produk akhir. Perbedaannya dengan `lib/main.dart`
/// hanya terletak pada sumber data yang dapat disuntikkan.
void main() => runApp(const Tahap15App());

/// Aplikasi integrasi Course Explorer untuk tahap 15.
class Tahap15App extends StatelessWidget {
  const Tahap15App({super.key, this.courseLoader});

  /// Sumber data yang dapat diganti, dipakai oleh sapuan layout.
  ///
  /// Bila null, data dibaca dari `assets/data/course_data.json`.
  final Future<List<Course>> Function()? courseLoader;

  @override
  Widget build(BuildContext context) {
    return CourseExplorerApp(courseLoader: courseLoader);
  }
}

/// Data course contoh yang isinya sama dengan `assets/data/course_data.json`.
///
/// Dipakai widget test agar pembacaan asset tidak bergantung pada cache asset
/// yang terikat pada zona `fakeAsync` milik satu test.
Future<List<Course>> loadDemoCourses() async => const <Course>[
      Course(
        code: 'MOB01',
        title: 'Git dan GitHub',
        credits: 2,
        status: 'done',
        category: 'Tooling',
        semester: '1',
        description: 'Version control untuk pengembang: commit, branch, '
            'merge, dan alur kerja kolaboratif melalui GitHub.',
        skills: <String>['Git', 'GitHub', 'Commit', 'Branch', 'Pull Request'],
      ),
      Course(
        code: 'MOB02',
        title: 'Dart Fundamentals',
        credits: 2,
        status: 'done',
        category: 'Bahasa Pemrograman',
        semester: '1',
        description: 'Bahasa Dart sebagai dasar: variabel, collection, '
            'function, null safety, Future, async/await, dan exception '
            'handling.',
        skills: <String>['Dart', 'Collection', 'Null Safety', 'Async'],
      ),
      Course(
        code: 'MOB03',
        title: 'Flutter UI Fundamentals',
        credits: 3,
        status: 'done',
        category: 'Framework',
        semester: '2',
        description: 'Membangun antarmuka dari widget dasar, layout, widget '
            'tree, ListView.builder, sampai data JSON statis.',
        skills: <String>['Widget Tree', 'Layout', 'ListView', 'JSON'],
      ),
      Course(
        code: 'MOB04',
        title: 'Responsive Layout, Navigation, dan User Interaction',
        credits: 3,
        status: 'active',
        category: 'Framework',
        semester: '3',
        description: 'UI adaptif berbasis MediaQuery dan LayoutBuilder, '
            'navigasi multi-screen, passing data, form, serta feedback '
            'pengguna.',
        skills: <String>['MediaQuery', 'LayoutBuilder', 'Navigator', 'Form'],
      ),
      Course(
        code: 'MOB05',
        title: 'State Management',
        credits: 3,
        status: 'planned',
        category: 'Framework',
        semester: '4',
        description: 'Pengelolaan state aplikasi: setState, StatefulWidget, '
            'provider, dan pemisahan layer state pada aplikasi berskala lebih '
            'besar.',
        skills: <String>['State', 'Provider', 'ChangeNotifier'],
      ),
      Course(
        code: 'MOB06',
        title: 'Mobile Service dan API',
        credits: 2,
        status: 'planned',
        category: 'Backend',
        semester: '4',
        description: 'Konsumsi data dari service web menggunakan HTTP, '
            'jsonDecode, serta penanganan loading, error, dan cache lokal.',
        skills: <String>['HTTP', 'API', 'JSON', 'Async'],
      ),
    ];