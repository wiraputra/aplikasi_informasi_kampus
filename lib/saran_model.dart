class Saran {
  final int? id;
  final String nama;
  final String email;
  final String pesan;

  Saran({this.id, required this.nama, required this.email, required this.pesan});

  // Konversi dari objek Saran ke Map untuk disimpan di DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'pesan': pesan,
    };
  }
}