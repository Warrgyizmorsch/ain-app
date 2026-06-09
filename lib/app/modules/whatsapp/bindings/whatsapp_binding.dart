import 'package:get/get.dart';

import '../controllers/whatsapp_controller.dart';

class WhatsappBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WhatsappController>(
      () => WhatsappController(),
    );
  }
}
