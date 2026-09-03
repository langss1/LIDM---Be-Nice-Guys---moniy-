# CLAUDE.md — Moniy (LIDM · Be Nice Guys)

> Dibaca Claude yang jalan di GitHub Actions setiap run. **Jaga tetap pendek** —
> file ini masuk konteks di setiap run, jadi ikut biaya.
> Ini file repo, terpisah dari `~/CLAUDE.md` di laptop. Runner tidak melihat yang itu.

## Stack — repo ini berisi empat bagian

| Folder | Isi | Package manager |
|---|---|---|
| `/` (root, `lib/`) | Aplikasi **Flutter** (Dart), target Android/iOS/web/desktop | pub |
| `backend/` | **NestJS** (TypeScript) | npm |
| `admin/` | Server Node + Supabase (`server.js`, `supabase_schema.sql`) | npm |
| `dashboard/` | Punya `CLAUDE.md` dan `AGENTS.md` sendiri — **baca file itu dulu** kalau bekerja di sana |

Selalu kerjakan di folder yang benar. Perintah root bukan perintah backend.

## Commands

```bash
# Flutter (root)
flutter pub get
flutter analyze          # lint; harus bersih
flutter test             # ada folder test/
flutter build apk --debug

# backend/ (NestJS)
npm ci
npm run build            # <- WAJIB lolos sebelum commit
npm run lint
npm test

# admin/
npm ci
```

## Aturan wajib

1. **Build bagian yang kamu sentuh harus lolos sebelum commit.** Menyentuh Flutter →
   `flutter analyze` bersih. Menyentuh `backend/` → `npm run build` exit 0.
   Jangan matikan lint/test supaya hijau.
2. **Jangan pernah push langsung ke `main`.** Selalu branch baru + Pull Request.
3. **Skema database butuh persetujuan manusia.** `database_migration_likes_comments.sql`
   dan `admin/supabase_schema.sql` jangan dieksekusi atau diubah diam-diam — tulis
   rencananya di komentar PR lebih dulu.
4. **Rahasia tidak pernah masuk kode.** Kunci Supabase dari environment variable.
   Jangan membaca atau meng-commit isi `.env*`.
5. **Satu PR = satu perubahan**, dan sebaiknya satu folder. PR yang mengubah Flutter
   dan backend sekaligus sulit ditinjau dari HP.
6. Ikuti gaya kode yang sudah ada di folder tersebut.

## Jangan disentuh

- `pubspec.lock`, `package-lock.json` — hanya lewat package manager
- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/` — hasil generate platform;
  hanya diubah kalau memang itu tugasnya
- `build/`, `backend/dist/` — hasil build
- `analysis_options.yaml`, `devtools_options.yaml`, `backend/tsconfig*.json`,
  `backend/nest-cli.json`, `backend/eslint.config.mjs` — config
- `.github/workflows/**` — CI
- `mock_data/` — data contoh untuk demo lomba; jangan diubah tanpa diminta
- `.env*` — jangan dibaca, jangan di-commit

## Catatan

Ini repo lomba (LIDM). Tidak tertaut Vercel — merge ke `main` tidak men-deploy apa pun.
`progress.md` adalah catatan tim; perbarui hanya kalau diminta.

## Kalau ragu

Ragu soal keputusan produk atau arsitektur? Jangan tebak. Tulis pertanyaannya di
komentar PR dan kerjakan bagian yang sudah jelas saja.
