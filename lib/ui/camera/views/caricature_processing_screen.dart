// // // // caricature_processing_screen.dart
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:lottie/lottie.dart';
// // import 'package:photo_booth/routes/app_route_names.dart';
// // import 'package:photo_booth/services/caricature_services.dart';

// // class CaricatureProcessingScreen extends StatefulWidget {
// //   const CaricatureProcessingScreen({super.key});

// //   @override
// //   State<CaricatureProcessingScreen> createState() =>
// //       _CaricatureProcessingScreenState();
// // }

// // class _CaricatureProcessingScreenState
// //     extends State<CaricatureProcessingScreen> {
// //   late File imageFile;
// //   final PageController _pageController = PageController();
// //   int _currentPage = 0;

// //   final List<Map<String, String>> animations = [
// //     {
// //       "file": "assets/animations/loading_caricature.json",
// //       "title": "Creating your caricature...",
// //       "subtitle": "Sit tight while we make your photo fun and quirky!"
// //     },
// //     {
// //       "file": "assets/animations/shooting_photo.json",
// //       "title": "Twisting those features...",
// //       "subtitle": "Your smile is about to get a whole lot bigger"
// //     },
// //     {
// //       "file": "assets/animations/editing_photo.json",
// //       "title": "Sketching your funny side...",
// //       "subtitle": "Just a few strokes away from hilarity"
// //     },
// //     {
// //       "file": "assets/animations/polaroid_loop.json",
// //       "title": "Adding the final touch of fun ...",
// //       "subtitle": "Almost ready... get ready to laugh!"
// //     },
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     imageFile = Get.arguments;
// //     _startProcessing();

// //     // Auto-change animations every 5 seconds with smooth transition
// //     Future.doWhile(() async {
// //       await Future.delayed(const Duration(seconds: 5));
// //       if (!mounted) return false;
// //       setState(() {
// //         _currentPage = (_currentPage + 1) % animations.length;
// //         _pageController.animateToPage(
// //           _currentPage,
// //           duration: const Duration(milliseconds: 600),
// //           curve: Curves.easeInOut,
// //         );
// //       });
// //       return true;
// //     });
// //   }

// //   Future<void> _startProcessing() async {
// //     final resultFile = await CaricatureService().generateCaricature(imageFile);

// //     if (resultFile != null) {
// //       Get.offNamed(AppRouteNames.caricatureResult, arguments: resultFile);
// //     } else {
// //       Get.snackbar("Error", "Caricature generation failed");
// //       Get.back();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.deepPurple.shade50,
// //       body: Center(
// //         child: PageView.builder(
// //           controller: _pageController,
// //           physics: const NeverScrollableScrollPhysics(),
// //           itemCount: animations.length,
// //           itemBuilder: (context, index) {
// //             final item = animations[index];
// //             return Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Center(
// //                   child: Lottie.asset(
// //                     item["file"]!,
// //                     height: MediaQuery.of(context).size.height * 0.3,
// //                     width: MediaQuery.of(context).size.width * 0.8,
// //                     fit: BoxFit.contain,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),

// //                 // Title
// //                 Text(
// //                   item["title"]!,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     fontSize:
// //                         MediaQuery.of(context).size.width * 0.05, // ~5% of width
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),

// //                 // Subtitle
// //                 Text(
// //                   item["subtitle"]!,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     fontSize:
// //                         MediaQuery.of(context).size.width * 0.04, // ~4% of width
// //                   ),
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }




// // // class CaricatureProcessingScreen extends StatefulWidget {
// // //   const CaricatureProcessingScreen({super.key});

// // //   @override
// // //   State<CaricatureProcessingScreen> createState() =>
// // //       _CaricatureProcessingScreenState();
// // // }

// // // class _CaricatureProcessingScreenState
// // //     extends State<CaricatureProcessingScreen> {
// // //   late File imageFile;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     imageFile = Get.arguments;
// // //     _startProcessing();
// // //   }

// // //   Future<void> _startProcessing() async {
// // //     final resultFile = await CaricatureService().generateCaricature(imageFile);

// // //     if (resultFile != null) {
// // //       Get.offNamed(AppRouteNames.caricatureResult, arguments: resultFile);
// // //     } else {
// // //       Get.snackbar("Error", "Caricature generation failed");
// // //       Get.back();
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.deepPurple.shade50,
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Lottie.asset('assets/animations/loading_caricature.json', height: 200),
// // //             const SizedBox(height: 20),
// // //             const Text("Creating your caricature...",
// // //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // //             const SizedBox(height: 10),
// // //             const Text("Sit tight while we make your photo fun and quirky!",
// // //                 textAlign: TextAlign.center),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // import 'dart:async';
// // // // import 'dart:io';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:lottie/lottie.dart'; // 👈 Don't forget this import
// // // // import 'package:photo_booth/routes/app_route_names.dart';

