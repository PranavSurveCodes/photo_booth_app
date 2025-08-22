// caricature_result_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';

class CaricatureResultScreen extends StatelessWidget {
  const CaricatureResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final File imageFile = Get.arguments;
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    // Responsive sizes
    final double frameWidth = w * 0.86;
    final double frameHeight = h * 0.67;
    final double borderRadius = w * 0.06;
    final double borderWidth = w * 0.008;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your Caricature",
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.07,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: Container(
        width: w,
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFFDA22FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // Use a Column with Spacer widgets to perfectly center the frame
        child: Column(
          children: [
            // Add spacing to account for the AppBar height plus extra space
            SizedBox(height: kToolbarHeight + h * 0.045),
            // Center the frame horizontally
            Center(
              child: Container(
                width: frameWidth,
                height: frameHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.75),
                    width: borderWidth,
                  ),
                  color: Colors.white.withOpacity(0.06),
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                    width: frameWidth,
                    height: frameHeight,
                  ),
                ),
              ),
            ),
            SizedBox(height: h * 0.07),
            // Responsive Share Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.08),
              child: GestureDetector(
                onTap: () async {
                  try {
                    await SharePlus.instance.share(
                      ShareParams(
                        files: [XFile(imageFile.path)],
                        text: "Check out my caricature! 🎨",
                      ),
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to share: $e")),
                      );
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: h * 0.024,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white,
                        size: w * 0.07,
                      ),
                      SizedBox(width: w * 0.03),
                      Text(
                        "Share Your Caricature",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.055,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add flexible spacer below to keep everything centered
            Expanded(child: SizedBox())
          ],
        ),
      ),
    );
  }
}
