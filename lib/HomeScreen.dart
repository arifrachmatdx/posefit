import 'package:flutter/material.dart';
import 'package:pose_detection_realtime/CategoryScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Top Gym AI Trainer")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Kategori Latihan"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoryScreen()),
            );
          },
        ),
      ),
    );
  }
}
