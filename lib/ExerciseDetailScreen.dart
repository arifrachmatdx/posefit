import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/Model/ExerciseDataModel.dart';
import 'package:pose_detection_realtime/DetectionScreen.dart';

/// Halaman detail latihan.
/// Menampilkan gambar latihan, judul, deskripsi, dan tombol untuk memulai deteksi pose.
class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseDataModel exercise;

  /// Screen menerima model latihan (exercise) melalui constructor.
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// AppBar dengan judul latihan
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          exercise.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      /// Konten halaman dapat discroll (jika melebihi layar)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ----------------------------------------------------------
            // 📌 GAMBAR LATIHAN
            // ----------------------------------------------------------
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  /// Bayangan lembut untuk mempercantik tampilan gambar
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),

                /// Membuat gambar memiliki sudut rounded
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/${exercise.image}",
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ----------------------------------------------------------
            // 📌 JUDUL LATIHAN
            // ----------------------------------------------------------
            Text(
              exercise.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------------------------------------------
            // 📌 DESKRIPSI LATIHAN (Card)
            // ----------------------------------------------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Deskripsi Singkat:\nGerakan ini melatih kekuatan tubuh, meningkatkan stabilitas, dan membantu meningkatkan postur selama berolahraga.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ----------------------------------------------------------
            // 🔵 TOMBOL BESAR: MULAI DETEKSI POSE
            // ----------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  /// Navigasi ke DetectionScreen dengan membawa data latihan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Detectionscreen(
                        exerciseDataModel: exercise,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Mulai Deteksi Pose",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
