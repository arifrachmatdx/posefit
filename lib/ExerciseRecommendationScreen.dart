import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/Model/ExerciseDataModel.dart';
import 'package:pose_detection_realtime/ExerciseDetailScreen.dart';

/// Halaman rekomendasi latihan berdasarkan kategori.
/// Menampilkan daftar latihan yang sesuai dengan kategori yang dipilih.
class ExerciseRecommendationScreen extends StatelessWidget {
  final String category;

  /// Constructor menerima kategori dari halaman sebelumnya.
  const ExerciseRecommendationScreen({super.key, required this.category});

  /// Fungsi untuk mengambil daftar latihan sesuai kategori.
  /// Mengembalikan List<ExerciseDataModel>.
  List<ExerciseDataModel> loadExercisesByCategory() {
    if (category == "Kebugaran") {
      return [
        ExerciseDataModel("Jumping Jack", "jumping.gif", Colors.black, ExerciseType.JumpingJack),
        ExerciseDataModel("High Knees", "jumping.gif", Colors.deepPurple, ExerciseType.HighKnees),
      ];
    }

    if (category == "Kekuatan") {
      return [
        ExerciseDataModel("Push Ups", "pushup.gif", const Color(0xff005F9C), ExerciseType.PushUps),
        ExerciseDataModel("Squats", "squat.gif", const Color(0xffDF5089), ExerciseType.Squats),
      ];
    }

    // Default: kategori Kelincahan
    return [
      ExerciseDataModel("Plank to Downward Dog", "plank.gif", const Color(0xffFD8636), ExerciseType.DownwardDogPlank),
    ];
  }

  @override
  Widget build(BuildContext context) {
    /// Ambil daftar latihan berdasarkan kategori
    final exercises = loadExercisesByCategory();

    return Scaffold(
      backgroundColor: Colors.white,

      /// AppBar halaman
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Latihan - $category",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      /// Daftar latihan menggunakan ListView.builder
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];

          return GestureDetector(
            /// Ketika item latihan ditekan → masuk ke detail latihan
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseDetailScreen(exercise: ex),
                ),
              );
            },

            /// Card latihan
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,

                /// Bayangan lembut
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              /// Isi card
              child: Row(
                children: [
                  // ----------------------------------------------------------
                  // 📌 GAMBAR LATIHAN (kiri)
                  // ----------------------------------------------------------
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Image.asset(
                      "assets/${ex.image}",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // ----------------------------------------------------------
                  // 📌 TEKS: Nama Latihan + Icon Kategori
                  // ----------------------------------------------------------
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Judul latihan
                          Text(
                            ex.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// Icon dan kategori
                          Row(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 18,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // ----------------------------------------------------------
                  // ➡️ ICON PANAH KANAN
                  // ----------------------------------------------------------
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.orange),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
