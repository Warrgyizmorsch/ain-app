import '../../../common/constant/app_imports.dart';
import '../../assignments/views/assignments_view.dart';
import '../../contact_us/views/contact_us_view.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';

import '../../home/controllers/home_controller.dart';

class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> pages = [
    const HomeView(),
    const ContactUsView(),
    const AssignmentsView(),
     ProfileView(),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;

    if(selectedIndex.value == 0) {
      closeHomeDrawer();
    }
  }

  void closeHomeDrawer() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().closeDrawer();
    }
  }
}