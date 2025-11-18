import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pose_detection_realtime/HomeScreen.dart';

/// Variabel global untuk menyimpan daftar kamera yang tersedia.
late List<CameraDescription> cameras;

/// Fungsi utama aplikasi
/// - Melakukan inisialisasi binding Flutter
/// - Mengambil daftar kamera dari perangkat
/// - Menjalankan aplikasi Flutter
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

/// Widget utama aplikasi.
/// Mengatur halaman awal menjadi HomeScreen().
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

/// CustomPainter untuk menggambar titik dan garis pose pada layar.
/// - [absoluteImageSize] adalah ukuran asli gambar kamera.
/// - [poses] adalah list pose yang terdeteksi oleh ML Kit.
class PosePainter extends CustomPainter {
  PosePainter(this.absoluteImageSize, this.poses);

  final Size absoluteImageSize;
  final List<Pose> poses;

  /// Fungsi utama untuk menggambar landmark pose ke canvas.
  @override
  void paint(Canvas canvas, Size size) {

    /// Skalakan titik landmark sesuai ukuran tampilan camera preview.
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    /// Warna titik-titik pose
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    /// Warna untuk sisi kiri tubuh
    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    /// Warna untuk sisi kanan tubuh
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    /// Loop semua pose yang terdeteksi
    for (final pose in poses) {

      /// Menggambar semua titik landmark pose
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
          Offset(landmark.x * scaleX, landmark.y * scaleY),
          1,
          paint,
        );
      });

      /// Fungsi untuk menggambar garis antar dua landmark tubuh
      void paintLine(
          PoseLandmarkType type1,
          PoseLandmarkType type2,
          Paint paintType,
          ) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;

        canvas.drawLine(
          Offset(joint1.x * scaleX, joint1.y * scaleY),
          Offset(joint2.x * scaleX, joint2.y * scaleY),
          paintType,
        );
      }

      // ======================
      // MENGGAMBAR BAGIAN TUBUH
      // ======================

      /// Menggambar tangan kiri
      paintLine(
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftElbow,
        leftPaint,
      );
      paintLine(
        PoseLandmarkType.leftElbow,
        PoseLandmarkType.leftWrist,
        leftPaint,
      );

      /// Menggambar tangan kanan
      paintLine(
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightElbow,
        rightPaint,
      );
      paintLine(
        PoseLandmarkType.rightElbow,
        PoseLandmarkType.rightWrist,
        rightPaint,
      );

      /// Menggambar badan (shoulder ke hip)
      paintLine(
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftHip,
        leftPaint,
      );
      paintLine(
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightHip,
        rightPaint,
      );

      /// Menggambar kaki kiri
      paintLine(
        PoseLandmarkType.leftHip,
        PoseLandmarkType.leftKnee,
        leftPaint,
      );
      paintLine(
        PoseLandmarkType.leftKnee,
        PoseLandmarkType.leftAnkle,
        leftPaint,
      );

      /// Menggambar kaki kanan
      paintLine(
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightKnee,
        rightPaint,
      );
      paintLine(
        PoseLandmarkType.rightKnee,
        PoseLandmarkType.rightAnkle,
        rightPaint,
      );
    }
  }

  /// Menentukan apakah perlu menggambar ulang pose.
  /// Akan repaint jika ukuran gambar atau daftar pose berubah.
  @override
  bool shouldRepaint(PosePainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }
}
