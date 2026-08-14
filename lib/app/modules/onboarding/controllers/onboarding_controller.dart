import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/image_constant.dart';
import '../../../routes/app_pages.dart';
class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      image: ImageConstant.onboarding1,
      title: 'Deadlines Piling Up?',
      description:
      'Assignments, projects, and submissions\n— it can feel overwhelming. We\'re here\nto make it easier.',
    ),
    OnboardingModel(
      image: ImageConstant.onboarding2,
      title: 'Get Expert Help Anytime',
      description:
      'Connect with qualified subject experts\nand receive high-quality, plagiarism-\nfree assignments.',
    ),
    OnboardingModel(
      image: ImageConstant.onboarding3,
      title: 'Submit with Confidence',
      description:
      'On-time delivery, complete privacy,\nand results you can trust.',
    ),
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(Routes.LOGIN_ONBOARDING);
    }
  }

  void skipOnboarding() {
    Get.offAllNamed(Routes.LOGIN_ONBOARDING);
  }

  @override
  void onClose() {
    Future.delayed(const Duration(milliseconds: 400), () {
      pageController.dispose();
    });

    super.onClose();
  }
}

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}