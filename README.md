# Course Explorer

Praktikum Pemrograman Mobile Pertemuan 5: Responsive Layout, Navigation, dan
User Interaction.

| Nama | NIM | Kelas |
| --- | --- | --- |
| Gede Pasek Ary Sugiantara | 2415051074 | PTI 5C |

## Isi Proyek

Aplikasi Course Explorer yang menampilkan daftar course dari JSON statis,
dengan layout adaptif, navigasi utama, dan interaksi pengguna.

Struktur folder:

| Folder | Isi |
| --- | --- |
| `lib/core/` | Konstanta identitas dan fungsi breakpoint |
| `lib/data/` | Model `Course` dan repository JSON |
| `lib/screens/` | Home, Courses, Detail Course, dan Profile |
| `lib/widgets/` | `IdentityHeader`, `CourseCard`, `AppShell`, `FeedbackForm` |
| `lib/tahapan/` | Satu file per tahap 1 sampai 16, masing-masing punya `main()` |
| `assets/data/` | `course_data.json` berisi enam course |
| `test/` | Uji widget, uji repository, dan sapuan layout per tahap |

## Menjalankan Aplikasi Utama

```
flutter pub get
flutter run -d chrome
```

Perintah lain yang berguna:

```
flutter run -d windows
flutter analyze
flutter test
flutter build web --release
```

## Menjalankan Setiap Tahap

Setiap tahap berada pada file tersendiri agar dapat diamati satu per satu.

```
flutter run -t lib/tahapan/tahap_01_hardcoded.dart -d chrome
flutter run -t lib/tahapan/tahap_03_layoutbuilder.dart -d chrome
flutter run -t lib/tahapan/tahap_15_integrasi.dart -d chrome
flutter run -t lib/tahapan/tahap_16_debugging.dart -d chrome
```

Daftar lengkap nama file dapat dilihat pada folder `lib/tahapan/`.

## Breakpoint

| Kategori | Lebar logis | Navigasi | Kolom course |
| --- | --- | --- | --- |
| Compact | di bawah 600 | NavigationBar | 1 |
| Medium | 600 sampai 839 | NavigationBar | 2 |
| Expanded | 840 ke atas | NavigationRail | 3 |

## Pengujian

```
flutter analyze
flutter test
```

Sapuan layout pada `test/tahapan_layout_test.dart` menjalankan seluruh entry
point tahapan pada lebar 320, 360, 640, dan 2560 piksel logis untuk memastikan
tidak ada error layout maupun overflow. Entry point tahap 15 sekaligus
menjalankan aplikasi utama, sehingga Home, Courses, Profile, dan form feedback
ikut diperiksa pada semua lebar tersebut.