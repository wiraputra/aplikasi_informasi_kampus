import 'dart:convert';
import 'package:http/http.dart' as http;
import 'berita_model.dart'; // Import model data yang baru

class BeritaService {
 
  final String _apiKey = "82d01ffafbaf47769bfed43253bf1808";
  
  // Endpoint untuk berita kategori 'science' (sains) dari negara Indonesia
  final String _apiUrl =
      "https://newsapi.org/v2/everything?q=pendidikan&language=id&sortBy=popularity";
      
  Future<List<Artikel>> fetchBerita() async {
    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        // NewsAPI memerlukan API Key di header
        headers: {'Authorization': _apiKey},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> articlesJson = jsonResponse['articles'];
        
        // Konversi list JSON menjadi list objek Artikel
        List<Artikel> daftarArtikel = articlesJson
            .map((item) => Artikel.fromJson(item))
            .toList();
            
        return daftarArtikel;
      } else {
        // Menampilkan pesan error 
        Map<String, dynamic> errorJson = jsonDecode(response.body);
        throw "Gagal memuat berita: ${errorJson['message']}";
      }
    } catch (e) {
      // Menangkap error koneksi atau lainnya
      throw "Terjadi kesalahan: ${e.toString()}";
    }
  }
}