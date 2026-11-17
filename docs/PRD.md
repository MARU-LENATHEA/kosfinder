# Product Requirements Document (PRD) - KosFinder

## 1. Masalah dan Tujuan yang Bisa Diukur

### 1.1 Masalah
1. Informasi indekos di sekitar kampus tersebar di media sosial, grup WhatsApp, dan dari mulut ke mulut tanpa format terpusat.
2. Pencari kos mengalami kesulitan membandingkan harga serta fasilitas kos secara langsung dan objektif.
3. Pemilik kos mengalami kesulitan memperbarui informasi ketersediaan kamar secara berkala dan terpusat.

### 1.2 Tujuan yang Bisa Diukur (Measurable Goals)
1. **Efisiensi Temuan**: Pencari kos dapat menemukan daftar kos, mencari berdasarkan area, serta memfilter harga dan fasilitas dengan hasil tampil dalam waktu < 2 detik pada koneksi internet stabil.
2. **Kemudahan Publikasi**: Pemilik kos dapat mendaftar, masuk, dan mempublikasikan data kos baru dalam waktu < 3 menit.
3. **Pembaruan Data Cepat**: Pemilik kos dapat memperbarui detail dan ketersediaan kos miliknya dalam waktu < 30 detik.
4. **Integritas Kepemilikan**: 100% operasi pengubahan dan penghapusan kos terlindungi oleh Row Level Security (RLS) di Supabase, memastikan 0% insiden manipulasi data kos milik pengguna lain.

---

## 2. Pengguna

1. **Pencari Kos (Mahasiswa / Masyarakat Umum)**
   * Karakteristik: Mengakses aplikasi tanpa perlu membuat akun atau login (*unauthenticated/guest*).
   * Kebutuhan: Melihat katalog kos, mencari berdasarkan nama area, menyaring berdasarkan harga dan fasilitas, serta melihat rincian informasi kos.
2. **Pemilik Kos**
   * Karakteristik: Pengguna terdaftar dan terotentikasi (*authenticated user* via Supabase Auth).
   * Kebutuhan: Registrasi akun, login, mempublikasikan kos baru, serta mengubah dan menghapus kos miliknya sendiri.

---

## 3. Scope Versi 1

### 3.1 Fitur yang Masuk (In-Scope)
* Eksplorasi katalog kos di beranda tanpa kewajiban login.
* Pencarian kos berdasarkan kata kunci nama area.
* Penyaringan (filter) kos berdasarkan rentang harga dan fasilitas.
* Tampilan halaman detail kos (informasi harga, area, fasilitas, dan ketersediaan).
* Registrasi dan autentikasi login pemilik kos menggunakan Supabase Auth.
* Manajemen kos oleh pemilik: Tambah kos baru, Edit data kos milik sendiri, dan Hapus data kos milik sendiri.
* Penanganan status sistem: antarmuka saat data kosong (*empty state*) dan pesan kesalahan koneksi jaringan terputus.

### 3.2 Fitur yang TIDAK Masuk (Out-of-Scope)
* Pembayaran online / transaksi perbankan.
* Chat internal (*in-app messaging*).
* Ulasan dan penilaian (*rating & reviews*).
* Rekomendasi pintar / kecerdasan buatan (AI recommendation).
* Verifikasi identitas resmi pemilik kos (KTP / KYC).
* Fitur unggah foto (*upload image/media storage*).
* Peta digital / integrasi Google Maps / geolocation.

---

## 4. Non-Functional Requirements (NFR)

* **Keamanan (Security)**
  * **NFR-SEC1**: Pengubahan dan penghapusan data kos dibatasi ketat pada level basis data via Supabase Row Level Security (RLS) berdasarkan `owner_id == auth.uid()`. (Pengujian: Kirim HTTP PUT/DELETE ke baris data pemilik lain menggunakan token pengguna A; sistem wajib merespons penolakan izin / error 403).
  * **NFR-SEC2**: Kata sandi pemilik tidak pernah disimpan dalam bentuk teks polos dan dikelola sepenuhnya oleh modul enkripsi Supabase Auth. (Pengujian: Inspeksi basis data dan payload jaringan; tidak ada string password mentah yang terekspos).
