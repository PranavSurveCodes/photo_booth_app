// caricature_processing_screen.dart
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
  int _retryCount = 0;  // Track error count

  final List<Map<String, String>> animations = [
  {
    "file": "assets/animations/loading_caricature.json",
    "title": "Magical Art Booth Is Warming Up...",
    "subtitle": "Hold tight—your creative transformation is about to begin!"
  },
  {
    "file": "assets/animations/shooting_photo_animation.json",
    "title": "Working That Smile!",
    "subtitle": "We’re capturing your spark to sketch a stellar caricature."
  },
  {
    "file": "assets/animations/editing_photo.json",
    "title": "Brushing on Personality...",
    "subtitle": "Refining every feature for a totally unique masterpiece!"
  },
  {
    "file": "assets/animations/polaroid_loop.json",
    "title": "Adding the Haha Factor!",
    "subtitle": "All set—your cheerful caricature is almost ready to shine."
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
    backgroundColor: Colors.transparent,
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFFDA22FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: _isError 
          ? _buildErrorUI(context)
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 26),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.21),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: Offset(0, 7)
                  ),
                ],
                // Blur glass effect for iOS only via BackdropFilter; for web/mobile just use opacity.
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.43,
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: animations.length,
                  itemBuilder: (context, index) {
                    final item = animations[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          item["file"]!,
                          height: MediaQuery.of(context).size.height * 0.22,
                          width: MediaQuery.of(context).size.width * 0.68,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item["title"]!,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(1, 3),
                              ),
                            ]
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          item["subtitle"]!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.88),
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    );
                  }
                ),
              ),
            ),
      ),
    ),
  );
}


  /// 🔹 Error Screen 

Widget _buildErrorUI(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final double animationSize = (screenWidth < screenHeight ? screenWidth : screenHeight) * 0.50;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Error Animation
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
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(1, 3)),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Text(
          "We couldn’t generate your caricature.\nPlease try again!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 30),

        // ✅ Only Re-Process button
        ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white.withOpacity(0.22),
    padding: EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height * 0.024,
      horizontal: 22,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.06),
    ),
    side: BorderSide(
      color: Colors.white.withOpacity(0.4),
      width: 1,
    ),
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.08),
  ),
  icon: Icon(
    Icons.refresh,
    color: Colors.white,
    size: MediaQuery.of(context).size.width * 0.07,
  ),
  label: Text(
    "Give It Another Try!",
    style: TextStyle(
      color: Colors.white,
      fontSize: MediaQuery.of(context).size.width * 0.055,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.3,
    ),
  ),
  onPressed: () {
    if (_retryCount < 2) {
      setState(() {
        _isError = false;
        _retryCount++;
      });
      _startProcessing();
    } else {
      Get.offNamed(AppRouteNames.caricature);
    }
  },
)

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
