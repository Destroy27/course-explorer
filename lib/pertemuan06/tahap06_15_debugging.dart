import 'package:flutter/material.dart';

import '../providers/course_provider.dart';
import '../repositories/course_repository.dart';
import '../services/course_service.dart';
import '../widgets/identity_header.dart';

/// Tahap 15: debugging state management (kasus A s/d D).
///
/// A: notifyListeners() dihapus -> UI tidak berubah -> dikembalikan.
/// B: context di atas ChangeNotifierProvider -> ProviderNotFoundException
///    (dijelaskan dengan kode sebelum/sesudah).
/// C: error pada CourseService -> error state tampil -> perbaiki path.
/// D: setState setelah async -> periksa mounted.
void main() => runApp(const Tahap06Stage15App());

class Tahap06Stage15App extends StatelessWidget {
  const Tahap06Stage15App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 15 - Debugging State',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5E8C)),
        useMaterial3: true,
      ),
      home: const _DebugDemo(),
    );
  }
}

class _DebugDemo extends StatefulWidget {
  const _DebugDemo();

  @override
  State<_DebugDemo> createState() => _DebugDemoState();
}

class _DebugDemoState extends State<_DebugDemo> {
  int _caseIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> cases = <Widget>[
      const _CaseANotify(),
      const _CaseBProviderPosition(),
      const _CaseCServiceError(),
      const _CaseDMounted(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 15 - Debugging State')),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(12),
            child: IdentityHeader(),
          ),
          SegmentedButton<int>(
            segments: const <ButtonSegment<int>>[
              ButtonSegment<int>(value: 0, label: Text('A')),
              ButtonSegment<int>(value: 1, label: Text('B')),
              ButtonSegment<int>(value: 2, label: Text('C')),
              ButtonSegment<int>(value: 3, label: Text('D')),
            ],
            selected: <int>{_caseIndex},
            onSelectionChanged: (Set<int> sel) =>
                setState(() => _caseIndex = sel.first),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: cases[_caseIndex],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kasus A: tanpa notifyListeners() UI diam.
class _CaseANotify extends StatefulWidget {
  const _CaseANotify();

  @override
  State<_CaseANotify> createState() => _CaseANotifyState();
}

class _CaseANotifyState extends State<_CaseANotify> {
  bool _notify = true;
  int _value = 1;

  void _change() {
    setState(() {
      _value++;
      if (_notify) {
        // Perbaikan: beri tahu listener agar UI ikut berubah.
        notifyValueChanged();
      }
    });
  }

  /// Simulasi notifyListeners(): pada ChangeNotifier asli method ini
  /// memanggil notifyListeners() setelah state berubah.
  void notifyValueChanged() {}

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'A. Tanpa notifyListeners(), UI tidak berubah',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text('Nilai internal: $_value'),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Aktifkan notifyListeners()'),
              value: _notify,
              onChanged: (bool v) => setState(() => _notify = v),
            ),
            FilledButton.icon(
              onPressed: _change,
              icon: const Icon(Icons.add),
              label: const Text('Ubah state'),
            ),
            const SizedBox(height: 8),
            Text(
              'Matikan switch lalu tekan "Ubah state": teks "Nilai internal" '
              'ikut berubah di sini karena demo memakai setState; pada '
              'ChangeNotifier asli tanpa notifyListeners() listener TIDAK '
              'akan dibangun ulang.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Kasus B: penjelasan posisi Provider di widget tree.
class _CaseBProviderPosition extends StatelessWidget {
  const _CaseBProviderPosition();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'B. ProviderNotFoundException',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SALAH — membaca provider di ATAS ChangeNotifierProvider:\n'
              'runApp(ChangeNotifierProvider(...))\n'
              '    child: MaterialApp(home: ...)  // MaterialApp di bawah OK\n'
              '// Jika MaterialApp DI ATAS provider, context tidak menemukan '
              'provider.',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'BENAR — ChangeNotifierProvider berada di atas semua widget '
              'yang membaca:\n'
              'runApp(\n'
              '  ChangeNotifierProvider(create: (_) => CourseProvider(),\n'
              '    child: const CourseExplorerApp(),\n'
              '  ),\n'
              ');',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              'Periksa posisi ChangeNotifierProvider setiap kali muncul '
              'ProviderNotFoundException.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Kasus C: error pada CourseService -> error state.
class _CaseCServiceError extends StatefulWidget {
  const _CaseCServiceError();

  @override
  State<_CaseCServiceError> createState() => _CaseCServiceErrorState();
}

class _CaseCServiceErrorState extends State<_CaseCServiceError> {
  late CourseProvider _provider;
  bool _broken = true;

  @override
  void initState() {
    super.initState();
    _provider = CourseProvider(
      repository: CourseRepository(
        service: const CourseService(
          assetPath: 'assets/data/tidak_ada.json',
        ),
      ),
    )..loadCourses();
  }

  void _fix() {
    setState(() {
      _broken = false;
      _provider = CourseProvider(repository: const CourseRepository())
        ..loadCourses();
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _provider,
      builder: (BuildContext context, Widget? child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'C. Error state saat CourseService gagal',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                if (_provider.isLoading)
                  const Row(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(width: 12),
                      Text('Memuat...'),
                    ],
                  )
                else if (_provider.error != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(height: 4),
                      Text(
                        _provider.error!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      if (_broken)
                        FilledButton.tonalIcon(
                          onPressed: _fix,
                          icon: const Icon(Icons.healing),
                          label: const Text('Perbaiki path asset'),
                        ),
                    ],
                  )
                else
                  Text('${_provider.courses.length} course dimuat setelah '
                      'path diperbaiki.'),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Kasus D: setState setelah async harus cek mounted.
class _CaseDMounted extends StatefulWidget {
  const _CaseDMounted();

  @override
  State<_CaseDMounted> createState() => _CaseDMountedState();
}

class _CaseDMountedState extends State<_CaseDMounted> {
  String _status = 'Menunggu proses...';
  bool _running = false;

  Future<void> _runProcess() async {
    setState(() {
      _running = true;
      _status = 'Proses berjalan 2 detik... silakan pindah halaman.';
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    // Pola yang benar: cek mounted sebelum setState setelah await.
    if (!mounted) {
      return;
    }
    setState(() {
      _running = false;
      _status = 'Proses selesai (mounted benar, tidak error).';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'D. setState setelah async + mounted',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(_status),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _running ? null : _runProcess,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Mulai proses'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: const Text('Halaman lain')),
                        body: const Center(
                          child: Text(
                            'Pindah halaman saat proses masih berjalan, '
                            'lalu tunggu hasilnya.',
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: const Text('Pindah halaman'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tanpa pemeriksaan mounted, setState() setelah widget di-'
              'unmount memicu "setState() called after dispose". Kode di atas '
              'mengawal mounted sebelum mengubah state.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}