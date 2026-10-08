# Tahap 1 — Analisis Local State dan Shared State

Nama: Gede Pasek Ary Sugiantara
NIM: 2415051074

## Identifikasi state pada Course Explorer

| # | State | Lokasi kode | Jenis | Alasan |
| --- | --- | --- | --- | --- |
| 1 | `_future` (data course) | `lib/main.dart:56` | Shared | Dipakai Home, Courses, dan Profile sekaligus |
| 2 | `_favoriteCodes` (set favorit) | `lib/main.dart:58` | Shared | Dibutuhkan list, detail, dan halaman favorit |
| 3 | `_currentIndex` (tab aktif) | `lib/main.dart:59` | Local | Hanya AppShell yang memakai untuk ganti halaman |
| 4 | `_isFavorite` di detail | `lib/screens/course_detail_page.dart:22` | Local | Hanya icon di halaman detail; merupakan salinan state shared |
| 5 | `_isSending` di form | `lib/widgets/feedback_form.dart:26` | Local | Hanya status tombol saat form dikirim |
| 6 | Isi `TextEditingController` | `lib/widgets/feedback_form.dart:24` | Local/ephemeral | Input sementara, hilang saat screen ditutup |
| 7 | Kategori breakpoint layout | `lib/core/breakpoint.dart` | Derived | Bukan state tersimpan; nilai turunan dari MediaQuery |

## Contoh local state dengan setState()

Pada `course_detail_page.dart`:

```dart
late bool _isFavorite = widget.isFavorite;

IconButton(
  onPressed: () => setState(() => _isFavorite = !_isFavorite),
  icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
)
```

## Pertanyaan: Mengapa tidak semua state perlu dikelola Provider?

Provider dipakai untuk state yang menjadi sumber kebenaran bersama lintas
widget/screen. State lokal seperti `_isSending` atau isi form hanya bermakna
bagi satu widget — `setState()` sudah cukup, lebih sederhana, tidak menambah
boilerplate class `ChangeNotifier`, dan tidak memicu rebuild pada widget lain
yang tidak peduli dengan state tersebut.
