import 'package:get/get.dart';
import 'package:task_mobel/app/domain/entity/task.dart';

class DetailController extends GetxController {
  final args = Get.arguments;
  Task? taskObject;
  Map<String, dynamic>? taskMap;

  @override
  void onInit() {
    super.onInit();

    if (args is Task) {
      taskObject = args as Task;
    } else if (args is Map<String, dynamic>) {
      taskMap = args as Map<String, dynamic>;
    }
  }
}
