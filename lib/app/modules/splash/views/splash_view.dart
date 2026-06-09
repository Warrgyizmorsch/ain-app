import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/image_constant.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.splashBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1,),

              // Center Content: Animated Logo and Typography
              Obx(() {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeIn,
                  opacity: controller.isAnimated.value ? 1.0 : 0.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        ImageConstant.appLogo,
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          'Expert academic support\nthat helps you achieve\nhigher grades.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Spacer(flex: 2,),
              // Bottom Area: Animated Initialization Loader
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() {
                      return AnimatedOpacity(
                        // Slightly longer duration for a cascading fade-in effect
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeInOut,
                        opacity: controller.isAnimated.value ? 1.0 : 0.0,
                        child: Column(
                          children: [
                            const CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Initializing...',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}