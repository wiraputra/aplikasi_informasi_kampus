import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  final List<Map<String, String>> jurusan = const [
    {
      "nama": "Teknologi Informasi",
      "gambar": "assets/ti.jpg",
      "deskripsi": "Fokus pada pengembangan software, jaringan, dan keamanan siber.",
      "prospek": "Software Engineer, Network Admin, IT Consultant"
    },
    {
      "nama": "Akuntansi",
      "gambar": "assets/akuntansi.jpg",
      "deskripsi": "Mempelajari prinsip akuntansi untuk sektor publik dan swasta.",
      "prospek": "Akuntan Publik, Auditor, Analis Keuangan"
    },
    {
      "nama": "Administrasi Bisnis",
      "gambar": "assets/administrasibisnis.jpg",
      "deskripsi": "Menghasilkan ahli madya unggul di bidang administrasi dan kewirausahaan.",
      "prospek": "Manajer Kantor, Staf HRD, Wirausahawan"
    },
    {
      "nama": "Pariwisata",
      "gambar": "assets/pariwisata.jpg",
      "deskripsi": "Fokus pada manajemen industri pariwisata dan perhotelan.",
      "prospek": "Manajer Hotel, Tour Planner, Event Organizer"
    },
    {
      "nama": "Teknik Sipil",
      "gambar": "assets/tekniksipil.jpg",
      "deskripsi": "Mempelajari perancangan dan pemeliharaan infrastruktur.",
      "prospek": "Kontraktor, Konsultan Proyek, Pengawas Bangunan"
    },
    // Menambahkan data baru untuk contoh
    {
      "nama": "Teknik Mesin",
      "gambar": "assets/jurusan.jpg", // Ganti dengan gambar yang sesuai
      "deskripsi": "Mengaplikasikan prinsip fisika untuk analisis dan manufaktur.",
      "prospek": "Insinyur Manufaktur, Desainer Mekanik, Quality Control"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Menggunakan CustomScrollView untuk efek AppBar yang dinamis
      body: AnimationLimiter(
        child: CustomScrollView(
          slivers: [
            // AppBar Modern yang bisa mengecil
            SliverAppBar(
              expandedHeight: 250.0,
              pinned: true,
              floating: true,
              backgroundColor: const Color(0xFF0077B6),
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  "Daftar Jurusan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/jurusan.jpg', // Gambar header utama
                      fit: BoxFit.cover,
                    ),
                    // Gradien gelap agar judul terlihat jelas
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Pengantar singkat sebelum daftar
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Text(
                  "Temukan program studi yang sesuai dengan minat dan bakat Anda di Politeknik Negeri Bali.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ),

            // Daftar Jurusan dalam bentuk SliverList
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildJurusanCard(jurusan[index]),
                      ),
                    ),
                  );
                },
                childCount: jurusan.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget baru untuk membuat kartu jurusan yang lebih menarik
  Widget _buildJurusanCard(Map<String, String> data) {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Gambar Background
            Image.asset(
              data['gambar']!,
              fit: BoxFit.cover,
              // Error handling jika gambar tidak ditemukan
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey),
            ),

            // Gradien Gelap di atas gambar
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Teks di atas gradien
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['nama']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 2.0, color: Colors.black54)
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['deskripsi']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[200],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.work, color: Colors.yellow, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Prospek: ${data['prospek']!}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.yellow,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}