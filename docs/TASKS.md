# Rencana Tugas Pengembangan (TASKS) - KosFinder

Dokumen ini memuat daftar tugas terstruktur dalam urutan **Vertical Slice**. Setiap slice menghasilkan aplikasi yang utuh dan dapat dijalankan (*runnable*). Setiap task dirancang kecil, fokus, dan mencakup pengujian sebelum dilanjutkan ke task berikutnya sesuai pedoman `AGENTS.md`.

---

## Slice 1: Daftar dan Detail Kos
*Hasil Slice*: Aplikasi dapat dijalankan, menampilkan katalog kos publik dari Supabase (beserta penanganan data kosong dan koneksi terputus), halaman detail kos dengan tombol kontak eksternal, serta halaman About.

| ID | Tujuan | Story & AC Terkait | File yang Boleh Diubah | Cara Menguji | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T01** | Setup dependensi (`provider`, `supabase_flutter`, `url_launcher`) dan pembacaan konfigurasi `--dart-define` | Fondasi US01-AC1, US04-AC1 | `pubspec.yaml`, `lib/core/config/app_config.dart`, `lib/main.dart` | Jalankan `flutter pub get` dan pastikan `flutter run` membuka aplikasi tanpa error | Belum Mulai |
| **T02** | Buat model data `Kos` dan `KosRepository` untuk mengambil data kos publik dari Supabase | US01-AC1, US01-AC2, US01-AC3, US04-AC1 | `lib/data/models/kos_model.dart`, `lib/data/repositories/kos_repository.dart` | Jalankan unit test konversi JSON ke model `Kos` dan fungsi `getKosList()` | Belum Mulai |
| **T03** | Buat `KosProvider` untuk mengelola state daftar kos, loading, empty state, dan koneksi gagal | US01-AC1, US01-AC2, US01-AC3 | `lib/presentation/providers/kos_provider.dart` | Jalankan unit test `KosProvider` untuk skenario data ada, kosong, dan error jaringan | Belum Mulai |
| **T04** | Buat tampilan `HomeScreen` (kartu kos, empty state, error retry) dan `AboutScreen` (NIM & Nama pengembang) | US01-AC1, US01-AC2, US01-AC3 | `lib/presentation/screens/home_screen.dart`, `lib/presentation/widgets/kos_card.dart`, `lib/presentation/screens/about_screen.dart`, `lib/main.dart` | Jalankan aplikasi di emulator/Chrome, verifikasi kartu kos tampil, pull-to-refresh jalan, dan About menampilkan `2415051046 - I Kadek Dimas Pradana` | Belum Mulai |
| **T05** | Buat tampilan `DetailScreen` berisi informasi lengkap kos dan tombol kontak WhatsApp/Telepon eksternal | US04-AC1, US04-AC2 | `lib/presentation/screens/detail_screen.dart`, `lib/presentation/screens/home_screen.dart` | Ketuk salah satu kartu di `HomeScreen`, pastikan halaman detail terbuka dengan info lengkap dan tombol kontak memanggil `url_launcher` | Belum Mulai |

---

## Slice 2: Pencarian dan Filter
*Hasil Slice*: Aplikasi dapat dijalankan, pengguna dapat mencari kos berdasarkan nama area secara interaktif dan menyaring berdasarkan batas harga sewa serta fasilitas.

| ID | Tujuan | Story & AC Terkait | File yang Boleh Diubah | Cara Menguji | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T06** | Implementasikan kueri pencarian teks area pada `KosRepository` dan pembaruan state pada `KosProvider` | US02-AC1, US02-AC2, US02-AC3 | `lib/data/repositories/kos_repository.dart`, `lib/presentation/providers/kos_provider.dart` | Jalankan unit test pencarian area untuk keyword yang cocok, tidak cocok (empty), dan error | Belum Mulai |
| **T07** | Buat komponen Search Bar interaktif di `HomeScreen` untuk pencarian kos berdasarkan area | US02-AC1, US02-AC2, US02-AC3 | `lib/presentation/screens/home_screen.dart` | Masukkan nama area di search bar; verifikasi hasil tersaring dan jika tidak ditemukan muncul pesan *"Kos di area tersebut tidak ditemukan"* | Belum Mulai |
| **T08** | Implementasikan kueri penyaringan harga (rentang maksimum) dan fasilitas checklist pada `KosRepository` & `KosProvider` | US03-AC1, US03-AC2 | `lib/data/repositories/kos_repository.dart`, `lib/presentation/providers/kos_provider.dart` | Jalankan unit test filter dengan kombinasi harga maksimum dan array fasilitas | Belum Mulai |
| **T09** | Buat tampilan dialog `FilterModal` (slider/input harga & checklist fasilitas) terintegrasi ke `HomeScreen` | US03-AC1, US03-AC2 | `lib/presentation/widgets/filter_modal.dart`, `lib/presentation/screens/home_screen.dart` | Buka modal filter, atur harga dan pilih fasilitas, tekan terapkan; verifikasi daftar kos ter-update sesuai kriteria | Belum Mulai |

---

