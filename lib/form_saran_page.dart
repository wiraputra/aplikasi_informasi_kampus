import 'package:flutter/material.dart';
import 'daftar_saran_page.dart';
import 'db_helper.dart';
import 'saran_model.dart';

class FormSaranPage extends StatefulWidget {
  // Parameter opsional untuk menerima data saran yang akan di-update
  final Saran? saran;

  const FormSaranPage({super.key, this.saran});

  @override
  State<FormSaranPage> createState() => _FormSaranPageState();
}

class _FormSaranPageState extends State<FormSaranPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _pesanController = TextEditingController();

  // Variabel untuk menentukan apakah kita dalam mode update
  bool _isUpdateMode = false;

  @override
  void initState() {
    super.initState();
    // Cek apakah ada data saran yang dikirimkan ke halaman ini
    if (widget.saran != null) {
      _isUpdateMode = true;
      // Isi controller dengan data yang ada
      _namaController.text = widget.saran!.nama;
      _emailController.text = widget.saran!.email;
      _pesanController.text = widget.saran!.pesan;
    }
  }

  // Fungsi yang menangani 'submit' (bisa untuk create atau update)
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_isUpdateMode) {
        // Jika mode update, panggil fungsi update
        final updatedSaran = Saran(
          id: widget.saran!.id, // PENTING: sertakan id yang sama
          nama: _namaController.text,
          email: _emailController.text,
          pesan: _pesanController.text,
        );
        await DatabaseHelper().updateSaran(updatedSaran);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saran berhasil diperbarui!')),
          );
          // Kembali ke halaman daftar setelah update
          Navigator.of(context).pop(); 
        }
      } else {
        // Jika mode create, panggil fungsi insert
        final newSaran = Saran(
          nama: _namaController.text,
          email: _emailController.text,
          pesan: _pesanController.text,
        );
        await DatabaseHelper().insertSaran(newSaran);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Terima kasih, saran Anda telah terkirim!')),
          );
          // Kosongkan form setelah kirim baru
          _namaController.clear();
          _emailController.clear();
          _pesanController.clear();
          FocusScope.of(context).unfocus();
        }
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdateMode ? "Update Saran" : "Form Saran & Masukan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul form hanya muncul jika bukan mode update
              if (!_isUpdateMode)
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    "Kami menghargai masukan Anda untuk menjadikan kampus lebih baik.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Alamat Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Masukkan format email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pesanController,
                decoration: const InputDecoration(labelText: "Saran atau Masukan", border: OutlineInputBorder(), prefixIcon: Icon(Icons.message), alignLabelWithHint: true),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pesan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(_isUpdateMode ? Icons.save : Icons.send),
                label: Text(_isUpdateMode ? "Simpan Perubahan" : "Kirim Saran"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),

              if (!_isUpdateMode)
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DaftarSaranPage()),
                    );
                  },
                  icon: const Icon(Icons.history),
                  label: const Text("Lihat Riwayat Saran"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}