import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tentang Aplikasi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Aplikasi ini adalah aplikasi Ecommerce yang memungkinkan sebuah toko untuk melakukan penjualan produknya secara online. Admin bisa menambahkan produk kemudian user bisa membeli produk tersebut.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Aplikasi ini dibuat oleh Bagus Anugrah mahasiswa semester 5 ITENAS dengan NRP 15-2022-029.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Untuk demo aplikasi bisa mengklik link berikut:',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Buka link di browser
                    const String url = 'https://youtu.be/TNRi20nQ80o';
                    openUrl(url, context);
                  },
                  child: const Text(
                    'Klik di sini untuk demo aplikasi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
