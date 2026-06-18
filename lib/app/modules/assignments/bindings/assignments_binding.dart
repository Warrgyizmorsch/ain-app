import 'package:get/get.dart';

import '../controllers/assignments_controller.dart';

class AssignmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignmentsController>(
      () => AssignmentsController(),
    );
  }
}
