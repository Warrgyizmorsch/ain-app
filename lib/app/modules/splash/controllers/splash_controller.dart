import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  // Observable boolean to trigger the animation
  var isAnimated = false.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  Future<void> startAnimation() async {
    // Wait a moment before starting the animation
    await Future.delayed(const Duration(milliseconds: 500));
    isAnimated.value = true;

    // Wait for animation to finish, then navigate to Home/Auth screen
    await Future.delayed(const Duration(milliseconds: 2500));

    // Replace with your actual route (e.g., Routes.HOME)
    Get.offNamed(Routes.ONBOARDING);
  }
}