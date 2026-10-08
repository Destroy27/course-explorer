import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/course.dart';
import '../widgets/identity_header.dart';

/// Tahap 8: model Course dan parsing JSON.
///
/// Data mentah berupa `Map<String, dynamic>` diubah menjadi object Course
/// melalui factory Course.fromJson — parsing terpusat, tipe jelas, dan UI
/// tidak lagi menyentuh key string ("code", "title", dst.).
void main() => runApp(const Tahap06Stage8App());

class Tahap06Stage8App extends StatelessWidget {
  const Tahap06Stage8App({super.key});

  @override
  Widget build(BuildContext context) {
    // Data JSON mentah (contoh satu course dari course_data.json).
    const String rawJson = '''
    {
      "code": "MOB05",
      "title": "State Management",
      "credits": 3,
      "status": "planned",
      "category": "Framework",
      "semester": "4",
      "description": "Pengelolaan state aplikasi: setState, provider, arsitektur.",
      "skills": ["State", "Provider", "ChangeNotifier"]
    }
    ''';

    final Map<String, dynamic> map =
        jsonDecode(rawJson) as Map<String, dynamic>;
    final Course course = Course.fromJson(map);

    return MaterialApp(
      title: 'Tahap 8 - Model Course',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Tahap 8 - Model Course')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const IdentityHeader(),
            const SizedBox(height: 16),
            const Text(
              'Sebelum: Map<String, dynamic>\n'
              '  json[\'code\'], json[\'credits\'] as int, ...',
              style: TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sesudah: object Course dari Course.fromJson(json)',
              style: TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      course.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text('Kode      : ${course.code}'),
                    Text('SKS       : ${course.credits}'),
                    Text('Status    : ${course.statusLabel}'),
                    Text('Kategori  : ${course.category}'),
                    Text('Semester  : ${course.semester}'),
                    const SizedBox(height: 8),
                    Text('Skills    : ${course.skills.join(', ')}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Field diakses dengan tipe aman (course.credits adalah int, '
              'bukan as int di UI).',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}