import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/ExerciseRecommendationScreen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final categories = const [
    "Kebugaran",
    "Kekuatan",
    "Kelincahan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kategori Latihan")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseRecommendationScreen(
                    category: categories[index],
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