// // // // class CaricatureProcessingScreen extends StatefulWidget {
// // // //   const CaricatureProcessingScreen({super.key});

// // // //   @override
// // // //   State<CaricatureProcessingScreen> createState() => _CaricatureProcessingScreenState();
// // // // }

// // // // class _CaricatureProcessingScreenState extends State<CaricatureProcessingScreen> {
// // // //   late File imageFile;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     imageFile = Get.arguments;

// // // //     // Simulate caricature processing delay
// // // //     Future.delayed(const Duration(seconds: 5), () {
// // // //       Get.offNamed(AppRouteNames.caricatureResult, arguments: imageFile);
// // // //     });
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: Colors.deepPurple.shade50,
// // // //       body: Center(
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(24.0),
// // // //           child: Column(
// // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // //             children: [
// // // //               /// ✅ HERE IS YOUR LOTTIE ANIMATION:
// // // //               Lottie.asset(
// // // //                 'assets/animations/loading_caricature.json',
// // // //                 height: 200,
// // // //               ),
// // // //               const SizedBox(height: 20),
// // // //               Text(
// // // //                 "Creating your caricature...",
// // // //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //               ),
// // // //               const SizedBox(height: 10),
// // // //               Text(
// // // //                 "Sit tight while we make your photo fun and quirky!",
// // // //                 textAlign: TextAlign.center,
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:photo_booth/routes/app_route_names.dart';
// import 'package:photo_booth/services/caricature_services.dart';

// class CaricatureProcessingScreen extends StatefulWidget {
//   const CaricatureProcessingScreen({super.key});

//   @override
//   State<CaricatureProcessingScreen> createState() =>
//       _CaricatureProcessingScreenState();
// }

// class _CaricatureProcessingScreenState
//     extends State<CaricatureProcessingScreen> {
//   late File imageFile;
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   bool _isError = true; // ✅ Track error state

//   final List<Map<String, String>> animations = [
//     {
//       "file": "assets/animations/loading_caricature.json",
//       "title": "Creating your caricature...",
//       "subtitle": "Sit tight while we make your photo fun and quirky!"
//     },
//     {
//       "file": "assets/animations/shooting_photo.json",
//       "title": "Twisting those features...",
//       "subtitle": "Your smile is about to get a whole lot bigger"
//     },
//     {
//       "file": "assets/animations/editing_photo.json",
//       "title": "Sketching your funny side...",
//       "subtitle": "Just a few strokes away from hilarity"
//     },
//     {
//       "file": "assets/animations/polaroid_loop.json",
//       "title": "Adding the final touch of fun...",
//       "subtitle": "Almost ready... get ready to laugh!"
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     imageFile = Get.arguments;
//     _startProcessing();

//     // Auto-change animations every 3 seconds
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(seconds: 3));
//       if (!mounted || _isError) return false; // ✅ stop if error
//       setState(() {
//         _currentPage = (_currentPage + 1) % animations.length;
//         _pageController.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 600),
//           curve: Curves.easeInOut,
//         );
//       });
//       return true;
//     });
//   }

//   Future<void> _startProcessing() async {
//     final resultFile = await CaricatureService().generateCaricature(imageFile);

