import 'package:flutter/material.dart';

/// Jenis-jenis latihan yang akan digunakan
enum ExerciseType {
  PushUps,
  Squats,
  DownwardDogPlank,
  JumpingJack,
  HighKnees,
}

/// Model data untuk setiap latihan
class ExerciseDataModel {
  /// Judul latihan (misal: Push Up, Squat)
  final String title;

  /// Nama file gambar atau GIF di folder assets
  final String image;

  /// Warna tema untuk kartu latihan
  final Color color;

  /// Tipe latihan berdasarkan enum ExerciseType
  final ExerciseType type;

  /// Konstruktor untuk mengisi data latihan
  ExerciseDataModel(
      this.title,
      this.image,
      this.color,
      this.type,
      );
}
