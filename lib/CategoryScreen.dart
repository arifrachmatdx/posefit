import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/ExerciseRecommendationScreen.dart';

/// Halaman untuk memilih kategori latihan.
/// Menampilkan grid berisi beberapa kategori seperti Kebugaran, Kekuatan, dan Kelincahan.
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  /// List nama kategori latihan.
  final List<String> categories = const [
    "Kebugaran",
    "Kekuatan",
    "Kelincahan",
  ];

  /// Icon untuk masing-masing kategori.
  final List<IconData> categoryIcons = const [
    Icons.directions_run,
    Icons.fitness_center,
    Icons.sports_mma,
  ];

  /// Fungsi utama untuk membangun UI layar kategori.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// AppBar bagian atas tampilan
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: const Text(
          "Kategori Latihan",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      /// Isi layar
      body: Padding(
        padding: const EdgeInsets.all(16),

        /// Grid untuk menampilkan kategori dalam bentuk kotak-kotak
        child: GridView.builder(
          itemCount: categories.length,

          /// Mengatur grid menjadi 2 kolom
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1, // Ukuran kotak seimbang
          ),

          /// Membangun item grid per index
          itemBuilder: (context, index) {
            return GestureDetector(
              /// Aksi ketika kategori ditekan
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseRecommendationScreen(
                      category: categories[index], // Kirim kategori ke halaman berikutnya
                    ),
                  ),
                );
              },

              /// Kotak kategori dengan icon + teks
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),

                  /// Efek bayangan
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                /// Isi kotak kategori
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Icon kategori
                    Icon(
                      categoryIcons[index],
                      size: 50,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 12),

                    /// Nama kategori
                    Text(
                      categories[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
