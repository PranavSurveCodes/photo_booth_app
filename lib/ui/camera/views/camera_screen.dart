import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_booth/routes/app_route_names.dart';
import 'package:photo_booth/ui/camera/Camera_controller/camera_controller.dart';
import 'package:photo_booth/ui/camera/widgets/loader_overly.dart';
import 'package:get/get.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final GetCameraController _getCameraController = Get.find<GetCameraController >();
  CameraController? _cameraController;
  late final List<CameraDescription> cameras;
  late OverlayEntry _loaderOverlayEntry;
  final GlobalKey _repaintKey = GlobalKey();
  late int _countdown;
  bool _isFrontCamera = true;
  bool _isCounting = true;

  @override
  void initState() {
    super.initState();
    _countdown = _getCameraController.timerValue.value.round();
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

  @override
  void dispose() {
    super.dispose();
    _cameraController?.dispose();
  }

  void _initCamera() async {
    try {
      cameras = await availableCameras();
      _cameraController = CameraController(
        cameras[_isFrontCamera ? 1 : 0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      _cameraController?.initialize().then((value) {
        _startCountdown();
        setState(() {});
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _takePicture() async {
    Overlay.of(context).insert(_loaderOverlayEntry);

    final path = await saveScreenshot();

    if (path != null && mounted) {
      debugPrint('Screen Short Image is :$path');

      // context.pushNamed(AppRouteNames.frame, extra: path);
      Get.toNamed(AppRouteNames.frame,arguments: path);

      _loaderOverlayEntry.remove();
    } else {
      _loaderOverlayEntry.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null ||
        _cameraController != null && !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Picture'),
        actions: [
          IconButton(
            onPressed: () {
              _cameraController = CameraController(
                cameras[_isFrontCamera ? 0 : 1],
                ResolutionPreset.high,
                enableAudio: false,
              );
              _cameraController?.initialize().then((value) {
                setState(() {});
                _isFrontCamera = !_isFrontCamera;
              });
            },
            icon: Icon(Icons.switch_camera),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _repaintKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(_isFrontCamera ? math.pi : 0),
              child: CameraPreview(_cameraController!),
            ),
            Image.asset(
              _getCameraController.selectedPhotoType.value?.url ?? '',
              fit: BoxFit.fitWidth,
            ),
            if (_isCounting) AnimatedCounter(countdown: _countdown),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomSheet: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4,

        child: Row(mainAxisSize: MainAxisSize.max, children: []),
      ),
    );
  }

  Future<Uint8List?> capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0); // High-res
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> saveScreenshot() async {
    final pngBytes = await capturePng();
    if (pngBytes == null) return null;

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/screenshot${math.Random().nextInt(99999)}.png',
    );
    await file.writeAsBytes(pngBytes);

    debugPrint('Screenshot saved: ${file.path}');
    return file.path;
  }
}

class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({super.key, required this.countdown}); 
  final int countdown;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 700),
      transitionBuilder:
          (child, animation) => ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: FadeTransition(opacity: animation, child: child),
          ),
      child: Text(
        '$countdown',
        key: ValueKey<int>(countdown),
        style: TextStyle(
          fontSize: 100,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(blurRadius: 12, color: Colors.black54, offset: Offset(3, 3)),
          ],
        ),
      ),
    );
  }
}
