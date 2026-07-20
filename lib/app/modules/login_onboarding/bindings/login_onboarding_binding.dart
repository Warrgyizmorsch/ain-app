import 'package:get/get.dart';

import '../controllers/login_onboarding_controller.dart';

class LoginOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginOnboardingController>(
      () => LoginOnboardingController(),
    );
  }
}