//     if (resultFile != null) {
//       Get.offNamed(AppRouteNames.caricatureResult, arguments: resultFile);
//     } else {
//       setState(() {
//         _isError = true; // ✅ Switch to error UI
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       body: Center(
//         child: _isError ? _buildErrorUI(context) : _buildLoadingUI(context),
//       ),
//     );
//   }

//   /// 🔹 Error Screen with Option 5 button names
//   Widget _buildErrorUI(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Lottie.asset(
//           "assets/animations/retry.json",
//           height: MediaQuery.of(context).size.height * 0.3,
//           width: MediaQuery.of(context).size.width * 0.8,
//           fit: BoxFit.contain,
//         ),
//         const SizedBox(height: 20),

//         // Title
//         Text(
//           "Oops! Something went wrong",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.05,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),

//         // Subtitle
//         Text(
//           "We couldn’t generate your caricature. Please try again!",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.04,
//           ),
//         ),
//         const SizedBox(height: 25),

//         // 🔹 Button Row: Snap Another Photo + Give It Another Try
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.camera_alt),
//               onPressed: () {
//                 Get.offNamed(AppRouteNames.caricature); // back to camera
//               },
//               label: const Text("Snap Another Photo"),
//             ),
//             const SizedBox(width: 15),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.refresh),
//               onPressed: () {
//                 setState(() {
//                   _isError = false; // remove error state
//                 });
//                 _startProcessing(); // re-call API with same image
//               },
//               label: const Text("Give It Another Try"),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   /// 🔹 Normal Loading Screen
//   Widget _buildLoadingUI(BuildContext context) {
//     return PageView.builder(
//       controller: _pageController,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: animations.length,
//       itemBuilder: (context, index) {
//         final item = animations[index];
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Lottie.asset(
//                 item["file"]!,
//                 height: MediaQuery.of(context).size.height * 0.3,
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               item["title"]!,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: MediaQuery.of(context).size.width * 0.05,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               item["subtitle"]!,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: MediaQuery.of(context).size.width * 0.04,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:photo_booth/routes/app_route_names.dart';
// import 'package:photo_booth/services/caricature_services.dart';

// class CaricatureProcessingScreen extends StatefulWidget {
//   const CaricatureProcessingScreen({super.key});

//   @override
//   State<CaricatureProcessingScreen> createState() =>
//       _CaricatureProcessingScreenState();
// }

// class _CaricatureProcessingScreenState
//     extends State<CaricatureProcessingScreen> {
//   late File imageFile;
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   bool _isError = false; // ✅ Track error state

//   final List<Map<String, String>> animations = [
//     {
//       "file": "assets/animations/loading_caricature.json",
//       "title": "Creating your caricature...",
//       "subtitle": "Sit tight while we make your photo fun and quirky!"
//     },
//     {
//       "file": "assets/animations/shooting_photo.json",
//       "title": "Twisting those features...",
//       "subtitle": "Your smile is about to get a whole lot bigger"
//     },
//     {
//       "file": "assets/animations/editing_photo.json",
//       "title": "Sketching your funny side...",
//       "subtitle": "Just a few strokes away from hilarity"
//     },
//     {
//       "file": "assets/animations/polaroid_loop.json",
//       "title": "Adding the final touch of fun...",
//       "subtitle": "Almost ready... get ready to laugh!"
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     imageFile = Get.arguments;
//     _startProcessing();

//     // Auto-change animations every 3 seconds
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(seconds: 3));
//       if (!mounted || _isError) return false; // ✅ stop if error
//       setState(() {
//         _currentPage = (_currentPage + 1) % animations.length;
//         _pageController.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 600),
//           curve: Curves.easeInOut,
//         );
//       });
//       return true;
//     });
//   }

//   Future<void> _startProcessing() async {
//     final resultFile = await CaricatureService().generateCaricature(imageFile);

