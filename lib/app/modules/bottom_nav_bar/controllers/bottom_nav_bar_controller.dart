
import '../../../common/constant/app_imports.dart';

import '../../contact_us/views/contact_us_view.dart';
import '../../home/views/home_view.dart';
import '../../whatsapp/views/whatsapp_view.dart';
import '../../profile/views/profile_view.dart';

class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> pages = [
    const HomeView(),
    const ContactUsView(),
    const WhatsappView(),
    const ProfileView(),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}