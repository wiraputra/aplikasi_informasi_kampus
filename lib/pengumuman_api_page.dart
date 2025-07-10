import 'package:flutter/material.dart';
import 'package:aplikasi_informasi_kampus/app_drawer.dart'; // Pastikan import drawer
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka link berita
import 'api_service.dart'; // Ganti nama class ApiService menjadi BeritaService
import 'berita_model.dart';

class PengumumanApiPage extends StatefulWidget {
  const PengumumanApiPage({super.key});

  @override
  State<PengumumanApiPage> createState() => _PengumumanApiPageState();
}

class _PengumumanApiPageState extends State<PengumumanApiPage> {
  late Future<List<Artikel>> _futureBerita;
  final BeritaService _beritaService = BeritaService();

  @override
  void initState() {
    super.initState();
    _futureBerita = _beritaService.fetchBerita();
  }
  
  // Method untuk membuka link berita di browser
  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka tautan: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentPage: 'Pengumuman'), // Menambahkan drawer
      appBar: AppBar(
        title: const Text("Berita Pendidikan & Sains"),
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: FutureBuilder<List<Artikel>>(
        future: _futureBerita,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Gagal memuat data.\nError: ${snapshot.error}\n\nPastikan API Key Anda valid dan koneksi internet stabil.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Artikel artikel = snapshot.data![index];
                return _buildBeritaCard(artikel);
              },
            );
          } else {
            return const Center(child: Text("Tidak ada berita yang ditemukan."));
          }
        },
      ),
    );
  }

  // Widget baru untuk kartu berita yang menarik
  Widget _buildBeritaCard(Artikel artikel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _launchURL(artikel.urlBerita),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                artikel.urlGambar,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.judul,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artikel.deskripsi,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        artikel.sumber,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue[800]),
                      ),
                      if (artikel.tanggalTerbit != null)
                        Text(
                          // Format tanggal menjadi lebih mudah dibaca
                          "${artikel.tanggalTerbit!.day}/${artikel.tanggalTerbit!.month}/${artikel.tanggalTerbit!.year}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}