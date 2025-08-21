// // //caricature_result_screen.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';

// class CaricatureResultScreen extends StatelessWidget {
//   const CaricatureResultScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final File imageFile = Get.arguments;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Caricature"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () async {
//               try {
//                 await Share.shareXFiles(
//                   [XFile(imageFile.path)],
//                   text: "Check out my caricature! 🎨",
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Error sharing: $e")),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: SizedBox.expand(
//         child: Image.file(
//           imageFile,
//           fit: BoxFit.cover, // fills entire width/height
//         ),
//       ),
//     );
//   }
// }

// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class CaricatureResultScreen extends StatelessWidget {
// //   const CaricatureResultScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final File imageFile = Get.arguments;

// //     return Scaffold(
// //       appBar: AppBar(title: Text("Your Caricature")),
// //       body: Center(
// //         child: Column(
// //           children: [
// //             const SizedBox(height: 20),
// //             Image.file(imageFile, height: 300),
// //             const SizedBox(height: 20),
// //             Text(
// //               "Hope you love it! Share it with your friends!",
// //               style: TextStyle(fontSize: 16),
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton.icon(
// //               onPressed: () {},
// //               icon: Icon(Icons.share),
// //               label: Text("Share"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class CaricatureResultScreen extends StatelessWidget {
  const CaricatureResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final File imageFile = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Caricature"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              try {
                // ✅ New API (v11+)
                await SharePlus.instance.share(
                  ShareParams(
                    files: [XFile(imageFile.path)],
                    text: "Check out my caricature! 🎨",
                  ),
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error sharing: $e")),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Image.file(
          imageFile,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
