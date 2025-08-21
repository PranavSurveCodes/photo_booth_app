import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_booth/routes/app_route_names.dart';
import 'package:photo_booth/ui/home/widgets/collage_frame.dart';

class CollageScreen extends StatelessWidget {
  const CollageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collage Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          children: [
            CollageOfTwoImage(
              onTap: () {
                Get.toNamed(AppRouteNames.collageCamera);
              },
            ),
            const SizedBox(height: 16),
            CollageOfThreeImage(),
            const SizedBox(height: 16),
            CollageOfFourImage(),
          ],
        ),
      ),
    );
  }
}
