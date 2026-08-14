import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/common/constant/font_family.dart';
import 'app/common/widget/no_internet/no_internet_widget.dart';
import 'app/core/utils/bindlings/app_bindling.dart';
import 'app/routes/app_pages.dart';
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
    return Obx(() {
      final themeService = ThemeService.to;
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,

        initialBinding: AppBinding(),
        theme: ThemeData(
          fontFamily: FontFamily.regular,
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF6F5F5),
          cardColor: const Color(0xFFFAFAFA),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            hintStyle: const TextStyle(color: Color(0xFFBDC3C7), fontFamily: FontFamily.regular),
            labelStyle: const TextStyle(color: Color(0xFF8892A4), fontFamily: FontFamily.regular),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E6F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E6F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF4A148C), width: 1.5),
            ),
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: FontFamily.regular,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1A1A24),
          cardColor: const Color(0xFF1E1E1E),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            hintStyle: const TextStyle(color: Color(0xFF5B626A), fontFamily: FontFamily.regular),
            labelStyle: const TextStyle(color: Color(0xFFAAB4C3), fontFamily: FontFamily.regular),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2D3243)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2D3243)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF6A1B9A), width: 1.5),
            ),
          ),
        ),
        themeMode: themeService.themeMode,
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
    });
  }
}