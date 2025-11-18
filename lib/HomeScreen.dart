import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/CategoryScreen.dart';

/// Halaman utama aplikasi.
/// Menampilkan logo, judul aplikasi, subtitle, dan tombol menuju kategori latihan.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// SafeArea agar tampilan tidak tertutup notch atau status bar
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 40),

            // ----------------------------------------------------------
            // 🔥 LOGO APLIKASI
            // ----------------------------------------------------------
            Image.asset(
              "assets/logo.jpg",
              height: 120, // ukuran logo
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------------
            // ✨ JUDUL / TITLE APLIKASI
            // ----------------------------------------------------------
            const Text(
              "Top Gym AI Trainer",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 8),

            // ----------------------------------------------------------
            // ✨ SUBTITLE
            // ----------------------------------------------------------
            const Text(
              "Latihan cerdas dengan AI",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            // ----------------------------------------------------------
            // 🔶 TOMBOL KATEGORI LATIHAN (Card Besar)
            // ----------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              /// GestureDetector agar seluruh card bisa ditekan
              child: GestureDetector(
                onTap: () {
                  /// Navigasi ke halaman kategori latihan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryScreen(),
                    ),
                  );
                },

                /// Tampilan card tombol
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade400,
                        Colors.orange.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),

                    /// Efek bayangan agar tombol terlihat mengangkat
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  /// Isi tombol
                  child: const Center(
                    child: Text(
                      "Kategori Latihan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
