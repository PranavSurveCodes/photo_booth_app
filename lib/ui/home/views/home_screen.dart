
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_booth/config/app_enums.dart';
import 'package:photo_booth/routes/app_route_names.dart';
import 'package:photo_booth/ui/boomerang/boomerang_screen.dart';
import 'package:photo_booth/ui/home/widgets/app_selection_tile.dart';
import 'collage_screen.dart';

class HomeScreen extends StatelessWidget {
  // Removed 'const' constructor due to non-const gradient field
  HomeScreen({super.key});

  // Gradient background
  final LinearGradient _backgroundGradient = const LinearGradient(
    colors: [Color(0xFF8E2DE2), Color(0xFFDA22FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24), // optional
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // LOGO placed above title
                Image.asset(
                  'assets/images/logo-removebg-preview.png', // <- ensure this path exists
                  width: 140,                // adjust as needed
                  height: 140,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Choose App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 46),
                AppSelectionTile(
                  app: ChooseApp.ar,
                  onTap: () => Get.toNamed(AppRouteNames.ar),
                ),
                const SizedBox(height: 28),
                AppSelectionTile(
                  app: ChooseApp.caricature,
                  onTap: () => Get.toNamed(AppRouteNames.caricature),
                ),
                const SizedBox(height: 28),
                AppSelectionTile(
                  app: ChooseApp.boomerang,
                  onTap: () => Get.toNamed(AppRouteNames.boomerang),
                ),
                const SizedBox(height: 28),
                AppSelectionTile(
                  app: ChooseApp.collage,
                  onTap: () => Get.toNamed(AppRouteNames.collage),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}