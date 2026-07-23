import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_services.dart';

class SplashController extends GetxController {
  final isLoading = true.obs;
  final hasToken = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    final token = StorageService.to.getToken();

    if (token != null && token.isNotEmpty) {
      hasToken.value = true;
      Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
    } else {
      hasToken.value = false;
      isLoading.value = false;
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }
}