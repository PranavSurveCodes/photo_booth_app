import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_booth/routes/app_route_names.dart';
import 'package:photo_booth/ui/camera/Camera_controller/camera_controller.dart';
import 'package:photo_booth/ui/camera/widgets/app_done_button.dart';
import 'package:photo_booth/ui/camera/widgets/photo_type_cricular_button.dart';
import 'package:photo_booth/ui/camera/widgets/timer_slider.dart';

class ArScreen extends StatelessWidget {
  ArScreen({super.key});
  final GetCameraController _cameraController = Get.put<GetCameraController>(
    GetCameraController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Photo Type"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: List<Widget>.generate(
                    _cameraController.photoTypes.length,
                    (index) {
                      final photoType = _cameraController.photoTypes[index];
                      final bool isSelected =
                          photoType ==
                          _cameraController.selectedPhotoType.value;
                      return PhotoTypeCricularButton(
                        onTap: () {
                          _cameraController.onArImageSelect(photoType);
                          // context.read<CameraBloc>().add(
                          //   PhotoTypeSelectionEvent(photoType: photoType),
                          // );
                        },
                        isSelected: isSelected,
                        photoType: photoType,
                      );
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            Obx(
              () => TimerSlider(
                onChanged: (value) {
                  _cameraController.onTimerChange(value);
                },
                value: _cameraController.timerValue.value,
              ),
            ),

            const SizedBox(height: 24),
            Obx(
              () => AppDoneButton(
                onTap:
                    _cameraController.selectedPhotoType.value != null
                        ? () {
                          Get.toNamed(AppRouteNames.camera);
                        }
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
