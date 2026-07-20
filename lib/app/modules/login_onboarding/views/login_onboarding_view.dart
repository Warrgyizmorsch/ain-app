import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/app_colors.dart';
import '../../../common/constant/image_constant.dart';
import '../../../common/widget/button/social_button.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_onboarding_controller.dart';
// TODO: Ensure your ImageConstants import is included here

class LoginOnboardingView extends GetView<LoginOnboardingController> {
    LoginOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics:   BouncingScrollPhysics(),
          child: Padding(
            padding:   EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  SizedBox(height: 24),

                // Welcome Section
                  Text(
                  'Welcome Back 👋',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:  AppColors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                  SizedBox(height: 4),
                  Text(
                  'Login to continue your\nacademic journey',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.appBackground,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                  SizedBox(height: 8),

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

                  SizedBox(height: 10),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.LOGIN);                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:   Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                  SizedBox(height: 10),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.SIGNUP);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side:   BorderSide(color: AppColors.secondary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child:   Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                  SizedBox(height: 8),

                // Social Divider
                  Text(
                  'or continue with',
                  style: TextStyle(
                    color: AppColors.appBackground,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                  SizedBox(height: 8),

                // Social Auth Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialButton(
                      imagePath: ImageConstant.googleIcon,
                      onTap: () {},
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
                  SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }


}