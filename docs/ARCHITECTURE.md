# Architecture Document - KosFinder

## 1. Komponen Aplikasi & Pola Arsitektur

Aplikasi menggunakan arsitektur berlapis bersih: **Screen – Provider – Repository – Supabase**.
Pola ini memisahkan tampilan, *state*, abstraksi data, dan backend secara tegas.

```
[Screen (UI)] <---> [Provider (State)] <---> [Repository (Data)] <---> [Supabase Client]
```

### 1.1 Tugas Komponen & Pemetaan User Story
1. **Screen (Presentasi UI)**
   * Tugas: Menampilkan antarmuka pengguna, menangkap aksi interaksi, mendengarkan perubahan *state*, dan menangani alur navigasi.
   * Story: Dibutuhkan oleh seluruh story (**US01 s.d. US08**).
2. **Provider (State Management)**
   * `KosProvider`: Mengelola pemuatan katalog kos, status pencarian area, penerapan filter harga/fasilitas, penanganan *empty state*, dan status koneksi gagal. *(Story: US01, US02, US03, US04)*.
   * `AuthProvider`: Mengelola sesi login, pendaftaran akun pemilik, validasi status terautentikasi, dan logout. *(Story: US05)*.
   * `OwnerKosProvider`: Mengelola daftar kos milik akun aktif, formulir input/validasi, aksi simpan (tambah), ubah, dan hapus kos. *(Story: US06, US07, US08)*.
3. **Repository (Abstraksi Akses Data)**
   * `KosRepository`: Mengambil daftar kos publik, kueri pencarian area, kueri filter, dan detail kos dari Supabase ke model data Dart. *(Story: US01, US02, US03, US04)*.
   * `AuthRepository`: Menghubungkan registrasi dan login ke Supabase GoTrue Auth. *(Story: US05)*.
   * `OwnerKosRepository`: Menjalankan operasi kueri INSERT, UPDATE, dan DELETE pada tabel kos terproteksi. *(Story: US06, US07, US08)*.
4. **Supabase Client (Backend Layer)**
   * Tugas: SDK resmi `supabase_flutter` yang berkomunikasi via HTTPS ke PostgREST API dan GoTrue Auth Supabase dengan penegakan Row Level Security (RLS).
   * Story: Dibutuhkan oleh seluruh story (**US01 s.d. US08**).

---

## 2. Daftar Layar dan Alur Navigasi

### 2.1 Daftar Layar
1. `HomeScreen`: Katalog daftar kos publik, kolom pencarian area, tombol filter, tombol menu ke Halaman About, dan tombol navigasi login pemilik.
2. `FilterModal`: Lembar dialog/modal untuk memilih rentang batas harga dan *checklist* fasilitas.
3. `DetailScreen`: Halaman rincian lengkap kos (nama, alamat area, harga, fasilitas, status ketersediaan, dan tombol kontak WhatsApp/Telepon).
4. `LoginScreen` & `RegisterScreen`: Halaman formulir autentikasi pemilik kos.
5. `OwnerDashboardScreen`: Halaman manajemen daftar kos milik pemilik yang sedang login, tombol aksi hapus, tombol edit, dan tombol tambah (+).
6. `KosFormScreen`: Halaman formulir untuk menambah kos baru atau memperbarui kos yang sudah ada.
7. `AboutScreen`: Halaman informasi aplikasi yang menampilkan identitas pengembang: `2415051046 - I Kadek Dimas Pradana`.

### 2.2 Alur Navigasi
* **Pencari Kos**:
  `Buka Aplikasi` -> `HomeScreen` -> `DetailScreen` (klik kartu kos) -> `Aplikasi Eksternal WhatsApp/Telepon` (klik kontak).
  `HomeScreen` -> `FilterModal` (terapkan kriteria) -> `HomeScreen` (hasil terfilter).
  `HomeScreen` -> `AboutScreen` (klik menu Tentang).
* **Pemilik Kos**:
  `HomeScreen` -> `LoginScreen` / `RegisterScreen` -> `OwnerDashboardScreen`.
  `OwnerDashboardScreen` -> `KosFormScreen(mode: Tambah)` -> Simpan -> kembali ke `OwnerDashboardScreen`.
  `OwnerDashboardScreen` -> `KosFormScreen(mode: Edit)` -> Simpan -> kembali ke `OwnerDashboardScreen`.
  `OwnerDashboardScreen` -> Konfirmasi Hapus -> data terhapus -> `OwnerDashboardScreen` ter-refresh.
  `OwnerDashboardScreen` -> Logout -> kembali ke `HomeScreen`.

---

## 3. Rencana Database & Keamanan Akses (Supabase PostgreSQL)

