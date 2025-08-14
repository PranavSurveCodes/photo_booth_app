import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_booth/ui/camera/Camera_controller/camera_controller.dart';
import 'package:photo_booth/ui/camera/widgets/timer_slider.dart';

class CaricatureScreen extends StatelessWidget {
  CaricatureScreen({super.key});
  final GetCameraController _getCameraController =
      // Get.find<GetCameraController>();
      Get.put(GetCameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caricature Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => TimerSlider(
                onChanged: (value) {
                  _getCameraController.onTimerChange(value);
                },
                value: _getCameraController.timerValue.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
