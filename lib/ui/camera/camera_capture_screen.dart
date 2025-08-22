import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraCaptureScreen extends StatefulWidget {
  final CameraDescription camera;
  final int totalShots;
  final Duration interval; // time between shots
  final Function(List<XFile>) onPicturesTaken;

  const CameraCaptureScreen({
    super.key,
    required this.camera,
    required this.totalShots,
    required this.interval,
    required this.onPicturesTaken,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CameraCaptureScreenState createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int currentShot = 0;
  List<XFile> pictures = [];
  Timer? _timer;
  bool isCapturing = false;
  int countdown = 3;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (mounted) {
        _startCountdown();
      }
    });
  }

  /// Countdown before each picture
  // void _startCountdown() {
  //   if (isCapturing) return;
  //   isCapturing = true;
  //   countdown = 3;

  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     if (!mounted) return;

  //     setState(() => countdown--);

  //     if (countdown == 0) {
  //       timer.cancel();
  //       await _takePicture();
  //     }
  //   });
  // }
  void _startCountdown() {
  if (isCapturing) return;
  isCapturing = true;
  setState(() {
    countdown = 3; // reset countdown every time
  });

  _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (!mounted) return;

    setState(() => countdown--);

    if (countdown == 0) {
      timer.cancel();
      await _takePicture();
    }
  });
}


  Future<void> _takePicture() async {
    try {
      final picture = await _controller.takePicture();
      setState(() {
        pictures.add(picture);
        currentShot++;
      });

      if (currentShot < widget.totalShots) {
        isCapturing = false;
        // Wait for interval, then restart countdown
        Future.delayed(widget.interval, _startCountdown);
      } else {
        _finishCapture();
      }
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  void _finishCapture() {
    _timer?.cancel();
    isCapturing = false;
    widget.onPicturesTaken(pictures);
    if (mounted) Navigator.pop(context);
  }

  void _cancelCapture() {
    _timer?.cancel();
    isCapturing = false;
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDA22FF), Color(0xFF9733EE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CameraPreview(_controller)),
        
                  // Countdown overlay
                  if (countdown > 0)
                    Center(
                      child: Text(
                        countdown.toString(),
                        style: const TextStyle(
                          fontSize: 100,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                        ),
                      ),
                    ),
        
                  // Progress text
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "Shot $currentShot / ${widget.totalShots}",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                        ),
                      ),
                    ),
                  ),
        
                  // Cancel button
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: _cancelCapture,
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
