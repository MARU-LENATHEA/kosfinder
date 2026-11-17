# KosFinder

Aplikasi pencari dan pengelola indekos di sekitar kampus berbasis Android (Flutter) dengan backend Supabase.

---

## Cara Menjalankan

Aplikasi ini membaca kredensial backend (`SUPABASE_URL` dan `SUPABASE_ANON_KEY`) menggunakan mekanisme `--dart-define` saat waktu kompilasi, sehingga kredensial sensitif tidak ditulis langsung di dalam kode sumber.

### Opsi 1: Menggunakan Argumen CLI Langsung (Nilai Contoh)

Jalankan perintah berikut di terminal dengan mengganti nilai URL dan Anon Key sesuai proyek Supabase Anda:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xyzcompany.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_anon_key_example
```

Untuk perangkat spesifik (misal Google Chrome atau Emulator Android):
```bash
# Menjalankan di Chrome
flutter run -d chrome \
  --dart-define=SUPABASE_URL=https://xyzcompany.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_anon_key_example

# Menjalankan di Emulator Android
flutter run -d emulator-5554 \
  --dart-define=SUPABASE_URL=https://xyzcompany.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_anon_key_example
```

---

### Opsi 2: Menggunakan File `.env` (Direkomendasikan)

1. Salin template konfigurasi `.env.example` menjadi `.env`:
   ```bash
   cp .env.example .env
   ```
2. Buka file `.env` dan isi dengan kredensial asli Supabase Anda:
   ```env
   SUPABASE_URL=https://xyzcompany.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_anon_key_example
   ```
   *(Catatan: File `.env` sudah otomatis diabaikan oleh `.gitignore` sehingga aman dari kebocoran ke Git).*

3. Jalankan aplikasi menggunakan flag `--dart-define-from-file`:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

---

## Build Release APK

Untuk menghasilkan file APK siap rilis:
```bash
flutter build apk --release --dart-define-from-file=.env
```
File APK akan berada di `build/app/outputs/flutter-apk/app-release.apk`.