### 3.1 Skema Tabel `public.kos`
| Nama Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `uuid` | Primary Key, default `gen_random_uuid()` |
| `owner_id` | `uuid` | Foreign Key ke `auth.users(id)` ON DELETE CASCADE |
| `name` | `text` | Nama kos (NOT NULL) |
| `area` | `text` | Wilayah/area kos (NOT NULL) |
| `price` | `numeric` | Harga sewa bulanan bertipe angka (NOT NULL, CHECK `price >= 0`) |
| `facilities` | `text[]` | Daftar fasilitas (NOT NULL, default `'{}'`) |
| `contact` | `text` | Nomor kontak telepon / WhatsApp pemilik (NOT NULL) |
| `is_available`| `boolean` | Status ketersediaan kamar (NOT NULL, default `true`) |
| `created_at` | `timestamptz` | Waktu dibuat, default `now()` |
| `updated_at` | `timestamptz` | Waktu diperbarui, default `now()` |

### 3.2 Relasi Data
* Tabel `public.kos.owner_id` memiliki relasi *many-to-one* dengan tabel bawaan `auth.users.id` di Supabase.

### 3.3 Aturan Akses (Row Level Security - RLS)
* **Melihat (SELECT)**:
  * Akses: Terbuka untuk umum (*public* / role `anon` dan `authenticated`).
  * Aturan: Siapa saja dapat melihat seluruh data kos (`USING (true)`).
* **Menambah (INSERT)**:
  * Akses: Hanya pengguna terautentikasi (*role* `authenticated`).
  * Aturan: Pemilik hanya dapat menyisipkan baris dengan `owner_id` miliknya sendiri (`WITH CHECK (auth.uid() = owner_id)`).
* **Mengubah (UPDATE)**:
  * Akses: Hanya pengguna terautentikasi (*role* `authenticated`).
  * Aturan: Pemilik hanya dapat mengedit baris kos miliknya sendiri (`USING (auth.uid() = owner_id)`).
* **Menghapus (DELETE)**:
  * Akses: Hanya pengguna terautentikasi (*role* `authenticated`).
  * Aturan: Pemilik hanya dapat menghapus baris kos miliknya sendiri (`USING (auth.uid() = owner_id)`).

---

## 4. Konfigurasi Kredensial (`--dart-define`)

Untuk menjaga keamanan kode sumber dari kebocoran kunci, konfigurasi URL dan Anon Key Supabase **wajib dibaca saat kompilasi** menggunakan `String.fromEnvironment`, bukan ditulis secara *hardcoded*:

```dart
class AppConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
}
```

* **Menjalankan aplikasi saat pengembangan**:
  ```bash
  flutter run --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co --dart-define=SUPABASE_ANON_KEY=<anon-key>
  ```
  Atau menggunakan file konfigurasi lokal `.env` (yang diabaikan oleh `.gitignore`):
  ```bash
  flutter run --dart-define-from-file=.env
  ```

---

## 5. Cara Rilis (Build APK & GitHub Release)

### 5.1 Build APK Release
Jalankan perintah build APK mandiri dengan menyertakan variabel lingkungan:
```bash
flutter build apk --release --dart-define-from-file=.env
```
File biner APK siap rilis akan dihasilkan pada:
`build/app/outputs/flutter-apk/app-release.apk`

### 5.2 Publikasi ke GitHub Release
1. Berikan tag versi git pada commit rilis:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```
2. Buka repository GitHub di browser: `https://github.com/MARU-LENATHEA/kosfinder/releases/new`.
3. Pilih tag `v1.0.0`, tuliskan judul rilis dan catatan perubahan (*release notes*).
4. Unggah berkas `app-release.apk` ke area *Attach binaries*.
5. Klik tombol **Publish release**.

---

## 6. Package yang Dibutuhkan & Pemetaan Story

| Package | Alasan & Fungsi | Pemetaan Story |
| :--- | :--- | :--- |
| `provider` | State management resmi dan ringan untuk memisahkan UI dan logika bisnis tanpa boilerplate berlebih. | Seluruh Story (**US01 s.d. US08**) |
| `supabase_flutter` | SDK resmi Supabase untuk otentikasi pemilik (GoTrue) dan operasi database PostgREST dengan RLS. | Seluruh Story (**US01 s.d. US08**) |
| `url_launcher` | Membuka tautan eksternal nomor kontak WhatsApp (`https://wa.me/`) dan telepon (`tel:`) dari halaman detail tanpa perlu chat in-app. | **US04 (Detail Kos)** |

*(Catatan: Penambahan package ke `pubspec.yaml` akan dimintakan persetujuan pengguna sebelum dieksekusi sesuai aturan `AGENTS.md`).*
