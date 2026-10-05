import 'package:flutter/material.dart';

import '../core/student_identity.dart';

/// Tahap 14: SnackBar, Dialog, dan loading feedback.
void main() => runApp(const Tahap14App());

class Tahap14App extends StatelessWidget {
  const Tahap14App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _FeedbackDemo(),
    );
  }
}

class _FeedbackDemo extends StatefulWidget {
  const _FeedbackDemo();

  @override
  State<_FeedbackDemo> createState() => _FeedbackDemoState();
}

class _FeedbackDemoState extends State<_FeedbackDemo> {
  bool _isLoading = false;
  int _savedCount = 0;

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data berhasil disimpan - $identityLine'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmThenSave() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Lanjutkan proses penyimpanan?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await _simulateLoading();

    if (!mounted) {
      return;
    }

    setState(() => _savedCount++);
    _showSnackBar();
  }

  Future<void> _simulateLoading() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));

    // setState setelah dispose harus dicek melalui mounted.
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 14 - Feedback')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                identityLine,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (_isLoading) ...<Widget>[
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text(
                  'Mengirim data...',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
              ],
              Text(
                'Data tersimpan: $_savedCount kali',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _showSnackBar,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('SnackBar'),
                  ),
                  FilledButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final bool? result = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext dialogContext) =>
                                  AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text('Lanjutkan proses?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, false),
                                    child: const Text('Batal'),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, true),
                                    child: const Text('Lanjutkan'),
                                  ),
                                ],
                              ),
                            );
                            if (result == true && mounted) {
                              _showSnackBar();
                            }
                          },
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Dialog'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _confirmThenSave,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Dialog + Loading'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}