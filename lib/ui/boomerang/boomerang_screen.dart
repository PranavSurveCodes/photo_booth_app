import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

class BoomerangScreen extends StatefulWidget {
  const BoomerangScreen({super.key});

  @override
  State<BoomerangScreen> createState() => _BoomerangScreenState();
}

class _BoomerangScreenState extends State<BoomerangScreen> {
  CameraController? _cameraController;
  bool isRecording = false;
  bool showPreview = false;
  bool isProcessing = false;

  int recordingSecondsLeft = 0;

  XFile? recordedVideo;
  VideoPlayerController? _videoController;
  String? boomerangPath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras.first, ResolutionPreset.high);
    await _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _startRecording() async {
    recordedVideo = null;
    const int recordDuration = 3; // seconds
    recordingSecondsLeft = recordDuration;

    await _cameraController!.startVideoRecording();
    setState(() {
      isRecording = true;
    });

    // Countdown timer for recording
    for (int i = recordDuration; i > 0; i--) {
      if (!mounted) return;
      setState(() {
        recordingSecondsLeft = i;
      });
      await Future.delayed(const Duration(seconds: 1));
    }

    if (isRecording) {
      await _stopRecording();
    }
  }

  Future<void> _stopRecording() async {
    final video = await _cameraController!.stopVideoRecording();
    setState(() {
      isRecording = false;
      isProcessing = true;
      recordingSecondsLeft = 0;
    });

    await _processBoomerang(video.path);

    if (boomerangPath != null && File(boomerangPath!).existsSync()) {
      setState(() {
        showPreview = true;
        isProcessing = false;
      });
      _initVideoPlayer(boomerangPath!);
    } else {
      setState(() {
        showPreview = false;
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create boomerang")),
      );
    }
  }

  Future<void> _processBoomerang(String inputPath) async {
    final dir = await getTemporaryDirectory();
    boomerangPath =
        '${dir.path}/boomerang_${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Speed up 2x and reverse + concat for boomerang effect
    final cmd =
        '-i "$inputPath" -filter_complex "[0:v]setpts=0.5*PTS,reverse[vrev];[0:v]setpts=0.5*PTS[v];[v][vrev]concat=n=2:v=1:a=0" '
        '-c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p -an "$boomerangPath"';

    print("🎯 Running FFmpeg command: $cmd");

    final session = await FFmpegKit.execute(cmd);
    final returnCode = await session.getReturnCode();

    final logs = await session.getAllLogs();
    for (var log in logs) {
      print("FFmpeg: ${log.getMessage()}");
    }

    if (ReturnCode.isSuccess(returnCode)) {
      print("✅ Boomerang created: $boomerangPath");
    } else {
      print("❌ FFmpeg failed with code: $returnCode");
      boomerangPath = null;
    }
  }

  void _initVideoPlayer(String path) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        _videoController!.setLooping(true);
        _videoController!.play();
        setState(() {});
      });
  }

  void _shareBoomerang() {
    if (boomerangPath != null) {
      Share.shareXFiles([
        XFile(boomerangPath!),
      ], text: "Check out my boomerang!");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Boomerang")),
      body: Stack(
        children: [
          Positioned.fill(
            child:
                isProcessing
                    ? const Center(child: CircularProgressIndicator())
                    : showPreview
                    ? (_videoController != null &&
                            _videoController!.value.isInitialized)
                        ? VideoPlayer(_videoController!)
                        : const Center(child: CircularProgressIndicator())
                    : (_cameraController != null &&
                        _cameraController!.value.isInitialized)
                    ? SafeArea(
                      child: AspectRatio(
                        aspectRatio:
                            _cameraController?.value.aspectRatio ?? 9 / 16,

                        child: CameraPreview(_cameraController!),
                      ),
                    )
                    : const Center(child: CircularProgressIndicator()),
          ),

          // Countdown timer during recording
          if (isRecording)
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    recordingSecondsLeft.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!showPreview && !isProcessing)
                    FloatingActionButton(
                      backgroundColor: Colors.purple,
                      onPressed: isRecording ? _stopRecording : _startRecording,
                      child: Icon(isRecording ? Icons.stop : Icons.videocam),
                    ),
                  if (showPreview && !isProcessing) ...[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showPreview = false;
                          _videoController?.dispose();
                          _initCamera();
                        });
                      },
                      child: const Text("Retake"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _shareBoomerang,
                      child: const Text("Share"),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
