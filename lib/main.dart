import 'package:ain/app/common/constant/font_family.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/common/constant/app_colors.dart';
import 'app/common/constant/app_constant_string.dart';
import 'app/core/utils/bindlings/app_bindling.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      initialBinding: AppBinding(),

      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: FontFamily.regular,
      ),

      builder: (context, child) {
        return SafeArea(
          top: false,
          child: child ?? const SizedBox(),
        );
      },

      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}