* **Keandalan (Reliability)**
  * **NFR-REL1**: Saat koneksi internet terputus atau server backend tidak merespons, aplikasi tidak mengalami *crash* dan wajib menampilkan pesan ramah serta tombol muat ulang (*retry*). (Pengujian: Matikan koneksi perangkat saat memuat data; aplikasi menampilkan indikator error dan tombol coba lagi).
  * **NFR-REL2**: Ketika kueri data bernilai kosong, aplikasi wajib menampilkan komponen antarmuka status kosong tanpa menyebabkan *null reference exception*. (Pengujian: Lakukan pencarian dengan kata kunci acak; layar menampilkan informasi *"Data tidak ditemukan"*).
* **Kemudahan Pakai (Usability)**
  * **NFR-USE1**: Pencari kos dapat langsung menjelajahi seluruh data kos sejak aplikasi dibuka pertama kali tanpa ada dialog pemaksaan login (*login wall*). (Pengujian: Jalankan instalasi baru aplikasi dan verifikasi tidak ada *prompt* login saat eksplorasi katalog).
  * **NFR-USE2**: Formulir penambahan/pengubahan kos memvalidasi masukan wajib (nama kos, area, harga) sebelum data dikirimkan ke server. (Pengujian: Kosongkan field wajib lalu tekan tombol simpan; pesan validasi muncul dan request tidak terkirim).
* **Performa (Performance)**
  * **NFR-PERF1**: Waktu muat awal katalog kos tidak melebihi 2 detik pada jaringan 4G/WiFi stabil. (Pengujian: Ukur durasi sejak halaman katalog dipanggil hingga daftar data dirender).
  * **NFR-PERF2**: Penyaringan kos lokal/kueri basis data memunculkan hasil ke layar dalam waktu < 1 detik. (Pengujian: Terapkan filter harga/fasilitas dan hitung durasi pembaruan tampilan).
* **Privasi (Privacy)**
  * **NFR-PRIV1**: Informasi kredensial privat akun pemilik kos tidak dipublikasikan ke daftar publik atau log klien. (Pengujian: Periksa respons endpoint katalog kos publik; atribut kredensial privat tidak disertakan).

---

## 5. User Stories

* **US01 (Katalog Kos)**: Sebagai pencari kos, saya ingin melihat daftar kos yang tersedia tanpa perlu login, agar saya dapat mengetahui pilihan kos yang ada dengan cepat dan mudah.
* **US02 (Pencarian Area)**: Sebagai pencari kos, saya ingin mencari kos berdasarkan kata kunci nama area, agar saya dapat menemukan kos yang berada di lokasi sekitar kampus yang saya tuju.
* **US03 (Filter Kos)**: Sebagai pencari kos, saya ingin menyaring daftar kos berdasarkan harga dan fasilitas, agar saya dapat menemukan kos yang sesuai dengan anggaran dan kebutuhan saya.
* **US04 (Detail Kos)**: Sebagai pencari kos, saya ingin melihat halaman detail kos secara lengkap, agar saya memahami seluruh informasi fasilitas, harga, dan ketersediaan sebelum memutuskan.
* **US05 (Autentikasi Pemilik)**: Sebagai pemilik kos, saya ingin mendaftar dan masuk ke dalam akun saya, agar saya memiliki hak untuk mengelola properti kos yang saya miliki.
* **US06 (Tambah Kos)**: Sebagai pemilik kos, saya ingin menambahkan data kos baru, agar kos saya dapat dipublikasikan dan dilihat oleh calon penyewa.
* **US07 (Ubah Kos Milik Sendiri)**: Sebagai pemilik kos, saya ingin memperbarui informasi dan ketersediaan kos milik saya, agar informasi kos yang dilihat calon penyewa selalu akurat.
* **US08 (Hapus Kos Milik Sendiri)**: Sebagai pemilik kos, saya ingin menghapus kos milik saya yang sudah tidak disewakan lagi, agar kos tersebut tidak lagi muncul di daftar pencarian aplikasi.

