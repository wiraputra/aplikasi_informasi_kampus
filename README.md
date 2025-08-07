Aplikasi Informasi Kampus PNB
![alt text](assets/kampus1.jpg)
Sebuah aplikasi mobile fungsional yang dibangun menggunakan Flutter untuk menyediakan informasi lengkap dan interaktif seputar Politeknik Negeri Bali (PNB). Proyek ini dikembangkan sebagai bagian dari Proyek Akhir Semester (UAS) untuk mendemonstrasikan penerapan konsep-konsep kunci dalam pengembangan aplikasi mobile.

📋 Daftar Isi
Fitur Utama
Tangkapan Layar (Screenshots)
Teknologi dan Dependensi
Arsitektur dan Alur Kerja
Struktur File
Diagram Alur
Instalasi dan Konfigurasi
Kontributor

✨ Fitur Utama
Aplikasi ini dirancang untuk menjadi sumber informasi terpusat bagi mahasiswa dan calon mahasiswa PNB, dengan fitur-fitur sebagai berikut:
Beranda Dinamis: Tampilan beranda yang modern dengan SliverAppBar, menu akses cepat, dan widget cuaca real-time.
Informasi Jurusan: Daftar program studi yang tersedia, disajikan dalam kartu visual yang menarik.
Galeri Fasilitas: Tampilan fasilitas kampus dalam bentuk grid interaktif yang menampilkan detail saat diklik.
Peta Kampus Interaktif (GPS): Menampilkan lokasi kampus di peta OpenStreetMap.
Mendeteksi lokasi pengguna saat ini dan menampilkannya di peta.
Tombol untuk membuka lokasi di Google Maps untuk navigasi.
Berita dan Pengumuman (API):
Mengambil berita terkini seputar pendidikan dari API eksternal (NewsAPI.org).
Menampilkan berita dalam daftar yang bisa di-scroll, dengan tautan ke artikel asli.
Sistem Saran & Masukan (CRUD SQLite):
Form untuk mengirimkan saran dan masukan.
Data disimpan secara lokal di perangkat menggunakan database SQLite.
Fungsionalitas CRUD penuh: pengguna dapat Melihat, Memperbarui, dan Menghapus saran yang telah mereka kirim.
Navigasi Modern: Menggunakan Navigation Drawer yang dipersonalisasi untuk berpindah antar halaman dengan mudah.
📸 Tangkapan Layar (Screenshots)
Beranda	Halaman Jurusan	Peta Lokasi
(Screenshot HomePage di sini)	(Screenshot DetailPage di sini)	(Screenshot LokasiPage di sini)
Halaman Fasilitas	Halaman Berita	Riwayat Saran
(Screenshot FasilitasPage di sini)	(Screenshot PengumumanPage di sini)	(Screenshot DaftarSaranPage di sini)
(Catatan: Ganti teks di atas dengan screenshot aplikasi Anda yang sebenarnya.)
🛠️ Teknologi dan Dependensi
Proyek ini dibangun menggunakan Flutter (versi 3.x) dan Dart. Berikut adalah daftar dependensi utama yang digunakan:
State Management: StatefulWidget & setState untuk state lokal.
Database Lokal:
sqflite: Implementasi SQLite untuk penyimpanan data persisten.
path: Helper untuk menemukan direktori database di perangkat.
Komunikasi Jaringan (API):
http: Untuk membuat HTTP request ke API eksternal.
Layanan Lokasi (GPS) & Peta:
geolocator: Untuk mengakses data GPS dari perangkat.
flutter_map: Widget untuk merender peta interaktif dari OpenStreetMap.
latlong2: Utilitas untuk mengelola data koordinat.
Interaksi Eksternal:
url_launcher: Untuk membuka URL di browser atau aplikasi eksternal (seperti Google Maps).
UI & Animasi:
flutter_staggered_animations: Untuk memberikan animasi yang elegan pada daftar dan grid.
🏗️ Arsitektur dan Alur Kerja
Aplikasi ini mengadopsi pendekatan pemisahan tanggung jawab (separation of concerns) dengan memisahkan UI, logika bisnis, dan model data.
Struktur File
code
Code

download

content_copy

expand_less
lib/
├── api_service.dart          # Logika untuk mengambil data dari API
├── app_drawer.dart           # Widget untuk Navigation Drawer
├── berita_model.dart         # Model data untuk artikel berita
├── daftar_saran_page.dart    # UI untuk menampilkan daftar saran (Read, Delete)
├── db_helper.dart            # Logika untuk interaksi database SQLite
├── detail_page.dart          # UI untuk halaman detail jurusan
├── fasilitas_page.dart       # UI untuk halaman fasilitas
├── form_saran_page.dart      # UI untuk form saran (Create, Update)
├── home_page.dart            # UI untuk halaman beranda
├── lokasi_page.dart          # UI untuk peta lokasi GPS
├── main.dart                 # Titik masuk aplikasi
├── pengumuman_api_page.dart  # UI untuk halaman berita/pengumuman
├── saran_model.dart          # Model data untuk saran
└── weather_widget.dart       # Widget UI untuk cuaca
Diagram Alur
![alt text](link_ke_gambar_flowchart_anda.png)

(Catatan: Ganti link_ke_gambar_flowchart_anda.png dengan gambar diagram alur yang telah kita buat.)
🚀 Instalasi dan Konfigurasi
Untuk menjalankan proyek ini di lingkungan lokal Anda, ikuti langkah-langkah berikut:
Prasyarat:
Pastikan Anda telah menginstal Flutter SDK.
Siapkan emulator Android atau perangkat fisik.
Clone Repositori:
code
Bash

download

content_copy

expand_less
git clone https://github.com/username/nama-repositori.git
cd nama-repositori
Dapatkan Dependensi:
code
Bash

download

content_copy

expand_less
flutter pub get
Konfigurasi API Keys:
NewsAPI: Buka file lib/api_service.dart dan ganti placeholder _apiKey dengan API Key valid dari NewsAPI.org.
OpenWeatherMap API: Buka file lib/weather_service.dart dan ganti placeholder _apiKey dengan API Key valid dari OpenWeatherMap.
Konfigurasi Izin Lokasi:
Pastikan izin lokasi telah ditambahkan di android/app/src/main/AndroidManifest.xml (untuk Android) dan ios/Runner/Info.plist (untuk iOS).
Jalankan Aplikasi:
code
Bash

download

content_copy

expand_less
flutter run
👨‍💻 Kontributor
Proyek ini dikembangkan oleh:
Nama: I Gede Wirawan
NIM: [Isi NIM Anda]
Dibuat sebagai bagian dari pemenuhan tugas Proyek Akhir Semester (UAS).
