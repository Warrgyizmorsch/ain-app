import 'package:ain/app/modules/splash/controllers/splash_controller.dart';
import 'package:get/get.dart';

import '../../../services/storage_services.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<StorageService>(
          () async => await StorageService().init(),
      permanent: true,
    );
    Get.putAsync<SplashController>(
          () async =>  SplashController(),
      permanent: true,
    );


  }
}