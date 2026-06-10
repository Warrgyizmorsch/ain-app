import 'package:get/get.dart';

import '../controllers/login_onborading_controller.dart';

class LoginOnboradingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginOnboradingController>(
      () => LoginOnboradingController(),
    );
  }
}
