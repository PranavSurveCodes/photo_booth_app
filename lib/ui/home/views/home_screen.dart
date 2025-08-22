import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_booth/config/app_enums.dart';
import 'package:photo_booth/routes/app_route_names.dart';
import 'package:photo_booth/ui/home/widgets/app_selection_tile.dart';
import 'collage_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose App'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppSelectionTile(
            app: ChooseApp.ar,
            onTap: () {
              Get.toNamed(AppRouteNames.ar);
            },
          ),
          AppSelectionTile(
            app: ChooseApp.caricature,
            onTap: () {
              Get.toNamed(AppRouteNames.caricature);
            },
          ),
          AppSelectionTile(app: ChooseApp.boomerang, onTap: () {}),
          AppSelectionTile(
            app: ChooseApp.collage,
            onTap: () {
              Get.toNamed(AppRouteNames.collage);
            },
          ),
        ],
      ),
    );
  }
}

