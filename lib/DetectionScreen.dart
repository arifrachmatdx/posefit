import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pose_detection_realtime/Model/ExerciseDataModel.dart';

import 'main.dart';

// =============================
//  SCREEN DETEKSI LATIHAN
// =============================
class Detectionscreen extends StatefulWidget {
  Detectionscreen({Key? key, required this.exerciseDataModel}) : super(key: key);

  // Model data latihan (judul, warna, gambar, tipe latihan)
  ExerciseDataModel exerciseDataModel;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Detectionscreen> {
  // Controller kamera
  dynamic controller;

  // Lock agar frame tidak diproses bersamaan
  bool isBusy = false;

  // Ukuran layar
  late Size size;

  // Timestamp proses frame terkahir (untuk batasi FPS)
  int lastProcessed = 0;

  // Pose Detector ML Kit
  late PoseDetector poseDetector;

  @override
  void initState() {
    super.initState();
    initializeCamera(); // Inisialisasi kamera + pose detector
  }

  // =============================
  // INISIALISASI KAMERA & DETECTOR
  // =============================
  initializeCamera() async {
    // Membuat pose detector
    final options = PoseDetectorOptions(mode: PoseDetectionMode.stream);
    poseDetector = PoseDetector(options: options);

    // Setup controller kamera
    controller = CameraController(
      cameras[0], // Kamera belakang
      ResolutionPreset.max,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await controller.initialize().then((_) {
      if (!mounted) return;

      // Mulai membaca stream kamera
      controller.startImageStream((image) {
        final now = DateTime.now().millisecondsSinceEpoch;

        // Batasi 1 frame tiap 100ms (±10 FPS)
        if (!isBusy && (now - lastProcessed) > 100) {
          lastProcessed = now;
          isBusy = true;
          img = image;
          doPoseEstimationOnFrame();
        }
      });
    });
  }

  // =============================
  // PROSES SETIAP FRAME
  // =============================
  dynamic _scanResults;
  CameraImage? img;

  doPoseEstimationOnFrame() async {
    var inputImage = _inputImageFromCameraImage();

    if (inputImage != null) {
      // Deteksi pose
      final List<Pose> poses = await poseDetector.processImage(inputImage);
      _scanResults = poses;

      // Jika mendeteksi 1 pose
      if (poses.isNotEmpty) {
        var pose = poses.first;

        // Cek tipe latihan
        switch (widget.exerciseDataModel.type) {
          case ExerciseType.PushUps:
            detectPushUp(pose.landmarks);
            break;
          case ExerciseType.Squats:
            detectSquat(pose.landmarks);
            break;
          case ExerciseType.DownwardDogPlank:
            detectPlankToDownwardDog(pose);
            break;
          case ExerciseType.JumpingJack:
            detectJumpingJack(pose);
            break;
          case ExerciseType.HighKnees:
            detectHighKnees(pose.landmarks);
            break;
        }
      }
    }

    setState(() => isBusy = false);
  }

  // =============================
  // DISPOSE RESOURCES
  // =============================
  @override
  void dispose() {
    controller?.dispose();
    poseDetector.close();
    super.dispose();
  }

  // =============================
  // UI / RENDER MAIN SCREEN
  // =============================
  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;

    if (controller != null) {
      // Kamera
      stackChildren.add(Positioned(
        top: 0,
        left: 0,
        width: size.width,
        height: size.height,
        child: controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        )
            : Container(),
      ));

      // Overlay pose
      stackChildren.add(Positioned(
        top: 0,
        left: 0,
        width: size.width,
        height: size.height,
        child: buildResult(),
      ));

      // Counter latihan
      stackChildren.add(Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: widget.exerciseDataModel.color,
          ),
          width: 70,
          height: 70,
          child: Center(
            child: Text(
              _getCounterText(),
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
        ),
      ));

      // Judul latihan
      stackChildren.add(Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 50, left: 20, right: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.exerciseDataModel.color,
          ),
          height: 70,
          child: Center(
            child: Text(
              widget.exerciseDataModel.title,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ));
    }

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(children: stackChildren),
      ),
    );
  }

  // Ambil teks counter sesuai jenis latihan
  String _getCounterText() {
    switch (widget.exerciseDataModel.type) {
      case ExerciseType.PushUps:
        return "$pushUpCount";
      case ExerciseType.Squats:
        return "$squatCount";
      case ExerciseType.DownwardDogPlank:
        return "$plankToDownwardDogCount";
      case ExerciseType.HighKnees:
        return "$highKneeCount";
      case ExerciseType.JumpingJack:
        return "$jumpingJackCount";
    }
  }

  // =====================================================
  // DETEKSI PUSH-UP
  // =====================================================
  int pushUpCount = 0;
  bool isLowered = false;

  void detectPushUp(Map<PoseLandmarkType, PoseLandmark> l) {
    final ls = l[PoseLandmarkType.leftShoulder];
    final rs = l[PoseLandmarkType.rightShoulder];
    final le = l[PoseLandmarkType.leftElbow];
    final re = l[PoseLandmarkType.rightElbow];
    final lw = l[PoseLandmarkType.leftWrist];
    final rw = l[PoseLandmarkType.rightWrist];
    final lh = l[PoseLandmarkType.leftHip];
    final rh = l[PoseLandmarkType.rightHip];

    if ([ls, rs, le, re, lw, rw, lh, rh].contains(null)) return;

    // Hitung sudut siku kiri & kanan
    double leftAngle = calculateAngle(ls!, le!, lw!);
    double rightAngle = calculateAngle(rs!, re!, rw!);
    double avg = (leftAngle + rightAngle) / 2;

    // Deteksi apakah tubuh lurus seperti plank
    bool inPlank =
    (calculateAngle(ls!, lh!, l[PoseLandmarkType.leftKnee]!) > 160);

    // Posisi turun
    if (avg < 90 && inPlank) {
      isLowered = true;
    }
    // Posisi naik & hitung repetisi
    else if (avg > 160 && isLowered && inPlank) {
      pushUpCount++;
      isLowered = false;
      setState(() {});
    }
  }

  // =====================================================
  // DETEKSI SQUAT
  // =====================================================
  int squatCount = 0;
  bool isSquatting = false;

  void detectSquat(Map<PoseLandmarkType, PoseLandmark> l) {
    final lh = l[PoseLandmarkType.leftHip];
    final rh = l[PoseLandmarkType.rightHip];
    final lk = l[PoseLandmarkType.leftKnee];
    final rk = l[PoseLandmarkType.rightKnee];
    final la = l[PoseLandmarkType.leftAnkle];
    final ra = l[PoseLandmarkType.rightAnkle];

    if ([lh, rh, lk, rk, la, ra].contains(null)) return;

    // Hitung sudut lutut kiri & kanan
    double leftKneeAngle = calculateAngle(lh!, lk!, la!);
    double rightKneeAngle = calculateAngle(rh!, rk!, ra!);
    double avgAngle = (leftKneeAngle + rightKneeAngle) / 2;

    // Detect squat dalam
    bool isDeep = avgAngle < 90;

    if (isDeep) {
      isSquatting = true;
    } else if (!isDeep && isSquatting) {
      squatCount++;
      isSquatting = false;
      setState(() {});
    }
  }

  // =====================================================
  // DETEKSI PLANK → DOWNWARD DOG
  // =====================================================
  int plankToDownwardDogCount = 0;
  bool isInDownwardDog = false;

  void detectPlankToDownwardDog(Pose p) {
    final lh = p.landmarks[PoseLandmarkType.leftHip];
    final rh = p.landmarks[PoseLandmarkType.rightHip];
    final ls = p.landmarks[PoseLandmarkType.leftShoulder];
    final rs = p.landmarks[PoseLandmarkType.rightShoulder];
    final la = p.landmarks[PoseLandmarkType.leftAnkle];
    final ra = p.landmarks[PoseLandmarkType.rightAnkle];

    if ([lh, rh, ls, rs, la, ra].contains(null)) return;

    // Plank: bahu & pinggul sejajar & kaki lurus
    bool isPlank = (lh!.y - ls!.y).abs() < 30 && (rh!.y - rs!.y).abs() < 30;

    // Downward dog: pinggul terangkat lebih tinggi dari bahu
    bool isDog = lh.y < ls.y && rh!.y < rs!.y;

    if (isDog && !isInDownwardDog) {
      isInDownwardDog = true;
    } else if (isPlank && isInDownwardDog) {
      plankToDownwardDogCount++;
      isInDownwardDog = false;
      setState(() {});
    }
  }

  // =====================================================
  // DETEKSI JUMPING JACK
  // =====================================================
  int jumpingJackCount = 0;
  bool isJumpingJackOpen = false;

  void detectJumpingJack(Pose p) {
    final la = p.landmarks[PoseLandmarkType.leftAnkle];
    final ra = p.landmarks[PoseLandmarkType.rightAnkle];
    final ls = p.landmarks[PoseLandmarkType.leftShoulder];
    final rs = p.landmarks[PoseLandmarkType.rightShoulder];
    final lw = p.landmarks[PoseLandmarkType.leftWrist];
    final rw = p.landmarks[PoseLandmarkType.rightWrist];

    if ([la, ra, ls, rs, lw, rw].contains(null)) return;

    double legSpread = (ra!.x - la!.x).abs();
    double shoulderWidth = (rs!.x - ls!.x).abs();
    double armHeight = (lw!.y + rw!.y) / 2;

    bool legsApart = legSpread > shoulderWidth * 1.2;
    bool armsUp = armHeight < ls!.y;

    // OPEN position
    if (legsApart && armsUp && !isJumpingJackOpen) {
      isJumpingJackOpen = true;
    }
    // CLOSE position + count
    else if (!legsApart && !armsUp && isJumpingJackOpen) {
      jumpingJackCount++;
      isJumpingJackOpen = false;
      setState(() {});
    }
  }

  // =====================================================
  // DETEKSI HIGH KNEES
  // =====================================================
  int highKneeCount = 0;
  bool leftKneeUp = false;
  bool rightKneeUp = false;

  void detectHighKnees(Map<PoseLandmarkType, PoseLandmark> l) {
    final lh = l[PoseLandmarkType.leftHip];
    final rh = l[PoseLandmarkType.rightHip];
    final lk = l[PoseLandmarkType.leftKnee];
    final rk = l[PoseLandmarkType.rightKnee];

    if ([lh, rh, lk, rk].contains(null)) return;

    double hipY = (lh!.y + rh!.y) / 2;
    double threshold = hipY - 0.15;

    // Kiri
    if (lk!.y < threshold) {
      if (!leftKneeUp) {
        leftKneeUp = true;
        highKneeCount++;
        setState(() {});
      }
    } else {
      leftKneeUp = false;
    }

    // Kanan
    if (rk!.y < threshold) {
      if (!rightKneeUp) {
        rightKneeUp = true;
        highKneeCount++;
        setState(() {});
      }
    } else {
      rightKneeUp = false;
    }
  }

  // =====================================================
  // FUNGSI UTIL (ANGLE & INPUT IMAGE)
  // =====================================================
  double calculateAngle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    double ab = distance(a, b);
    double bc = distance(b, c);
    double ac = distance(a, c);

    double angle = acos((ab * ab + bc * bc - ac * ac) / (2 * ab * bc));
    return angle * 180 / pi;
  }

  double distance(PoseLandmark p1, PoseLandmark p2) {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }

  // Konversi CameraImage → InputImage ML Kit
  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage() {
    final camera = cameras[0];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else {
      var rotationCompensation =
      _orientations[controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;

      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation =
            (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }

      rotation =
          InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(img!.format.raw);

    if (format == null) return null;

    final plane = img!.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(img!.width.toDouble(), img!.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  // =============================
  // RENDER OVERLAY POSE
  // =============================
  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return Container();
    }

    final Size imageSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );

    return CustomPaint(
      painter: PosePainter(imageSize, _scanResults),
    );
  }
}
