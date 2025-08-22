import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraCaptureScreen extends StatefulWidget {
  final int totalShots;
  final Duration interval;
  final Function(List<XFile>) onPicturesTaken;

  const CameraCaptureScreen({
    super.key,
    required this.totalShots,
    required this.interval,
    required this.onPicturesTaken,
  });

  @override
  _CameraCaptureScreenState createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int currentShot = 0;
  List<XFile> pictures = [];
  Timer? _timer;
  bool isCapturing = false;
  int countdown = 3;

  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        await _initCameraController(cameras[selectedCameraIndex]);
      }
    } catch (e) {
      debugPrint("Error initializing cameras: $e");
    }
  }

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    // Dispose previous controller
    await _controller?.dispose();
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // Assign the future for FutureBuilder
    _initializeControllerFuture = _controller!.initialize();

    setState(() {}); // rebuild to show loading

    try {
      await _initializeControllerFuture;
      if (mounted) {
        _startCountdown();
        setState(() {}); // rebuild to show camera preview
      }
    } catch (e) {
      debugPrint("Error initializing camera controller: $e");
    }
  }

  void _switchCamera() async {
    if (cameras.length < 2) return;

    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    await _initCameraController(cameras[selectedCameraIndex]);
  }

  void _startCountdown() {
    if (isCapturing) return;
    isCapturing = true;
    setState(() => countdown = 3);

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
      if (!(_controller?.value.isInitialized ?? false)) return;

      final picture = await _controller!.takePicture();
      setState(() {
        pictures.add(picture);
        currentShot++;
      });

      if (currentShot < widget.totalShots) {
        isCapturing = false;
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
    _controller?.dispose();
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
        child: (_controller == null || _initializeControllerFuture == null)
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CameraPreview(_controller!),
                        ),
                        if (countdown > 0)
                          Center(
                            child: Text(
                              countdown.toString(),
                              style: const TextStyle(
                                fontSize: 100,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 30,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              "Shot ${currentShot + 1} / ${widget.totalShots}",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 5, color: Colors.black)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 10,
                          child: IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white, size: 30),
                            onPressed: _cancelCapture,
                          ),
                        ),
                        if (cameras.length > 1)
                          Positioned(
                            top: 20,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(Icons.cameraswitch,
                                  color: Colors.white, size: 30),
                              onPressed: _switchCamera,
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
