// caricature_screen.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_booth/routes/app_route_names.dart';

class CaricatureScreen extends StatefulWidget {
  const CaricatureScreen({super.key});

  @override
  State<CaricatureScreen> createState() => _CaricatureScreenState();
}

class _CaricatureScreenState extends State<CaricatureScreen> {
  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _startCameraFlow();
  }

  Future<void> _startCameraFlow() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState((){
      isLoading = false;
    }); // small delay before opening camera
    final XFile? capturedPhoto = await _picker.pickImage(source: ImageSource.camera);

    if (capturedPhoto != null) {
      File imageFile = File(capturedPhoto.path);

      // Navigate to caricature processing
      Get.offNamed(AppRouteNames.caricatureProcessing, arguments: imageFile);
    } else {
      // If the user cancels the camera, go back
      Get.back();
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          // colors: [Color(0xFF8E2DE2), Color(0xFFDA22FF)],
          colors: [Color(0xFF8E2DE2), Color(0xFFDA22FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isLoading? Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                strokeWidth: 5,
              ),
              const SizedBox(height: 20),
              const Text(
                "Launching Camera...",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 1.1,
                  shadows: [
                    Shadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(1, 3),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ):const SizedBox.shrink(),
    ),
  );
}
}