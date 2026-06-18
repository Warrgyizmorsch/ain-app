import 'package:get/get.dart';

import '../../assignments/controllers/assignments_controller.dart';
import '../../contact_us/controllers/contact_us_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ContactUsController>(() => ContactUsController());
    Get.lazyPut<AssignmentsController>(() => AssignmentsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
