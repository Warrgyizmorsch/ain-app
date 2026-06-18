import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_services.dart';

class SplashController extends GetxController {

  @override
  void onReady() {
    super.onReady();
    // onReady runs safely after the splash view is rendered on screen
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    print('Splash Started');

    // Reduced for testing, change or remove as needed for production
    await Future.delayed(const Duration(seconds: 3));

    print('Delay Completed');

    // Ensure StorageService is available
    final token = StorageService.to.getToken();
    print('Token: $token');

    if (token != null && token.isNotEmpty) {
      print('Navigate Home');
      Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
    } else {
      print('Navigate Onboarding');
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }
}