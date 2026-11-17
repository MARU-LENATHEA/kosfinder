# Aturan Kerja Agen AI - Proyek KosFinder

Dokumen ini merupakan pedoman wajib (*guidelines*) bagi agen AI dalam mengembangkan dan memelihara proyek **KosFinder**. Semua agen yang bekerja pada repositori ini harus mematuhi aturan berikut tanpa pengecualian.

---

## 1. Konteks Proyek & Dokumen Acuan

**KosFinder** adalah aplikasi pencari dan pengelola indekos di sekitar kampus berbasis Android (Flutter) dengan backend Supabase.

Sebelum melakukan pekerjaan atau perubahan kode, agen **wajib membaca dan merujuk** pada dokumen-dokumen berikut:
* `docs/PRD.md`: Dokumen kebutuhan produk, batasan versi 1 (in-scope & out-of-scope), user stories, dan acceptance criteria (AC).
* `docs/ARCHITECTURE.md`: Arsitektur aplikasi, struktur direktori kode, pola *state management*, model data, dan kebijakan keamanan database.
* `docs/TASKS.md`: Daftar rencana kerja dan pembagian tugas terstruktur yang dilengkapi dengan ID task (misal: `TASK-01`, `TASK-02`, dst.).

---

## 2. Cara Kerja & Batasan Perubahan

1. **Satu Task per Permintaan**: Hanya fokus mengerjakan 1 task spesifik yang diminta pengguna pada setiap siklus interaksi.
2. **Jangan Mengubah File di Luar Task**: Dilarang memodifikasi file yang tidak terkait langsung dengan task yang sedang dikerjakan.
3. **Rencanakan Dulu untuk Perubahan Besar**: Untuk perubahan struktural, refactoring besar, atau perubahan skema data, buat rencana implementasi terlebih dahulu dan minta persetujuan pengguna sebelum mengeksekusi kode.
4. **Pilih Solusi Paling Sederhana**: Utamakan kode yang bersih, mudah dipahami, langsung pada sasaran (*KISS - Keep It Simple, Stupid*), dan hindari rekayasa berlebih (*over-engineering*).
5. **Larangan Menambah Package Sembarangan**: **DILARANG** menambahkan package/dependensi baru pada `pubspec.yaml` tanpa izin eksplisit dari pengguna.

---

## 3. Standar Teknologi

* **Framework**: Flutter (Dart)
* **State Management**: `provider`
* **Backend & Autentikasi**: Supabase (Supabase Auth & PostgreSQL Database)

---

## 4. Keamanan & Kebijakan Data

1. **Bebas Kredensial di Kode Sumber**:
   * Dilarang keras menuliskan password, secret key, atau token sensitif secara *hardcoded* di dalam kode.
   * Gunakan file konfigurasi lokal `.env` (yang wajib masuk dalam `.gitignore`).
2. **Larangan Service Role Key**:
   * `service_role key` **TIDAK BOLEH** pernah dimasukkan atau digunakan di sisi aplikasi klien.
   * Aplikasi hanya boleh menggunakan `anon key` (public key) Supabase.
3. **Penegakan Hak Akses via RLS**:
   * Keamanan hak akses kepemilikan data kos (buat, ubah, hapus) wajib ditegakkan di level database menggunakan **Row Level Security (RLS)** di Supabase, bukan hanya dengan menyembunyikan tombol pada antarmuka pengguna (*UI*).

---

## 5. Standar Git & Commit

1. **Satu Task Satu Commit**: Setiap penyelesaian satu task harus dijadikan satu commit tersendiri.
2. **Format Pesan Commit**: Pesan commit wajib menyebutkan ID task secara eksplisit.
   * Format: `<tipe>(<ID_TASK>): <deskripsi singkat>` atau `<tipe>: <ID_TASK> - <deskripsi singkat>`
   * Contoh: `feat(TASK-03): implementasi model dan service kos` atau `fix(TASK-05): perbaiki validasi form tambah kos`.

---

## 6. Definition of Done (DoD)

Sebuah task dinyatakan selesai (*Done*) hanya jika memenuhi seluruh kriteria berikut:
1. **Analisis Kode Bersih**: Menjalankan `flutter analyze` dengan hasil bersih (0 error, 0 warning).
2. **Pengujian Lulus**: Menjalankan `flutter test` dan seluruh pengujian unit/widget yang relevan lulus.
3. **Verifikasi Perangkat**: Aplikasi berhasil dijalankan pada device yang tersedia (Android emulator, Chrome, atau macOS desktop).
4. **Laporan Transparansi**: Agen wajib melaporkan dengan jujur hal-hal atau skenario yang **belum sempat diuji** (misalnya pengujian pada kondisi jaringan lambat atau perangkat fisik riil).

---

## 7. Informasi Halaman About

Pada halaman **About / Tentang Aplikasi**, wajib mencantumkan identitas pengembang:
* **Identitas**: `2415051046 - I Kadek Dimas Pradana`
