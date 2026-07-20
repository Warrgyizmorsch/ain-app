import 'package:get/get.dart';

import '../../../services/firebase_services.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
     Get.lazyPut(() =>NotificationService().init());
  }
}
