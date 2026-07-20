import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_services.dart';

class SplashController extends GetxController {

  @override
  void onReady() {
    super.onReady();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = StorageService.to.getToken();


    if (token != null && token.isNotEmpty) {

      Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
    } else {
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }
}