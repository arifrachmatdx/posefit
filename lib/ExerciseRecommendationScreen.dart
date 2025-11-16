import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/Model/ExerciseDataModel.dart';
import 'package:pose_detection_realtime/ExerciseDetailScreen.dart';

class ExerciseRecommendationScreen extends StatelessWidget {
  final String category;

  const ExerciseRecommendationScreen({super.key, required this.category});

  List<ExerciseDataModel> loadExercisesByCategory() {
    // Sementara dikelompokkan manual
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
      appBar: AppBar(title: Text("Latihan - $category")),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(exercises[index].title),
            leading: Image.asset("assets/${exercises[index].image}", width: 50),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseDetailScreen(
                    exercise: exercises[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
