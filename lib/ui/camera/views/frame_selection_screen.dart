// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:photo_booth/config/app_assets.dart';
// import 'package:photo_booth/routes/app_route_names.dart';
// import 'package:photo_booth/ui/camera/Camera_controller/camera_controller.dart';
// import 'package:photo_booth/ui/camera/widgets/app_done_button.dart';
// import 'package:photo_booth/ui/camera/widgets/loader_overly.dart';

// class FrameSelectionScreen extends StatefulWidget {
//   const FrameSelectionScreen({super.key});

//   @override
//   State<FrameSelectionScreen> createState() => _FrameSelectionScreenState();
// }

// class _FrameSelectionScreenState extends State<FrameSelectionScreen> {
//   final GetCameraController _getCameraController =
//       Get.find<GetCameraController>();
//   final List<String> framePaths = [
//     AppAssets.frame1,
//     AppAssets.frame2,
//     AppAssets.frame3,
//   ];
//   late final String imagePath;

//   int? selectedIndex;
//   final GlobalKey _repaintKey = GlobalKey();
//   late OverlayEntry _loaderOverlayEntry;
//   @override
//   void initState() {
//     imagePath = Get.arguments as String;
//     super.initState();
//     _loaderOverlayEntry = OverlayEntry(builder: (context) => LoaderOverlay());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Choose Frame"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 selectedIndex = null;
//               });
//             },
//             child: Text('Clear', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
      
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder(
//           future: getFileImageSize(File(imagePath)),
//           builder: (context, snapshort) {
//             if (snapshort.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshort.hasError) {
//               return Center(child: Text(snapshort.error.toString()));
//             } else {
//               _getCameraController.onImageSizeChange(snapshort.data!);
//               // context.read<CameraBloc>().add(
//               //   ImageSizeSetEvent(imageSize: snapshort.data!),
//               // );
//               debugPrint(
//                 'Width:${snapshort.data!.width} Height:${snapshort.data!.height}  afet devide ration ${(snapshort.data!.width / snapshort.data!.height) / 2}',
//               );
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Expanded(
//                     child: RepaintBoundary(
//                       key: _repaintKey,
//                       child: Stack(
//                         fit: StackFit.expand,
//                         // alignment: Alignment.center,
//                         children: [
//                           AspectRatio(
//                             aspectRatio:
//                                 (snapshort.data!.width / 2) /
//                                 (snapshort.data!.height / 2),
//                             child: Image.file(
//                               File(imagePath),
//                               fit: BoxFit.contain,
//                             ),
//                           ),

//                           if (selectedIndex != null)
//                             AspectRatio(
//                               aspectRatio:
//                                   (snapshort.data!.width / 2) /
//                                   (snapshort.data!.height / 2),
//                               child: Image.asset(
//                                 framePaths[selectedIndex!],
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height: 120,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: framePaths.length,
//                       separatorBuilder: (_, __) => const SizedBox(width: 16),
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () => setState(() => selectedIndex = index),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color:
//                                     selectedIndex == index
//                                         ? Colors.purple
//                                         : Colors.grey,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.asset(framePaths[index], width: 100),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   AppDoneButton(
//                     onTap: () async {
//                       if (selectedIndex != null) {
//                         Overlay.of(context).insert(_loaderOverlayEntry);
//                         final imagePath = await saveScreenshot();

//                         if (!context.mounted && imagePath != null) return;
//                         Get.toNamed(AppRouteNames.image, arguments: imagePath);
//                         _loaderOverlayEntry.remove();
//                       } else {
//                         Get.toNamed(AppRouteNames.image, arguments: imagePath);
//                       }
//                     },
//                   ),
                  

//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Future<Uint8List?> capturePng() async {
//     try {
//       RenderRepaintBoundary boundary =
//           _repaintKey.currentContext!.findRenderObject()
//               as RenderRepaintBoundary;

//       final image = await boundary.toImage(pixelRatio: 3.0); // High-res
//       ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
//       return byteData?.buffer.asUint8List();
//     } catch (e) {
//       debugPrint(e.toString());
//       return null;
//     }
//   }

//   Future<String?> saveScreenshot() async {
//     final pngBytes = await capturePng();
//     if (pngBytes == null) return null;

//     final directory = await getTemporaryDirectory();
//     final file = File(
//       '${directory.path}/screenshot${Random().nextInt(99999)}.png',
//     );
//     await file.writeAsBytes(pngBytes);

//     debugPrint('Screenshot saved: ${file.path}');
//     return file.path;
//   }

//   Future<Size> getFileImageSize(File file) async {
//     final bytes = await file.readAsBytes();
//     final codec = await instantiateImageCodec(bytes);
//     final frame = await codec.getNextFrame();
//     final image = frame.image;
//     return Size(image.width.toDouble(), image.height.toDouble());
//   }
// }
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:photo_booth/config/app_assets.dart';
import 'package:photo_booth/routes/app_route_names.dart';
import 'package:photo_booth/ui/camera/Camera_controller/camera_controller.dart';
import 'package:photo_booth/ui/camera/widgets/app_done_button.dart';
import 'package:photo_booth/ui/camera/widgets/loader_overly.dart';

class FrameSelectionScreen extends StatefulWidget {
  const FrameSelectionScreen({super.key});

  @override
  State<FrameSelectionScreen> createState() => _FrameSelectionScreenState();
}

class _FrameSelectionScreenState extends State<FrameSelectionScreen> {
  final GetCameraController _getCameraController =
      Get.find<GetCameraController>();
  final List<String> framePaths = [
    AppAssets.frame1,
    AppAssets.frame2,
    AppAssets.frame3,
  ];
  late final String imagePath;

  int? selectedIndex;
  final GlobalKey _repaintKey = GlobalKey();
  late OverlayEntry _loaderOverlayEntry;

  @override
  void initState() {
    imagePath = Get.arguments as String;
    super.initState();
    _loaderOverlayEntry = OverlayEntry(builder: (context) => LoaderOverlay());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Choose Frame",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedIndex = null;
              });
            },
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFFDA22FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: getFileImageSize(File(imagePath)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              _getCameraController.onImageSizeChange(snapshot.data!);

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RepaintBoundary(
                      key: _repaintKey,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AspectRatio(
                            aspectRatio: (snapshot.data!.width / 2) /
                                (snapshot.data!.height / 2),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.contain,
                            ),
                          ),
                          if (selectedIndex != null)
                            AspectRatio(
                              aspectRatio: (snapshot.data!.width / 2) /
                                  (snapshot.data!.height / 2),
                              child: Image.asset(
                                framePaths[selectedIndex!],
                                fit: BoxFit.contain,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: framePaths.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedIndex = index),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedIndex == index
                                    ? Colors.purple
                                    : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(framePaths[index], width: 100),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ✅ Gradient button with white text
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        if (selectedIndex != null) {
                          Overlay.of(context).insert(_loaderOverlayEntry);
                          final imagePath = await saveScreenshot();

                          if (!context.mounted && imagePath != null) return;
                          Get.toNamed(AppRouteNames.image, arguments: imagePath);
                          _loaderOverlayEntry.remove();
                        } else {
                          Get.toNamed(AppRouteNames.image, arguments: imagePath);
                        }
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                         decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8E2DE2), Color(0xFFDA22FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                        child: const Text(
                          "Done",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List?> capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);
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
      '${directory.path}/screenshot${Random().nextInt(99999)}.png',
    );
    await file.writeAsBytes(pngBytes);

    debugPrint('Screenshot saved: ${file.path}');
    return file.path;
  }

  Future<Size> getFileImageSize(File file) async {
    final bytes = await file.readAsBytes();
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    return Size(image.width.toDouble(), image.height.toDouble());
  }
}

