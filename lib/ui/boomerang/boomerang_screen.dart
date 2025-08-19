import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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

    // ⚡ Keep camera alive during processing, dispose later
    setState(() {
      isRecording = false;
      isProcessing = true;
      recordingSecondsLeft = 0;
    });

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

    final cmd =
        '-i "$inputPath" -filter_complex "[0:v]setpts=0.5*PTS,reverse[vrev];[0:v]setpts=0.5*PTS[v];[v][vrev]concat=n=2:v=1:a=0" '
        '-c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p -an "$boomerangPath"';

    debugPrint("🎯 Running FFmpeg command: $cmd");

    final session = await FFmpegKit.execute(cmd);
    final returnCode = await session.getReturnCode();

    final logs = await session.getAllLogs();
    for (var log in logs) {
      debugPrint("FFmpeg: ${log.getMessage()}");
    }

    if (ReturnCode.isSuccess(returnCode)) {
      debugPrint("✅ Boomerang created: $boomerangPath");

      // ⏳ Artificial delay so user can enjoy fun texts
      // You have 4 texts × 2s each = 8s total cycle
      await Future.delayed(const Duration(seconds: 8));
    } else {
      debugPrint("❌ FFmpeg failed with code: $returnCode");
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

  Future<void> _shareBoomerang() async {
    if (boomerangPath != null) {
      await Share.share(
        "Check out my boomerang!",
        sharePositionOrigin: Rect.fromLTWH(0, 0, 1, 1),
      );
    }
  }

  Future<void> _saveBoomerang() async {
    if (boomerangPath == null || !File(boomerangPath!).existsSync()) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No boomerang to save")));
      return;
    }

    try {
      // Force Downloads directory on Android
      final Directory downloadsDir = Directory(
        "/storage/emulated/0/Download/Boomerang",
      );

      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      final String fileName =
          "boomerang_${DateTime.now().millisecondsSinceEpoch}.mp4";
      final String newPath = "${downloadsDir.path}/$fileName";

      await File(boomerangPath!).copy(newPath);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🎉 Boomerang saved successfully!")),
      );
    } catch (e) {
      debugPrint("❌ Error saving boomerang: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save boomerang")));
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
                    ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SpinKitFadingCircle(color: Colors.purple, size: 60.0),
                          SizedBox(height: 20),
                          _LoadingText(), // fun animated text
                        ],
                      ),
                    )
                    : showPreview
                    ? (_videoController != null &&
                            _videoController!.value.isInitialized)
                        ? VideoPlayer(_videoController!)
                        : const Center(
                          child: SpinKitFadingCircle(
                            color: Colors.purple,
                            size: 60.0,
                          ),
                        )
                    : (_cameraController != null &&
                        _cameraController!.value.isInitialized)
                    ? SafeArea(
                      child: AspectRatio(
                        aspectRatio:
                            _cameraController?.value.aspectRatio ?? 9 / 16,
                        child: CameraPreview(_cameraController!),
                      ),
                    )
                    : const Center(
                      child: SpinKitFadingCircle(
                        color: Colors.purple,
                        size: 60.0,
                      ),
                    ),
          ),

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
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _saveBoomerang,
                      child: const Text("Save"),
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

// Animated fun text widget with random gradient texts
class _LoadingText extends StatefulWidget {
  const _LoadingText();

  @override
  State<_LoadingText> createState() => _LoadingTextState();
}

class _LoadingTextState extends State<_LoadingText> {
  final List<String> funTexts = [
    "⏪ Rewinding reality...",
    "🔄 Making your moment loop forever...",
    "🎞️ Spinning frames like a DJ...",
    "✨ Adding boomerang magic...",
    "🎥 Back, forth... back, forth...",
    "🌀 Infinite vibes loading...",
    "😎 Cool loop in progress...",
    "🎉 Doubling the fun...",
    "💫 Your moment just bounced back...",
    "🎯 Perfect rewind coming up...",
    "Adding some magic ✨",
    "Looping it back 🔄",
    "Making it boomerang 🎥",
    "Final touch-ups 🎶",
    "Hold tight, magic loading 🎩",
    "Your moment is bouncing back 🕺",
    "Boomerang-ing like a pro 🎬",
    "Hang on, it’s almost boomerang o’clock ⏰",
    "Just a few more spins 🔄",
  ];

  late List<String> randomTexts;

  @override
  void initState() {
    super.initState();
    funTexts.shuffle(); // shuffle once
    randomTexts = funTexts.take(6).toList(); // pick 6 random ones
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      repeatForever: true,
      animatedTexts:
          randomTexts
              .map(
                (text) => FadeAnimatedText(
                  text,
                  textStyle: _gradientTextStyle(),
                  duration: const Duration(seconds: 2),
                ),
              )
              .toList(),
    );
  }

  /// Gradient text style (Purple → Pink)
  TextStyle _gradientTextStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      foreground:
          Paint()
            ..shader = const LinearGradient(
              colors: [Colors.purple, Colors.pinkAccent],
            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
    );
  }
}
