import 'package:ain/app/common/constant/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/common/constant/app_colors.dart';
import 'app/common/constant/app_constant_string.dart';
import 'app/routes/app_pages.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,

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