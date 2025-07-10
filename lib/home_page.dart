import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'app_drawer.dart';
import 'pengumuman_api_page.dart'; // <-- PERBAIKAN 1: Import halaman yang benar
import 'detail_page.dart';
import 'fasilitas_page.dart';
import 'lokasi_page.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: const AppDrawer(currentPage: 'Beranda'), //mengetahui posisi halaman di drawer
      body: AnimationLimiter(
        child: CustomScrollView(
          slivers: [
            // AppBar yang bisa mengecil saat di-scroll
            _buildSliverAppBar(),
            
            // Konten utama dengan padding
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      // Sambutan
                      _buildWelcomeText(),
                      const SizedBox(height: 24),
                      
                      // Menu Akses Cepat
                      _buildQuickAccessMenu(context),
                      const SizedBox(height: 24),
                      
                      // Judul Section
                      _buildSectionTitle("Tentang Kampus"),
                      const SizedBox(height: 16),
                      
                      // Kartu Informasi PNB
                      _buildCampusInfoCard(),
                      const SizedBox(height: 24),
                      
                      _buildSectionTitle("Informasi Penting"),
                      const SizedBox(height: 16),
                      
                      // Info Visi, Misi, dll. dalam bentuk baru
                      _buildInfoItem(
                          icon: Icons.visibility,
                          title: "Visi",
                          content: "Menjadi institusi pendidikan tinggi vokasi yang unggul, inovatif dan berdaya saing global.",
                          color: Colors.orange),
                      _buildInfoItem(
                          icon: Icons.flag,
                          title: "Misi",
                          content: "- Menyelenggarakan pendidikan vokasi berkualitas\n- Meningkatkan penelitian terapan\n- Membangun kemitraan industri",
                          color: Colors.green),
                      _buildInfoItem(
                          icon: Icons.verified,
                          title: "Akreditasi",
                          content: "Terakreditasi Unggul oleh BAN-PT.",
                          color: Colors.purple),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk AppBar
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      snap: false,
      backgroundColor: const Color(0xFF0077B6),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "Info PNB",
          style: TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/kampus1.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF0077B6)),
          ),
        ),
      ],
    );
  }

  // Widget untuk Teks Sambutan
  Widget _buildWelcomeText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selamat Datang,",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003566),
          ),
        ),
        Text(
          "I Gede Wirawan",
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ],
    );
  }

  // Widget untuk Menu Akses Cepat
  Widget _buildQuickAccessMenu(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildMenuItem(
            context, Icons.school, "Jurusan", () => _navigateTo(context, const DetailPage())),
        _buildMenuItem(
            context, Icons.build, "Fasilitas", () => _navigateTo(context, const FasilitasPage())),
        _buildMenuItem(
            context, Icons.map, "Lokasi", () => _navigateTo(context, const LokasiPage())),
        // PERBAIKAN 2: Ganti pemanggilan widget di sini
        _buildMenuItem(
            context, Icons.newspaper, "Berita", () => _navigateTo(context, const PengumumanApiPage())),
      ],
    );
  }
  
  // Helper untuk item menu
  Widget _buildMenuItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color(0xFF0077B6)),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Widget untuk Judul Section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  // Widget untuk Kartu Info Kampus
  Widget _buildCampusInfoCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Text(
              "Politeknik Negeri Bali (PNB)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 8),
            Text(
              "PNB adalah institusi pendidikan tinggi vokasi unggulan di Bali yang berkomitmen dalam menghasilkan lulusan kompeten dan siap kerja.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget untuk item Visi, Misi, dll.
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk Navigasi
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}