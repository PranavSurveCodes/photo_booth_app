import 'dart:ui';

import 'package:get/get.dart';
import 'package:photo_booth/config/app_assets.dart';
import 'package:photo_booth/domain/models/photo_type.dart';

class GetCameraController extends GetxController {
  RxDouble timerValue = 3.0.obs;
  Rxn<PhotoType> selectedPhotoType = Rxn();
  Rx<Size> imageSize = Size.zero.obs;
  final List<PhotoType> _photoTypes = [
    PhotoType(AppAssets.bride, 'With Bride’s', 1),
    PhotoType(AppAssets.groom, 'With Groom’s', 2),
    PhotoType(AppAssets.couple, 'With Couple', 3),
    PhotoType(AppAssets.bridefamily, 'With Bride’s Family', 4),
    PhotoType(AppAssets.groomFamily, 'With Groom’s Family', 5),
    PhotoType(AppAssets.couple, 'With families', 6),
  ];
  List<PhotoType> get photoTypes => _photoTypes;

  void onArImageSelect(PhotoType photoType) {
    selectedPhotoType.value = photoType;
  }

  void onTimerChange(double value) {
     double snappedValue;
    if (value < 4) {
      snappedValue = 3;
    } else if (value < 7.5) {
      snappedValue = 5;
    } else if (value < 12.5) {
      snappedValue = 10;
    } else {
      snappedValue = 15;
    }
    timerValue.value = snappedValue;
  }

  void onImageSizeChange(Size size) {
    imageSize.value = size;
  }
}
