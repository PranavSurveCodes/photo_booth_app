import 'dart:io';
import 'dart:math';
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
  bool useFront = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> switchCamera(bool useFrontCam) async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(
      useFrontCam ? frontCamera : cameras.first,
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    if (mounted) setState(() {});
    useFront = useFrontCam;
    // setState(() {
    //   useFront = useFront;
    // });
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

    // setState(() {
    //   isRecording = false;
    //   isProcessing = true;
    //   recordingSecondsLeft = 0;
    // });

    await _processBoomerang(video.path);

    if (boomerangPath != null && File(boomerangPath!).existsSync()) {
      if (!mounted) return;
      setState(() {
        showPreview = true;
        isProcessing = false;
      });
      _initVideoPlayer(boomerangPath!);
    } else {
      if (!mounted) return;
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

      // ❗ Short artificial delay for fun loading texts
      await Future.delayed(const Duration(seconds: 2));
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

  Future<bool> _onWillPop() async {
    if (showPreview) {
      final result = await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierLabel: "Discard Boomerang",
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation1, animation2) {
          return Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Discard Boomerang?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Going back will discard your boomerang preview.",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        // Discard button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF9B3DEB),
                                Color(0xFF6A00E0),
                              ], // Purple → Violet
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              "Discard",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation1, animation2, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation1, curve: Curves.easeOut),
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation1,
                curve: Curves.easeOutBack,
              ),
              child: child,
            ),
          );
        },
      );

      return result ?? false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final canExit = await _onWillPop();
          if (canExit && mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Boomerang",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final shouldLeave = await _onWillPop();
              if (!mounted) return;
              if (shouldLeave) Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.cameraswitch),
              onPressed: () {
                switchCamera(useFront);
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Purple → Violet
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              // Camera / Preview / Processing loader
              Positioned.fill(
                child:
                    isProcessing
                        ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BoomerangLoader(), // <-- our new loader
                              SizedBox(height: 20),
                              _LoadingText(), // gradient text below loader
                            ],
                          ),
                        )
                        : showPreview
                        ? (_videoController != null &&
                                _videoController!.value.isInitialized)
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: VideoPlayer(_videoController!),
                            )
                            : const Center(child: BoomerangLoader())
                        : (_cameraController != null &&
                            _cameraController!.value.isInitialized)
                        ? SafeArea(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: AspectRatio(
                              aspectRatio:
                                  _cameraController?.value.aspectRatio ??
                                  9 / 16,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        )
                        : const Center(child: BoomerangLoader()),
              ),

              // Recording countdown
              if (isRecording)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 80,
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

              // Action buttons
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!showPreview && !isProcessing)
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                            ),
                            onPressed:
                                isRecording ? _stopRecording : _startRecording,
                            child: Icon(
                              isRecording ? Icons.stop : Icons.videocam,
                              size: 28,
                            ),
                          ),
                        ),

                      if (showPreview && !isProcessing) ...[
                        _buildActionButton("Retake", Icons.refresh, () {
                          setState(() {
                            showPreview = false;
                            _videoController?.dispose();
                            _initCamera();
                          });
                        }),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          "Share",
                          Icons.share,
                          _shareBoomerang,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔘 Common styled button
  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Purple → Violet
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }
}

// Animated fun text widget with gradient texts
class _LoadingText extends StatefulWidget {
  const _LoadingText();

  @override
  State<_LoadingText> createState() => _LoadingTextState();
}

class BoomerangLoader extends StatefulWidget {
  const BoomerangLoader({super.key});

  @override
  State<BoomerangLoader> createState() => _BoomerangLoaderState();
}

class _BoomerangLoaderState extends State<BoomerangLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildArrow(double angle) {
    return Transform.rotate(
      angle: angle,
      child: Align(
        alignment: Alignment.topCenter,
        child: Icon(Icons.loop_rounded, size: 20, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing camera icon in center
          ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.2).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: Icon(
              Icons.camera_alt_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
          // Multiple rotating arrows around camera
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double rotation = _controller.value * 2 * 3.1415926;
              return Stack(
                children: List.generate(6, (index) {
                  double angle = rotation + index * (3.1415926 / 3);
                  return _buildArrow(angle);
                }),
              );
            },
          ),
          // Sparkles around
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double t = _controller.value * 2 * 3.1415926;
              return Stack(
                children: List.generate(5, (i) {
                  double angle = i * (2 * 3.1415926 / 5) + t;
                  double radius = 60;
                  return Positioned(
                    left: 60 + radius * cos(angle),
                    top: 60 + radius * sin(angle),
                    child: Icon(Icons.star, size: 8, color: Colors.white70),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
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
    funTexts.shuffle();
    randomTexts = funTexts.take(3).toList();
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

  /// Softer gradient (White → LightPink) for visibility on purple bg
  TextStyle _gradientTextStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      foreground:
          Paint()
            ..shader = const LinearGradient(
              colors: [Colors.white, Color(0xFFFFB6C1)], // White → Light Pink
            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
    );
  }
}
