import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/DetectionScreen.dart';
import 'package:pose_detection_realtime/Model/ExerciseDataModel.dart';

class Exerciselistingscreen extends StatefulWidget {
  const Exerciselistingscreen({super.key});

  @override
  State<Exerciselistingscreen> createState() => _ExerciselistingscreenState();
}

class _ExerciselistingscreenState extends State<Exerciselistingscreen> {
  List<ExerciseDataModel> exerciseList = [];

  loadData() {
    exerciseList.add(ExerciseDataModel("Push Ups", "pushup.gif", const Color(0xff005F9C), ExerciseType.PushUps));
    exerciseList.add(ExerciseDataModel("Squats", "squat.gif", const Color(0xffDF5089), ExerciseType.Squats));
    exerciseList.add(ExerciseDataModel("Plank to Downward Dog", "plank.gif", const Color(0xffFD8636), ExerciseType.DownwardDogPlank));
    exerciseList.add(ExerciseDataModel("Jumping Jack", "jumping.gif", const Color(0xff000000), ExerciseType.JumpingJack));
    exerciseList.add(ExerciseDataModel("High Knees", "jumping.gif", Colors.deepPurple, ExerciseType.HighKnees));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Exercises')),
      body: ListView.builder(
        itemCount: exerciseList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Detectionscreen(exerciseDataModel: exerciseList[index])));
            },
            child: Container(
              decoration: BoxDecoration(
                color: exerciseList[index].color,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 150,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Text dibuat expanded agar fleksibel dan tidak overflow
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        exerciseList[index].title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
            
                  /// Gambar dibatasi ukurannya
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      'assets/${exerciseList[index].image}',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