---

## 6. Acceptance Criteria

### US01: Katalog Kos
* **US01-AC1**: Given pencari kos membuka aplikasi dengan koneksi internet aktif, When halaman beranda dimuat, Then sistem menampilkan daftar kos yang mencakup nama, area, harga, dan ketersediaan.
* **US01-AC2 (Kasus Data Kosong)**: Given belum ada data kos yang tersimpan di dalam sistem, When pencari kos membuka beranda, Then sistem menampilkan pesan informasi *"Belum ada kos yang terdaftar saat ini"*.
* **US01-AC3 (Kasus Koneksi Gagal)**: Given perangkat tidak memiliki koneksi internet, When beranda dibuka atau ditarik untuk dimuat ulang (*pull-to-refresh*), Then sistem menampilkan pesan kesalahan *"Gagal memuat data. Periksa koneksi internet Anda"* beserta tombol *"Coba Lagi"*.

### US02: Pencarian Area
* **US02-AC1**: Given pencari kos berada di halaman daftar kos, When memasukkan kata kunci nama area pada kolom pencarian dan menekan tombol cari, Then daftar kos diperbarui hanya menampilkan kos yang areanya cocok dengan kata kunci.
* **US02-AC2 (Kasus Data Kosong)**: Given pencari kos memasukkan kata kunci area yang tidak cocok dengan data apa pun, When pencarian dijalankan, Then sistem menampilkan pesan *"Kos di area tersebut tidak ditemukan"*.
* **US02-AC3 (Kasus Koneksi Gagal)**: Given koneksi internet terputus saat pencarian dikirimkan ke server, When proses kueri berjalan, Then sistem menampilkan pesan kesalahan jaringan tanpa mengosongkan teks pencarian yang dimasukkan.

### US03: Filter Kos
* **US03-AC1**: Given pencari kos berada di menu filter, When menentukan batas harga dan memilih fasilitas yang diinginkan lalu menekan tombol terapkan, Then daftar kos hanya memuat kos yang memenuhi kriteria harga dan memiliki fasilitas tersebut.
* **US03-AC2 (Kasus Data Kosong)**: Given tidak ada kos yang memenuhi kombinasi filter harga dan fasilitas yang dipilih, When filter diterapkan, Then sistem menampilkan daftar kosong disertai pesan instruktif untuk mengatur ulang filter.

### US04: Detail Kos
* **US04-AC1**: Given pencari kos memilih salah satu kartu kos pada daftar, When kartu ditekan, Then sistem berpindah ke halaman detail yang menampilkan nama kos, alamat area lengkap, rincian harga, daftar fasilitas, dan status ketersediaan.
* **US04-AC2 (Kasus Koneksi Gagal)**: Given koneksi internet terputus saat membuka detail kos yang datanya belum ter-cache, When proses navigasi berlangsung, Then sistem menampilkan pesan gagal memuat detail kos disertai tombol muat ulang.

### US05: Autentikasi Pemilik
* **US05-AC1**: Given pemilik kos berada di halaman registrasi, When mengisi email dan kata sandi valid lalu menekan daftar, Then akun berhasil dibuat di Supabase Auth dan pengguna diarahkan ke sesi masuk.
* **US05-AC2**: Given pemilik kos berada di halaman login, When memasukkan email dan password yang terdaftar dengan benar, Then sistem mengizinkan masuk dan mengarahkan pengguna ke halaman manajemen kos miliknya.
* **US05-AC3**: Given pemilik kos memasukkan password yang salah, When menekan tombol masuk, Then sistem menampilkan pesan error otentikasi dan sesi login tidak dibuat.

