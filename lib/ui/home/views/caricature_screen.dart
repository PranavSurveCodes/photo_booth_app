// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:photo_booth/ui/camera/Camera_controller/camera_controller.dart';
// // import 'package:photo_booth/ui/camera/widgets/timer_slider.dart';

// // class CaricatureScreen extends StatelessWidget {
// //   CaricatureScreen({super.key});
// //   final GetCameraController _getCameraController =
// //       Get.find<GetCameraController>();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Caricature Screen')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Obx(
// //               () => TimerSlider(
// //                 onChanged: (value) {
// //                   _getCameraController.onTimerChange(value);
// //                 },
// //                 value: _getCameraController.timerValue.value,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // } 

// // caricature_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:photo_booth/routes/app_route_names.dart';

// class CaricatureScreen extends StatelessWidget {
//   const CaricatureScreen({super.key});

//   Future<void> _pickImage(BuildContext context, ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       // Navigate to processing screen
//       Get.toNamed(
//         AppRouteNames.caricatureProcessing,
//         arguments: File(pickedFile.path),
//       );
//     }
//   }

//   void _showOptionsDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Wrap(
//             alignment: WrapAlignment.center,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text("Take Photo"),
//                 onTap: () => _pickImage(context, ImageSource.camera),
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text("Upload Photo"),
//                 onTap: () => _pickImage(context, ImageSource.gallery),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Caricature")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _showOptionsDialog(context),
//           child: const Text("Select Photo Source"),
//         ),
//       ),
//     );
//   }
// }

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

  @override
  void initState() {
    super.initState();
    _startCameraFlow();
  }

  Future<void> _startCameraFlow() async {
    await Future.delayed(Duration(milliseconds: 500)); // small delay before opening camera
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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(), // optional loading
      ),
    );
  }
}
