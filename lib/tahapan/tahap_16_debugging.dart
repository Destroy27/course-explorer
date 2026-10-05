import 'package:flutter/material.dart';

import '../core/student_identity.dart';

/// Tahap 16: debugging challenge.
///
/// Empat kasus yang lazim terjadi pada aplikasi mobile nyata:
/// A. RenderFlex overflow pada Row dengan teks panjang.
/// B. Vertical viewport was given unbounded height.
/// C. Keyboard menutupi tombol di bagian bawah.
/// D. Aksi navigasi terpicu berkali-kali.
void main() => runApp(const Tahap16App());

class Tahap16App extends StatelessWidget {
  const Tahap16App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _DebuggingDemo(),
    );
  }
}

class _DebuggingDemo extends StatefulWidget {
  const _DebuggingDemo();

  @override
  State<_DebuggingDemo> createState() => _DebuggingDemoState();
}

class _DebuggingDemoState extends State<_DebuggingDemo> {
  bool _useBrokenOverflow = false;
  bool _useBrokenListView = false;
  bool _guardNavigation = true;
  int _pushCount = 0;
  bool _isPushing = false;

  Future<void> _pushDetail() async {
    // Guard mencegah route ter-push berkali-kali.
    if (_isPushing) {
      return;
    }

    setState(() {
      _isPushing = true;
      _pushCount++;
    });

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const _SecondPage(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() => _isPushing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kembali dari push ke-$_pushCount - $identityLine'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tahap 16 - Debugging'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'A. Overflow'),
              Tab(text: 'B. Unbounded'),
              Tab(text: 'C. Keyboard'),
              Tab(text: 'D. Double push'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              _caseA(context),
              _caseB(context),
              _caseC(context),
              _caseD(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _caseA(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text(
          'Kasus A: Row dengan teks panjang',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Gunakan Row tanpa Expanded (bermasalah)'),
          subtitle: const Text('Aktifkan untuk melihat overflow'),
          value: _useBrokenOverflow,
          onChanged: (bool value) {
            setState(() => _useBrokenOverflow = value);
          },
        ),
        const SizedBox(height: 8),
        if (_useBrokenOverflow)
          Row(
            children: <Widget>[
              const Icon(Icons.info),
              const SizedBox(width: 8),
              Text(
                '$identityLine - teks sangat panjang yang membuat lebar Row '
                'melebihi batas layar sehingga terjadi RenderFlex overflow.',
              ),
            ],
          )
        else
          Row(
            children: <Widget>[
              const Icon(Icons.info),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$identityLine - teks sangat panjang yang membuat lebar Row '
                  'melebihi batas layar sehingga terjadi RenderFlex overflow.',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        Text(
          _useBrokenOverflow
              ? 'Solusi: bungkus Text dengan Expanded atau Flexible, atau '
                  'ubah Row menjadi Wrap.'
              : 'Expanded memberi batasan lebar pada Text sehingga teks '
                  'memotong dengan ellipsis dan tidak lagi meluber.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _caseB(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Kasus B: ListView di dalam Column tanpa batas tinggi',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Gunakan ListView tanpa Expanded (bermasalah)'),
            subtitle: const Text('Aktifkan untuk melihat error unbounded'),
            value: _useBrokenListView,
            onChanged: (bool value) {
              setState(() => _useBrokenListView = value);
            },
          ),
          const SizedBox(height: 8),
          Text(
            _useBrokenListView
                ? 'Error: Vertical viewport was given unbounded height.'
                : 'Solusi: bungkus ListView dengan Expanded atau '
                    'SizedBox dengan tinggi tetap.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: _useBrokenListView
                  ? Column(
                      children: <Widget>[
                        Text(identityLine),
                        ListView(
                          children: const <Widget>[
                            ListTile(title: Text('Item 1')),
                            ListTile(title: Text('Item 2')),
                            ListTile(title: Text('Item 3')),
                          ],
                        ),
                      ],
                    )
                  : ListView(
                      children: const <Widget>[
                        ListTile(title: Text('Item 1')),
                        ListTile(title: Text('Item 2')),
                        ListTile(title: Text('Item 3')),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _caseC(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Kasus C: keyboard menutupi tombol di bagian bawah',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Isi kolom di bawah lalu tekan tombol paling bawah. Karena '
            'halaman dapat di-scroll, tombol tetap dapat dijangkau meskipun '
            'keyboard menutup sebagian layar.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Catatan panjang',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 200),
          Card(
            child: ListTile(
              title: const Text('Kartu penanda posisi'),
              subtitle: Text(identityLine),
            ),
          ),
          const SizedBox(height: 200),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tombol bawah tetap bisa ditekan - '
                      '$identityLine'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Tombol Paling bawah'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _caseD(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Kasus D: navigasi ganda',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Jumlah route ter-push: $_pushCount. '
            'Status proses: ${_isPushing ? 'sedang berjalan' : 'selesai'}.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Aktifkan guard navigasi'),
            subtitle: const Text(
              'Saat guard aktif, tombol dinonaktifkan selama push berjalan',
            ),
            value: _guardNavigation,
            onChanged: (bool value) {
              setState(() => _guardNavigation = value);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              FilledButton.icon(
                onPressed: _guardNavigation && _isPushing
                    ? null
                    : _guardNavigation
                        ? _pushDetail
                        : () {
                            _pushCount++;
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const _SecondPage(),
                              ),
                            );
                          },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Push Detail'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => setState(() => _pushCount = 0),
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Solusi produksi: nonaktifkan tombol selama proses berjalan, '
            'gunakan flag boolean, atau debounce aksi agar tap ganda tidak '
            'menumpuk route.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SecondPage extends StatelessWidget {
  const _SecondPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Halaman kedua. $identityLine',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}