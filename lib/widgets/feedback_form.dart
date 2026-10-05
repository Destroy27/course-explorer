import 'package:flutter/material.dart';

import '../core/student_identity.dart';

/// Form umpan balik dengan validasi.
///
/// Mengembalikan `true` melalui Navigator.pop ketika form valid dan dikirim.
class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key, this.onSubmitted});

  /// Callback yang dijalankan setelah data valid, tanpa menutup halaman.
  final VoidCallback? onSubmitted;

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController(text: studentName);
  final TextEditingController _nimController =
      TextEditingController(text: studentId);
  final TextEditingController _commentController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSending = true);

    // Simulasi proses kirim agar state loading terlihat pada screenshot.
    await Future<void>.delayed(const Duration(seconds: 1));

    // Widget bisa sudah tidak aktif bila pengguna menutup halaman.
    if (!mounted) {
      return;
    }

    setState(() => _isSending = false);

    final String name = _nameController.text.trim();
    final String nim = _nimController.text.trim();
    final String comment = _commentController.text.trim();

    widget.onSubmitted?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Umpan balik $nim - $name tersimpan ($comment)'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _commentController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama wajib diisi';
              }
              if (value.trim().length < 3) {
                return 'Nama minimal 3 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nimController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'NIM',
              prefixIcon: Icon(Icons.badge_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              final String input = value?.trim() ?? '';
              if (input.isEmpty) {
                return 'NIM wajib diisi';
              }
              if (input.length != 10) {
                return 'NIM harus 10 digit angka';
              }
              if (int.tryParse(input) == null) {
                return 'NIM hanya boleh berisi angka';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _commentController,
            maxLines: 4,
            minLines: 3,
            decoration: const InputDecoration(
              labelText: 'Komentar',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              final String input = value?.trim() ?? '';
              if (input.isEmpty) {
                return 'Komentar wajib diisi';
              }
              if (input.length < 5) {
                return 'Komentar minimal 5 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget sendButton = FilledButton.icon(
                onPressed: _isSending ? null : _submit,
                icon: _isSending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(_isSending ? 'Mengirim...' : 'Kirim Umpan Balik'),
              );

              final Widget resetButton = OutlinedButton(
                onPressed: _isSending
                    ? null
                    : () {
                        _formKey.currentState?.reset();
                        _commentController.clear();
                      },
                child: const Text('Reset'),
              );

              // Pada layar sempit kedua tombol ditumpuk agar tidak meluber.
              if (constraints.maxWidth < 420) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    sendButton,
                    const SizedBox(height: 12),
                    resetButton,
                  ],
                );
              }

              return Row(
                children: <Widget>[
                  sendButton,
                  const SizedBox(width: 12),
                  resetButton,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}