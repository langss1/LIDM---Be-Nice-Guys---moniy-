# MONIY — Progress Log

## Status Ringkas
- Fase aktif: FE (Frontend)
- Terakhir diupdate: 2026-07-09
- Layar selesai: 0 / 7

## Task List

| No | Layar/Task | Status | Referensi Screenshot | Catatan |
|----|-----------|--------|----------------------|---------|
| 1  | Setup project + theme tokens | Done | - | Selesai menyiapkan struktur folder, dependensi (Riverpod, GoRouter, dll), theme dasar, dan file dummy. Menunggu screenshot untuk UI lengkap. |
| 2  | Onboarding/Login/Register | Done | Slide 1 (Login), Slide 2 (Register) | Dibuat sesuai screenshot. Ada 1 reusable widget (CustomTextField). Route /register ditambahkan. Teks GardaWara pada register tetap dipertahankan sesuai screenshot. |
| 3  | Beranda | Done | Slide 3 (Beranda) | UI selesai. Menggunakan Scaffold dengan Bottom Navigation Bar via ShellRoute. |
| 4  | Progres | Blocked | belum | Menunggu screenshot dari owner |
| 5  | Modul | Done | Pilih Topik Modul & Jelajahi Modul | UI selesai sesuai 2 screenshot (Jelajahi Modul & Pilih Topik). |
| 6  | Komunitas | Done | Komunitas & Grup Detail | UI selesai sesuai 2 screenshot (Feed utama Komunitas & Detail Grup Pejuang Cuan). |
| 7  | Profil | Done | Slide 4 (Profil) | UI selesai sesuai screenshot, data mock dummy sementara. |
| 8  | Protection Indicator | Done | Hubungkan Guardian | Layar Hubungkan Guardian selesai dibuat sesuai referensi desain. |

## Blocker / Perlu Klarifikasi
- Menunggu referensi screenshot/slide untuk semua layar (Onboarding, Beranda, Progres, Modul, Komunitas, Profil, Protection Indicator). Tidak ada UI yang akan dibangun sebelum screenshot diberikan.

## Keputusan Teknis yang Sudah Diambil
- Menggunakan `flutter_riverpod` untuk state management.
- Menggunakan `go_router` untuk routing.
- Menggunakan `dio` untuk HTTP client.
- Menggunakan `hive` dan `hive_flutter` untuk local storage.
- Menggunakan `lucide_icons` untuk ikon.
- Menggunakan data mock (hardcoded/file JSON lokal) untuk Fase 1 Frontend.