### US06: Tambah Kos
* **US06-AC1**: Given pemilik kos telah login dan berada di formulir tambah kos, When mengisi seluruh data yang diwajibkan (nama, area, harga, fasilitas) dan menekan tombol simpan, Then data kos baru tersimpan di Supabase dengan `owner_id` pemilik saat ini dan muncul di daftar kos miliknya.
* **US06-AC2 (Kasus Koneksi Gagal)**: Given koneksi internet terputus saat pemilik menekan tombol simpan pada formulir tambah kos, When proses pengiriman data gagal, Then sistem menampilkan pesan kesalahan jaringan dan seluruh isian formulir tetap dipertahankan.

### US07: Ubah Kos Milik Sendiri
* **US07-AC1**: Given pemilik kos telah login dan membuka halaman edit untuk kos miliknya sendiri, When mengubah informasi (misal: harga atau status ketersediaan) dan menekan simpan, Then data kos diperbarui di basis data Supabase dan perubahan langsung terlihat pada aplikasi.
* **US07-AC2 (Kasus Pemilik Mencoba Mengubah Kos Milik Orang Lain)**: Given pengguna terautentikasi (Pemilik A) mencoba mengirim perintah pembaruan untuk data kos milik Pemilik B (melalui manipulasi ID atau payload kueri), When permintaan diproses oleh basis data Supabase, Then aturan Row Level Security (RLS) menolak pembaruan (*permission denied*), data kos Pemilik B tidak berubah, dan aplikasi menampilkan pesan penolakan akses.

### US08: Hapus Kos Milik Sendiri
* **US08-AC1**: Given pemilik kos telah login dan memilih opsi hapus pada kos miliknya sendiri, When pemilik mengonfirmasi dialog konfirmasi penghapusan, Then baris data kos dihapus dari basis data dan tidak lagi muncul di halaman publik maupun daftar milik pemilik.
* **US08-AC2 (Kasus Pemilik Mencoba Menghapus Kos Milik Orang Lain)**: Given pengguna terautentikasi (Pemilik A) mencoba mengirim instruksi hapus untuk ID kos milik Pemilik B, When instruksi dieksekusi ke backend Supabase, Then aturan RLS menolak operasi penghapusan dan data kos Pemilik B tetap utuh di basis data.

---

## 7. Resolusi dan Keputusan Hal Ambigu

Seluruh poin ambigu dari masukan awal telah dijawab dan diputuskan dengan solusi paling sederhana tanpa menambah kompleksitas atau fitur di luar scope:
1. **Mekanisme Penghubung Pemilik & Pencari**: Pemilik mencantumkan nomor kontak (telepon/WhatsApp) pada data kos. Pada halaman detail, nomor tersebut ditampilkan dengan tombol yang membuka aplikasi telepon (*dialer*) atau tautan eksternal WhatsApp (`https://wa.me/`) tanpa fitur chat internal.
2. **Representasi Visual Kartu Kos**: Tampilan kartu kos menggunakan gambar ilustrasi bawaan (*default static asset placeholder*) yang seragam dan ikon, tanpa sistem unggah file maupun input link eksternal.
3. **Format Fasilitas**: Menggunakan daftar *checklist* tetap standar (*WiFi, AC, Kamar Mandi Dalam, Kasur, Lemari, Parkir Motor*) yang disimpan sebagai array teks (`text[]`), sehingga filter bekerja konsisten.
4. **Format Pencarian Area**: Menggunakan pencarian kecocokan teks fleksibel (*case-insensitive substring match* via `ilike`) pada field `area`, tanpa integrasi peta maupun dropdown kaku.
5. **Format Status Ketersediaan**: Menggunakan status biner boolean `is_available` (**Tersedia / Penuh**) dengan tombol *toggle*, sehingga pemilik dapat memperbarui ketersediaan dalam 1 kali klik.
6. **Kebijakan Kepemilikan & Penghapusan**: Satu akun pemilik dapat mendaftarkan lebih dari satu kos (*one-to-many*). Penghapusan kos dilakukan secara langsung (*hard delete*) setelah konfirmasi dialog.
