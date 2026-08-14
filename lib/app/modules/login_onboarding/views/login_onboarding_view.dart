import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_constant_string.dart';
import '../../../common/constant/image_constant.dart';
import '../../../common/widget/button/custom_app_button.dart';
import '../../../common/widget/button/social_button.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_onboarding_controller.dart';

class LoginOnboardingView extends GetView<LoginOnboardingController> {
  const LoginOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),

                    // Welcome Section
                    Text(
                      AppStrings.welcomeBack,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Central Illustration
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.38,
                      ),
                      child: Image.asset(
                        ImageConstant.loginOnboarding3,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Login Button
                    AppButton(
                      title: AppStrings.login.toUpperCase(),
                      onTap: () {
                        Get.offAllNamed(Routes.LOGIN);
                      },
                    ),

                    const SizedBox(height: 10),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.offAllNamed(Routes.SIGNUP);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryPurple,
                          side: BorderSide(color: AppColors.primaryPurple, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppStrings.createAccount.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Social Divider
                    Text(
                      AppStrings.orContinueWith,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Social Auth Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialButton(
                          imagePath: ImageConstant.googleIcon,
                          isLoading: controller.isLoading.value,
                          onTap: () async {
                            await controller.loginWithGoogle();
                          },
                        ),

                        SocialButton(
                          imagePath: ImageConstant.appleIcon,
                          onTap: () {},
                        ),

                        SocialButton(
                          imagePath: ImageConstant.facebookIcon,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
          if (controller.isLoading.value)
            Container(
              color: Colors.black.withValues(alpha: 0.2),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
        ],
      ),
    ));
  }
}