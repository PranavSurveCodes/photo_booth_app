
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_booth/routes/app_route_names.dart';
import 'package:photo_booth/ui/camera/Camera_controller/camera_controller.dart';
import 'package:photo_booth/ui/camera/widgets/app_done_button.dart';
import 'package:photo_booth/ui/camera/widgets/photo_type_cricular_button.dart';
import 'package:photo_booth/ui/camera/widgets/timer_slider.dart';

class ArScreen extends StatelessWidget {
  ArScreen({super.key});

  final GetCameraController _cameraController =
      Get.put<GetCameraController>(GetCameraController());

  final LinearGradient _bg = const LinearGradient(
    colors: [Color(0xFF8E2DE2), Color(0xFFDA22FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _bg),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Choose Photo Type',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 28),

                /// Photo Type Grid
                Expanded(
                  child: Obx(() {
                    final types = _cameraController.photoTypes;
                    final selected = _cameraController.selectedPhotoType.value;

                    return Container(
                      decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.10),
                        //  color: Color.fromARGB(255, 162, 71, 241),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85, // more height for text
                        ),
                        itemCount: types.length,
                        itemBuilder: (context, index) {
                          final photoType = types[index];
                          final bool isSelected = photoType == selected;

                          return _PhotoTypeCard(
                            isSelected: isSelected,
                            onTap: () =>
                                _cameraController.onArImageSelect(photoType),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// Image inside circle
                                PhotoTypeCricularButton(
                                  onTap: () => _cameraController
                                      .onArImageSelect(photoType),
                                  isSelected: isSelected,
                                  photoType: photoType,
                                ),

                                const SizedBox(height: 8),

                                /// Reactive Text Label
                                // Flexible(
                                //   child: Text(
                                //     photoType.name, // assuming photoType has a name
                                //     textAlign: TextAlign.center,
                                //     style: const TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //     maxLines: 1,
                                //     overflow: TextOverflow.ellipsis,
                                //   ),
                                // )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),

                /// Timer
                Obx(() {
                  final value = _cameraController.timerValue.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TimerSlider(
                      onChanged: _cameraController.onTimerChange,
                      value: value,
                    ),
                  );
                }),

                const SizedBox(height: 24),

                /// Done Button
                Obx(() {
                  final canProceed =
                      _cameraController.selectedPhotoType.value != null;
                  return Opacity(
                    opacity: canProceed ? 1 : 0.6,
                    child: AppDoneButton(
                      onTap: canProceed
                          ? () => Get.toNamed(AppRouteNames.camera)
                          : null,
                    ),
                  );
                }),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoTypeCard extends StatelessWidget {
  const _PhotoTypeCard({
    required this.child,
    required this.isSelected,
    required this.onTap,
  });

  final Widget child;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isSelected ? 0.20 : 0.14),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0)
                  .withOpacity(isSelected ? 0.25 : 0.15),
              blurRadius: isSelected ? 16 : 10,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(isSelected ? 0.35 : 0.20),
            width: 1.2,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