//     if (resultFile != null) {
//       Get.offNamed(AppRouteNames.caricatureResult, arguments: resultFile);
//     } else {
//       setState(() {
//         _isError = true; // ✅ Switch to error UI
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       body: Center(
//         child: _isError ? _buildErrorUI(context) : _buildLoadingUI(context),
//       ),
//     );
//   }

//   /// 🔹 Error Screen with debug logs
//   // Widget _buildErrorUI(BuildContext context) {
//   //   return Column(
//   //     mainAxisAlignment: MainAxisAlignment.center,
//   //     children: [
//   //       Lottie.asset(
//   //         "assets/animations/retry.json",
//   //         height: MediaQuery.of(context).size.height * 0.3,
//   //         width: MediaQuery.of(context).size.width * 0.8,
//   //         fit: BoxFit.contain,
//   //       ),
//   //       const SizedBox(height: 20),

//   //       Text(
//   //         "Oops! Something went wrong",
//   //         textAlign: TextAlign.center,
//   //         style: TextStyle(
//   //           fontSize: MediaQuery.of(context).size.width * 0.05,
//   //           fontWeight: FontWeight.bold,
//   //         ),
//   //       ),
//   //       const SizedBox(height: 10),

//   //       Text(
//   //         "We couldn’t generate your caricature. Please try again!",
//   //         textAlign: TextAlign.center,
//   //         style: TextStyle(
//   //           fontSize: MediaQuery.of(context).size.width * 0.04,
//   //         ),
//   //       ),
//   //       const SizedBox(height: 25),

//   //       Row(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: [
//   //           ElevatedButton.icon(
//   //             style: ElevatedButton.styleFrom(
//   //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//   //               shape: RoundedRectangleBorder(
//   //                 borderRadius: BorderRadius.circular(12),
//   //               ),
//   //             ),
//   //             icon: const Icon(Icons.camera_alt),
//   //             onPressed: () {
//   //               print("📸 Snap Another Photo pressed → navigating back to camera");
//   //               Get.offNamed(AppRouteNames.caricature); // back to camera
//   //             },
//   //             label: const Text("Snap Another Photo"),
//   //           ),
//   //           const SizedBox(width: 15),
//   //           ElevatedButton.icon(
//   //             style: ElevatedButton.styleFrom(
//   //               backgroundColor: Colors.deepPurple,
//   //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//   //               shape: RoundedRectangleBorder(
//   //                 borderRadius: BorderRadius.circular(12),
//   //               ),
//   //             ),
//   //             icon: const Icon(Icons.refresh),
//   //             onPressed: () {
//   //               print("🔄 Give It Another Try pressed → retrying with same image");
//   //               setState(() {
//   //                 _isError = false; // remove error state
//   //               });
//   //               _startProcessing(); // re-call API with same image
//   //             },
//   //             label: const Text("Give It Another Try"),
//   //           ),
//   //         ],
//   //       ),
//   //     ],
//   //   );
//   // }


// /// 🔹 Error Screen with debug logs
// Widget _buildErrorUI(BuildContext context) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Lottie.asset(
//         "assets/animations/retry.json",
//         height: MediaQuery.of(context).size.height * 0.3,
//         width: MediaQuery.of(context).size.width * 0.8,
//         fit: BoxFit.contain,
//       ),
//       const SizedBox(height: 15),

//       Text(
//         "Oops! Something went wrong",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: MediaQuery.of(context).size.width * 0.05,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       const SizedBox(height: 10),

//       Text(
//         "We couldn’t generate your caricature. \n Please try again!",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: MediaQuery.of(context).size.width * 0.04,
//         ),
//       ),
//       const SizedBox(height: 25),

//       // ✅ Fixed row of equal-width buttons
//       Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.camera_alt, color: Colors.deepPurple),
//               onPressed: () {
//                 print("📸 Snap Another Photo pressed → navigating back to camera");
//                 Get.offNamed(AppRouteNames.caricature);
//               },
//               label: const Text(
//                 "Snap Another Photo",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.deepPurple), 
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.refresh, color: Colors.white),
//               onPressed: () {
//                 print("🔄 Give It Another Try pressed → retrying with same image");
//                 setState(() {
//                   _isError = false;
//                 });
//                 _startProcessing();
//               },
//               label: const Text(
//                 "Give It Another Try",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white), // ✅ white text
//               ),
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }

