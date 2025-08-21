// routes/ app_routes.dart
import 'package:get/route_manager.dart';
import 'package:photo_booth/routes/app_route_names.dart';
import 'package:photo_booth/ui/camera/views/ar_screen.dart';
import 'package:photo_booth/ui/camera/views/camera_screen.dart';
import 'package:photo_booth/ui/camera/views/collage_camera_screen.dart';
import 'package:photo_booth/ui/camera/views/frame_selection_screen.dart';
import 'package:photo_booth/ui/camera/views/image_screen.dart';
import 'package:photo_booth/ui/home/views/caricature_screen.dart';
import 'package:photo_booth/ui/home/views/collage_screen.dart';
import 'package:photo_booth/ui/home/views/home_screen.dart';

import 'package:photo_booth/ui/camera/views/caricature_processing_screen.dart';
import 'package:photo_booth/ui/camera/views/caricature_result_screen.dart';

class AppRoutes {
  factory AppRoutes() => _instance;

  static final AppRoutes _instance = AppRoutes._();
  AppRoutes._();

  List<GetPage<dynamic>> routes = [
    GetPage(name: AppRouteNames.home, page: () => HomeScreen()),
    GetPage(name: AppRouteNames.ar, page: () => ArScreen()),
    GetPage(name: AppRouteNames.caricature, page: () => CaricatureScreen()),
    GetPage(name: AppRouteNames.collage, page: () => CollageScreen()),
    GetPage(name: AppRouteNames.camera, page: () => CameraScreen()),
    GetPage(name: AppRouteNames.collageCamera, page: () => CollageCameraScreen()),
    GetPage(name: AppRouteNames.frame, page: () => FrameSelectionScreen()),
    GetPage(name: AppRouteNames.image, page: () => ImageScreen()),
    GetPage(name: AppRouteNames.caricatureProcessing, page: () => CaricatureProcessingScreen()),
    GetPage(name: AppRouteNames.caricatureResult, page: () => CaricatureResultScreen()),
  ];
}

// GetPage(name: AppRouteNames.caricatureProcessing, page: () => CaricatureProcessingScreen()),
// GetPage(name: AppRouteNames.caricatureResult, page: () => CaricatureResultScreen()),
// class AppRoutes {
//   factory AppRoutes() {
//     return _instance;
//   }
//   static final AppRoutes _instance = AppRoutes._();
//   AppRoutes._();
//   List<GetPage> routes = [
//     GetPage(name: AppRouteNames.home, page: () => HomeScreen()),
//     // Choose App
//     GetPage(name: AppRouteNames.ar, page: () =>  ArScreen()),
//     GetPage(
//       name: AppRouteNames.caricature,
//       page: () =>  CaricatureScreen(),
//     ),
//     GetPage(name: AppRouteNames.collage, page: () => CollageScreen()),
//     // Camera
//     GetPage(name: AppRouteNames.camera, page: () => CameraScreen()),
//     GetPage(
//       name: AppRouteNames.collageCamera,
//       page: () => CollageCameraScreen(),
//     ),
//     GetPage(
//       name: AppRouteNames.frame,
//       page: () {
//         return FrameSelectionScreen();
//       },
//     ),
//     GetPage(
//       name: AppRouteNames.image,
//       page: () {
//         return ImageScreen();
//       },
//     ),
//   ];
// }