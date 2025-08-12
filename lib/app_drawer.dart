import 'package:flutter/material.dart';
import 'pengumuman_api_page.dart'; // Halaman Pengumuman
import 'detail_page.dart';
import 'fasilitas_page.dart';
import 'form_saran_page.dart';
import 'home_page.dart';
import 'lokasi_page.dart';

class AppDrawer extends StatelessWidget {
  // Parameter untuk mengetahui halaman mana yang sedang aktif
  final String currentPage;

  const AppDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Header drawer yang menampilkan info akun
          _buildDrawerHeader(context),

          // Menu utama
          _buildDrawerItem(
            context: context,
            icon: Icons.home,
            text: 'Beranda',
            page: const HomePage(),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.school,
            text: 'Jurusan',
            page: const DetailPage(),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.business,
            text: 'Fasilitas',
            page: const FasilitasPage(),
          ),
          
          const Divider(thickness: 1),

          // Menu sekunder
           _buildDrawerItem(
            context: context,
            icon: Icons.campaign,
            text: 'Pengumuman',
            page: const PengumumanApiPage(),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.map_outlined,
            text: 'Lokasi Kampus',
            page: const LokasiPage(),
          ),
           _buildDrawerItem(
            context: context,
            icon: Icons.edit_note,
            text: 'Kirim Saran',
            page: const FormSaranPage(),
          ),

          const Divider(thickness: 1),

          // Menu 'Tentang'
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              Navigator.pop(context); // Tutup drawer dulu
              showAboutDialog(
                context: context,
                applicationIcon: Image.asset('assets/logo.png', height: 50),
                applicationName: 'Info PNB',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 I Gede Wirawan',
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Aplikasi ini dibuat untuk menyediakan informasi lengkap seputar Politeknik Negeri Bali.'),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat header drawer
  Widget _buildDrawerHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: const Text(
        "I Gede Wirawan",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      accountEmail: const Text("wirawanw62@gmail.com"),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person,
          size: 45,
          color: Color(0xFF0077B6),
        ),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/kampus1.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat setiap item menu
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Widget page,
  }) {
    final bool isSelected = (currentPage == text);

    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700]),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
        ),
      ),
      tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
      
      
      onTap: () {
        Navigator.pop(context); // Selalu tutup drawer terlebih dahulu

        // Navigasi ke halaman baru HANYA jika itu bukan halaman saat ini.
        // Ini mencegah pengguna menumpuk halaman yang sama berulang kali.
        if (!isSelected) {
          // Menggunakan Navigator.push agar tombol kembali muncul
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }
}