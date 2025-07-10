import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'form_saran_page.dart'; // Import halaman form
import 'saran_model.dart';

class DaftarSaranPage extends StatefulWidget {
  const DaftarSaranPage({super.key});

  @override
  State<DaftarSaranPage> createState() => _DaftarSaranPageState();
}

class _DaftarSaranPageState extends State<DaftarSaranPage> {
  late Future<List<Saran>> _futureSaran;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSaran();
  }

  // Method untuk memuat atau memuat ulang data dari database
  void _loadSaran() {
    setState(() {
      _futureSaran = _dbHelper.getAllSaran();
    });
  }

  // Method untuk menghapus saran
  void _hapusSaran(int id) async {
    await _dbHelper.deleteSaran(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saran berhasil dihapus')),
    );
    _loadSaran(); // Muat ulang daftar setelah menghapus
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Saran Terkirim"),
        actions: [
          // Tombol untuk refresh daftar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSaran,
          ),
        ],
      ),
      body: FutureBuilder<List<Saran>>(
        future: _futureSaran,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final saran = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(saran.nama[0].toUpperCase()),
                    ),
                    title: Text(
                      saran.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      saran.pesan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _hapusSaran(saran.id!),
                    ),
                    // AKSI SAAT LIST TILE DI-TAP
                    onTap: () async {
                      // Navigasi ke FormSaranPage dengan membawa data 'saran'
                      // Tunggu hingga halaman edit ditutup
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormSaranPage(saran: saran),
                        ),
                      );
                      // Setelah kembali dari halaman edit, muat ulang daftar
                      _loadSaran();
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada saran yang terkirim.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}