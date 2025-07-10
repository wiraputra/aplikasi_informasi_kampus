class Artikel {
  final String judul;
  final String deskripsi;
  final String urlBerita;
  final String urlGambar;
  final String sumber;
  final DateTime? tanggalTerbit; // Menggunakan DateTime untuk fleksibilitas

  Artikel({
    required this.judul,
    required this.deskripsi,
    required this.urlBerita,
    required this.urlGambar,
    required this.sumber,
    this.tanggalTerbit,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      judul: json['title'] ?? 'Tanpa Judul',
      deskripsi: json['description'] ?? 'Tidak ada deskripsi.',
      urlBerita: json['url'] ?? '',
      urlGambar: json['urlToImage'] ?? 'https://via.placeholder.com/400x200.png?text=No+Image', // Gambar default yang lebih baik
      sumber: json['source']['name'] ?? 'Sumber Tidak Diketahui',
      tanggalTerbit: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
    );
  }
}