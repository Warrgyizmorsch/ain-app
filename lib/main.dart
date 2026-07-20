import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/common/constant/app_colors.dart';
import 'app/common/constant/font_family.dart';
import 'app/common/widget/no_internet/no_internet_widget.dart';
import 'app/core/utils/bindlings/app_bindling.dart';
import 'app/routes/app_pages.dart';
import 'app/services/network_services.dart';
import 'app/services/storage_services.dart';
import 'app/services/theme_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync(() => ThemeService().init());
  await Get.putAsync(() => StorageService().init());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialBinding: AppBinding(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return SafeArea(
          top: false,
          child: NoInternetWidget(
            child: child ?? const SizedBox(),
          ),
        );
      },

      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}