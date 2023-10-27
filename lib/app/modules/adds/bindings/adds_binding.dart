import 'package:get/get.dart';

import '../controllers/adds_controller.dart';

class AddsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddsController>(
      () => AddsController(),
    );
  }
}