## Slice 3: Login Pemilik
*Hasil Slice*: Aplikasi dapat dijalankan, pemilik kos dapat mendaftar akun baru, login, logout, dan diarahkan ke halaman dashboard pemilik.

| ID | Tujuan | Story & AC Terkait | File yang Boleh Diubah | Cara Menguji | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T10** | Buat `AuthRepository` dan `AuthProvider` untuk registrasi, login, logout, dan pantau sesi via Supabase GoTrue Auth | US05-AC1, US05-AC2, US05-AC3 | `lib/data/repositories/auth_repository.dart`, `lib/presentation/providers/auth_provider.dart` | Jalankan unit test otentikasi untuk skenario login berhasil, password salah, dan logout | Belum Mulai |
| **T11** | Buat halaman `LoginScreen` dan `RegisterScreen` dengan validasi formulir dan penanganan error otentikasi | US05-AC1, US05-AC2, US05-AC3 | `lib/presentation/screens/login_screen.dart`, `lib/presentation/screens/register_screen.dart`, `lib/presentation/screens/home_screen.dart` | Navigasi ke login dari `HomeScreen`, coba daftar akun baru, login dengan password keliru (cek pesan error), lalu login berhasil | Belum Mulai |
| **T12** | Buat halaman `OwnerDashboardScreen` untuk area privat pemilik dengan info akun dan tombol logout | US05-AC2 | `lib/presentation/screens/owner_dashboard_screen.dart`, `lib/presentation/screens/login_screen.dart` | Setelah login berhasil, pastikan pengguna diarahkan ke dashboard pemilik, dan tombol logout mengembalikan sesi ke `HomeScreen` | Belum Mulai |

---

## Slice 4: Tambah, Ubah, Hapus Kos Milik Sendiri
*Hasil Slice*: Aplikasi dapat dijalankan, pemilik dapat mempublikasikan kos baru, memperbarui data kos miliknya, dan menghapus kos miliknya dengan proteksi RLS Supabase.

| ID | Tujuan | Story & AC Terkait | File yang Boleh Diubah | Cara Menguji | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T13** | Buat `OwnerKosRepository` dan `OwnerKosProvider` untuk operasi CRUD kos khusus pemilik berdasarkan `owner_id` | US06-AC1, US06-AC2, US07-AC1, US07-AC2, US08-AC1, US08-AC2 | `lib/data/repositories/owner_kos_repository.dart`, `lib/presentation/providers/owner_kos_provider.dart` | Jalankan unit test operasi insert, update, delete dan penanganan error penolakan RLS jika data bukan milik user | Belum Mulai |
| **T14** | Buat formulir `KosFormScreen(mode: Tambah)` dengan validasi field wajib dan penanganan jaringan gagal | US06-AC1, US06-AC2 | `lib/presentation/screens/kos_form_screen.dart`, `lib/presentation/screens/owner_dashboard_screen.dart` | Buka form tambah dari dashboard, isi semua kolom wajib, simpan; verifikasi kos baru muncul di dashboard dan katalog publik | Belum Mulai |
| **T15** | Buat fungsi edit pada `KosFormScreen(mode: Edit)` untuk memperbarui kos milik sendiri | US07-AC1, US07-AC2 | `lib/presentation/screens/kos_form_screen.dart`, `lib/presentation/screens/owner_dashboard_screen.dart` | Ketuk edit pada kos milik sendiri, ubah harga, tekan simpan; verifikasi perubahan data tersimpan di Supabase | Belum Mulai |
| **T16** | Buat dialog konfirmasi hapus pada `OwnerDashboardScreen` untuk menghapus kos milik sendiri | US08-AC1, US08-AC2 | `lib/presentation/screens/owner_dashboard_screen.dart` | Ketuk tombol hapus, konfirmasi dialog; pastikan data terhapus permanen dari dashboard pemilik dan beranda publik | Belum Mulai |

---

## Slice 5: (Bonus) Ketersediaan Kamar
*Hasil Slice*: Aplikasi dapat dijalankan, pemilik dapat mengubah status ketersediaan (*Tersedia/Penuh*) secara cepat dalam 1 klik, dan pencari kos dapat melihat badge status ketersediaan secara jelas.

| ID | Tujuan | Story & AC Terkait | File yang Boleh Diubah | Cara Menguji | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T17** | Implementasikan tombol toggle cepat status ketersediaan (`is_available`) pada kartu kos di `OwnerDashboardScreen` | US07-AC1, US07-AC2 | `lib/presentation/screens/owner_dashboard_screen.dart`, `lib/presentation/providers/owner_kos_provider.dart` | Klik switch toggle ketersediaan di dashboard pemilik; verifikasi perubahan status biner langsung ter-update di Supabase dalam 1 kali klik | Belum Mulai |
| **T18** | Tampilkan badge visual indikator ketersediaan (*Tersedia* hijau / *Penuh* abu-abu) pada `KosCard` di `HomeScreen` dan `DetailScreen` | US01-AC1, US04-AC1 | `lib/presentation/widgets/kos_card.dart`, `lib/presentation/screens/detail_screen.dart` | Periksa kartu kos di `HomeScreen` dan `DetailScreen`; pastikan status ketersediaan tampil dengan warna pembeda yang jelas | Belum Mulai |