//   /// 🔹 Normal Loading Screen
//   Widget _buildLoadingUI(BuildContext context) {
//     return PageView.builder(
//       controller: _pageController,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: animations.length,
//       itemBuilder: (context, index) {
//         final item = animations[index];
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Lottie.asset(
//                 item["file"]!,
//                 height: MediaQuery.of(context).size.height * 0.3,
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               item["title"]!,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: MediaQuery.of(context).size.width * 0.05,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               item["subtitle"]!,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: MediaQuery.of(context).size.width * 0.04,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_booth/routes/app_route_names.dart';
import 'package:photo_booth/services/caricature_services.dart';

class CaricatureProcessingScreen extends StatefulWidget {
  const CaricatureProcessingScreen({super.key});

  @override
  State<CaricatureProcessingScreen> createState() =>
      _CaricatureProcessingScreenState();
}

class _CaricatureProcessingScreenState
    extends State<CaricatureProcessingScreen> {
  late File imageFile;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool _isError = false; // ✅ Track error state

  final List<Map<String, String>> animations = [
    {
      "file": "assets/animations/loading_caricature.json",
      "title": "Creating your caricature...",
      "subtitle": "Sit tight while we make your photo fun and quirky!"
    },
    {
      "file": "assets/animations/shooting_photo.json",
      "title": "Twisting those features...",
      "subtitle": "Your smile is about to get a whole lot bigger"
    },
    {
      "file": "assets/animations/editing_photo.json",
      "title": "Sketching your funny side...",
      "subtitle": "Just a few strokes away from hilarity"
    },
    {
      "file": "assets/animations/polaroid_loop.json",
      "title": "Adding the final touch of fun...",
      "subtitle": "Almost ready... get ready to laugh!"
    },
  ];

  @override
  void initState() {
    super.initState();
    imageFile = Get.arguments;
    _startProcessing();

    // Auto-change animations every 3 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted || _isError) return false; // ✅ stop if error
      setState(() {
        _currentPage = (_currentPage + 1) % animations.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      });
      return true;
    });
  }

  Future<void> _startProcessing() async {
    final resultFile = await CaricatureService().generateCaricature(imageFile);

    if (resultFile != null) {
      Get.offNamed(AppRouteNames.caricatureResult, arguments: resultFile);
    } else {
      setState(() {
        _isError = true; // ✅ Switch to error UI
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: _isError ? _buildErrorUI(context) : _buildLoadingUI(context),
      ),
    );
  }

  /// 🔹 Error Screen (updated with padding + scalable font + scalable icons)
  // Widget _buildErrorUI(BuildContext context) {
  //   final screenWidth = MediaQuery.of(context).size.width;

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20), // ✅ space from edges
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Lottie.asset(
  //           "assets/animations/retry.json",
  //           height: MediaQuery.of(context).size.height * 0.3,
  //           width: screenWidth * 0.8,
  //           fit: BoxFit.contain,
  //         ),
  //         const SizedBox(height: 15),

  //         Text(
  //           "Oops! Something went wrong",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: screenWidth * 0.05,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 10),

  //         Text(
  //           "We couldn’t generate your caricature. \n Please try again!",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: screenWidth * 0.04,
  //           ),
  //         ),
  //         const SizedBox(height: 25),

  //         // ✅ Equal-width buttons with padding from screen edges
  //         Row(
  //           children: [
  //             Expanded(
  //               child: ElevatedButton.icon(
  //                 style: ElevatedButton.styleFrom(
  //                   padding: const EdgeInsets.symmetric(vertical: 14),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //                 icon: Icon(
  //                   Icons.camera_alt,
  //                   color: Colors.deepPurple,
  //                   size: screenWidth * 0.06, // ✅ scalable icon
  //                 ),
  //                 onPressed: () {
  //                   print("📸 Snap Another Photo pressed → navigating back to camera");
  //                   Get.offNamed(AppRouteNames.caricature);
  //                 },
  //                 label: Text(
  //                   "Snap Another Photo",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Colors.deepPurple,
  //                     fontSize: screenWidth * 0.04, // ✅ scalable font
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: ElevatedButton.icon(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.deepPurple,
  //                   padding: const EdgeInsets.symmetric(vertical: 14),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //                 icon: Icon(
  //                   Icons.refresh,
  //                   color: Colors.white,
  //                   size: screenWidth * 0.06, // ✅ scalable icon
  //                 ),
  //                 onPressed: () {
  //                   print("🔄 Give It Another Try pressed → retrying with same image");
  //                   setState(() {
  //                     _isError = false;
  //                   });
  //                   _startProcessing();
  //                 },
  //                 label: Text(
  //                   "Give It Another Try",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: screenWidth * 0.04, // ✅ scalable font
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildErrorUI(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Scale animation relative to smaller dimension (so it fits nicely on all screens)
  final double animationSize = (screenWidth < screenHeight ? screenWidth : screenHeight) * 0.65;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ✅ Responsive animation
        SizedBox(
          width: animationSize,
          height: animationSize,
          child: Lottie.asset(
            "assets/animations/retry.json",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),

        Text(
          "Oops! Something went wrong",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Text(
          "We couldn’t generate your caricature. \nPlease try again!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
          ),
        ),
        const SizedBox(height: 30),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
            color: Colors.deepPurple,
            width: screenWidth * 0.0055, // ✅ scalable border width
          ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.deepPurple,
                  size: screenWidth * 0.055, // ✅ scalable icon
                ),
                onPressed: () {
                  Get.offNamed(AppRouteNames.caricature);
                },
                label: Text(
                  "Re-Capture",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: screenWidth * 0.055, // ✅ scalable icon
                ),
                onPressed: () {
                  setState(() {
                    _isError = false;
                  });
                  _startProcessing();
                },
                label: Text(
                  "Re-Process",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  /// 🔹 Normal Loading Screen
  Widget _buildLoadingUI(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: animations.length,
      itemBuilder: (context, index) {
        final item = animations[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                item["file"]!,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item["title"]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item["subtitle"]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
          ],
        );
      },
    );
  }
}
