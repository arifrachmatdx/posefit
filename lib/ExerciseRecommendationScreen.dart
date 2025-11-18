import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/Model/ExerciseDataModel.dart';
import 'package:pose_detection_realtime/ExerciseDetailScreen.dart';

class ExerciseRecommendationScreen extends StatelessWidget {
  final String category;

  const ExerciseRecommendationScreen({super.key, required this.category});

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

    return [
      ExerciseDataModel("Plank to Downward Dog", "plank.gif", const Color(0xffFD8636), ExerciseType.DownwardDogPlank),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final exercises = loadExercisesByCategory();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Latihan - $category",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseDetailScreen(exercise: ex),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Gambar latihan
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

                  // Title + Icon
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ex.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.fitness_center, size: 18, color: Colors.orange.shade700),
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
