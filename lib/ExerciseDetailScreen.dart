import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/Model/ExerciseDataModel.dart';
import 'package:pose_detection_realtime/DetectionScreen.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseDataModel exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/${exercise.image}",
                height: 180,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              exercise.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Deskripsi Singkat:\nGerakan ini melatih tubuh bagian inti dan meningkatkan daya tahan.",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Mulai Deteksi Pose"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Detectionscreen(exerciseDataModel: exercise),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
