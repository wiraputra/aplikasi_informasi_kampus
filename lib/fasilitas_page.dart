import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FasilitasPage extends StatefulWidget {
  const FasilitasPage({super.key});

  @override
  State<FasilitasPage> createState() => _FasilitasPageState();
}

class _FasilitasPageState extends State<FasilitasPage> {
  int loveCount = 42; // Memberi nilai awal agar terlihat menarik

  // Data diperkaya dengan 'icon'
  final List<Map<String, dynamic>> fasilitas = const [
    {
      "nama": "Perpustakaan Modern",
      "gambar": "assets/perpustakaan.jpg",
      "deskripsi": "Koleksi ribuan buku, jurnal digital, dan ruang baca yang nyaman untuk mendukung kegiatan akademik mahasiswa.",
      "icon": Icons.local_library
    },
    {
      "nama": "Laboratorium Terpadu",
      "gambar": "assets/kampus2.jpg",
      "deskripsi": "Dilengkapi peralatan canggih untuk praktikum dan penelitian di berbagai bidang studi.",
      "icon": Icons.science
    },
    {
      "nama": "Aula Serbaguna",
      "gambar": "assets/kampus1.jpg",
      "deskripsi": "Digunakan untuk seminar, wisuda, dan berbagai acara besar kampus dengan kapasitas ratusan orang.",
      "icon": Icons.groups
    },
    {
      "nama": "Ruang Kelas AC",
      "gambar": "assets/kelas.jpg",
      "deskripsi": "Tempat perkuliahan reguler dengan fasilitas proyektor, AC, dan koneksi internet yang memadai.",
      "icon": Icons.class_
    },
    {
      "nama": "Kolam Renang Standar",
      "gambar": "assets/kolamrenang.jpg",
      "deskripsi": "Fasilitas olahraga air untuk unit kegiatan mahasiswa dan rekreasi sivitas akademika.",
      "icon": Icons.pool
    },
    {
      "nama": "Kantin Sehat",
      "gambar": "assets/kantin.jpg",
      "deskripsi": "Menyediakan berbagai pilihan makanan dan minuman yang higienis dengan harga terjangkau.",
      "icon": Icons.restaurant
    },
  ];

  // Method untuk menambah like dengan feedback visual
  void _tambahLove() {
    setState(() {
      loveCount++;
    });
    // Menampilkan SnackBar sebagai feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Terima kasih! Anda menyukai fasilitas kami ❤️"),
        backgroundColor: Colors.pinkAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Method untuk menampilkan detail dalam BottomSheet
  void _showDetailBottomSheet(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(data['gambar'], fit: BoxFit.cover, width: double.infinity, height: 250),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['nama'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data['deskripsi'],
                          style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Method untuk menampilkan gambar galeri dalam dialog
  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Menggunakan CustomScrollView untuk layout yang lebih fleksibel
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            floating: true,
            backgroundColor: const Color(0xFF0077B6),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Fasilitas Kampus"),
              background: Image.asset('assets/fasilitas.jpg', fit: BoxFit.cover),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Fasilitas Unggulan",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Grid untuk menampilkan kartu fasilitas
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: AnimationLimiter(
              child: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: _buildFasilitasCard(fasilitas[index]),
                        ),
                      ),
                    );
                  },
                  childCount: fasilitas.length,
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Galeri Kampus",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Grid untuk galeri gambar
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final imagePath = fasilitas[index]['gambar'];
                  return InkWell(
                    onTap: () => _showImageDialog(context, imagePath),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(imagePath, fit: BoxFit.cover),
                    ),
                  );
                },
                childCount: fasilitas.length,
              ),
            ),
          ),
          
          // Memberi ruang di bagian bawah agar tidak tertutup FAB
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahLove,
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.favorite),
        label: Text("Suka ($loveCount)"),
      ),
    );
  }

  // Widget baru untuk kartu fasilitas yang interaktif
  Widget _buildFasilitasCard(Map<String, dynamic> data) {
    return InkWell(
      onTap: () => _showDetailBottomSheet(context, data),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(data['gambar']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data['icon'], color: Colors.white, size: 40),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                data['nama'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}