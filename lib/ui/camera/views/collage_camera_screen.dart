import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_booth/ui/camera/Camera_controller/camera_controller.dart';
import 'package:photo_booth/ui/camera/views/camera_screen.dart';
import 'package:photo_booth/ui/camera/widgets/loader_overly.dart';

class CollageCameraScreen extends StatefulWidget {
  const CollageCameraScreen({super.key});

  @override
  State<CollageCameraScreen> createState() => _CollageCameraScreenState();
}

class _CollageCameraScreenState extends State<CollageCameraScreen> {
   final GetCameraController _getCameraController =
      Get.find<GetCameraController>();
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  final int _maxImages = 2;
  int currentImage = 0;
  late OverlayEntry _loaderOverlayEntry;
  final GlobalKey _repaintKey = GlobalKey();
  late int _countdown;
  final bool _isFrontCamera = true;
  bool _isCounting = true;
  // final bool _isCapturing = false;
  final List<XFile> _images = [];
  @override
  void initState() {
    _countdown = _getCameraController.timerValue.round();
    super.initState();
    _initCamera();
    _loaderOverlayEntry = OverlayEntry(builder: (context) => LoaderOverlay());
  }

  void _startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_countdown == 0) {
        timer.cancel();
        setState(() {
          _isCounting = false;
        });
        await Future.delayed(Duration(milliseconds: 400));
        await _takePicture();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  Future<void> _takePicture() async {
    // Overlay.of(context).insert(_loaderOverlayEntry);
    final XFile picture = await _cameraController!.takePicture();
    _images.add(picture);
    if (_images.length != _maxImages) {
      setState(() {
        _countdown = _getCameraController.timerValue.value.round();
        _isCounting = true;
        _startCountdown();
      });
    } else {
      if (_images.length == _maxImages) {
        _isCounting = false;
        setState(() {
          
        });
      }
    }
  }

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      _cameraController = CameraController(
        cameras[_isFrontCamera ? 1 : 0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController?.initialize().then((value) {
        setState(() {});
        _startCountdown();
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collage Camera')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child:
              _cameraController?.value.isInitialized ?? false
                  ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Frame(
                              cameraController: _cameraController,
                              image:
                                  currentImage == 0 && _images.isNotEmpty
                                      ? _images[0]
                                      : null,
                            ),
                          ),
                          // const SizedBox(width: 16),
                          Expanded(
                            child: Frame(
                              cameraController: _cameraController,
                              image: currentImage == 1 ? _images[1] : null,
                            ),
                          ),
                        ],
                      ),
                      if (_isCounting) AnimatedCounter(countdown: _countdown),
                    ],
                  )
                  : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class Frame extends StatelessWidget {
  const Frame({super.key, this.image, this.cameraController});
  final XFile? image;
  final CameraController? cameraController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.purple.shade50, // Light purple background
        border: Border.all(color: Colors.purple, width: 2), // Purple border
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            image == null
                ? CameraPreview(cameraController!)
                : Image.file(File(image!.path), fit: BoxFit.cover),
      ),
    );
  }
}
