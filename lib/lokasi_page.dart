import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({super.key});

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  // Controller untuk memanipulasi peta secara programatik
  final MapController _mapController = MapController();

  // Koordinat statis untuk Politeknik Negeri Bali
  final LatLng pnbLocation = const LatLng(-8.7991974, 115.1618184);

  // Variabel untuk menyimpan lokasi pengguna
  LatLng? _userLocation;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _determineUserPosition();
  }

  // Method untuk mendapatkan lokasi pengguna
  Future<void> _determineUserPosition() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Layanan lokasi dimatikan. Mohon aktifkan GPS Anda.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak. Fitur lokasi tidak dapat digunakan.';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen. Aktifkan manual di pengaturan.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method untuk membuka lokasi PNB di aplikasi Google Maps
  //lokasi agar bisa diakes di hp , edit di main, bukan profile atau debug
  Future<void> _openInGoogleMaps() async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${pnbLocation.latitude},${pnbLocation.longitude}';
    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka Google Maps.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lokasi Kampus PNB"),
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: Stack(
        children: [
          // Widget Peta Utama
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: pnbLocation, // Peta dimulai dengan fokus ke PNB
              initialZoom: 16.0,
              maxZoom: 18.0,
            ),
            children: [
              // Layer untuk tile peta dari OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'id.ac.pnb.info_kampus',
              ),
              // Layer untuk menampilkan marker
              MarkerLayer(
                markers: [
                  // Marker untuk Politeknik Negeri Bali
                  Marker(
                    point: pnbLocation,
                    width: 100,
                    height: 80,
                    child: _buildMarker(
                      icon: Icons.school,
                      label: "PNB",
                      color: Colors.blue.shade800,
                    ),
                  ),
                  // Marker untuk lokasi pengguna (hanya tampil jika lokasi ditemukan)
                  if (_userLocation != null)
                    Marker(
                      point: _userLocation!,
                      width: 100,
                      height: 80,
                      child: _buildMarker(
                        icon: Icons.person_pin_circle,
                        label: "Anda",
                        color: Colors.red.shade800,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Overlay Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      "Mencari lokasi Anda...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          // Overlay untuk pesan error
          if (_errorMessage != null)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_off,
                          color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _determineUserPosition,
                        child: const Text("Coba Lagi"),
                      )
                    ],
                  ),
                ),
              ),
            ),

          // Kartu Informasi di bagian bawah
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Politeknik Negeri Bali",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_pin,
                            color: Colors.grey[600], size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "Jl. Kampus Bukit Jimbaran, Kuta Selatan, Badung, Bali",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openInGoogleMaps,
                        icon: const Icon(Icons.directions),
                        label: const Text("Buka di Google Maps"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Tombol untuk kembali ke lokasi pengguna
      floatingActionButton: FloatingActionButton(
        onPressed: _userLocation == null
            ? null // Nonaktifkan jika lokasi belum ditemukan
            : () {
                _mapController.move(_userLocation!, 16.0);
              },
        backgroundColor: _userLocation == null ? Colors.grey : Colors.blue,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  // Widget helper untuk membuat marker kustom yang menarik
  // KODE INI SUDAH DIPERBAIKI
  Widget _buildMarker(
      {required IconData icon, required String label, required Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Container untuk label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        // Spacer kecil
        const SizedBox(height: 5),

        // Container untuk Icon dengan bayangan
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Membuat bayangan berbentuk lingkaran
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 45,
          ),
        ),
      ],
    );
  }
}
