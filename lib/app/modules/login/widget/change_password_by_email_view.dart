import 'package:ain/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/app_colors.dart';
import '../../../common/constant/image_constant.dart';
import '../../../common/widget/button/custom_app_button.dart';
import '../../../common/widget/text_field/custom_text_field.dart';
import '../../../routes/app_pages.dart';

class ChangePasswordView extends GetView<LoginController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    ImageConstant.loginBackground,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: -35,
                    child: Container(
                      height: 75,
                      width: 75,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightShadow,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(ImageConstant.appLogoFull),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Create New Password",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Your new password must be different from previous used passwords.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldCustom(
                            controller: controller.newPasswordController,
                            hintText: "Enter New Password",
                            labelText: "New Password",
                            obscureText: true,
                            onChanged: (value) {
                              controller.validateNewPassword(value ?? '');
                              return null;
                            },
                          ),
                          if (controller.newPasswordError.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 5),
                              child: Text(
                                controller.newPasswordError.value,
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldCustom(
                            controller: controller.confirmPasswordController,
                            hintText: "Confirm Password",
                            labelText: "Confirm Password",
                            obscureText: true,
                            onChanged: (value) {
                              controller.validateConfirmPassword(value ?? '');
                              return null;
                            },
                          ),
                          if (controller.confirmPasswordError.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 5),
                              child: Text(
                                controller.confirmPasswordError.value,
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    Obx(
                      () => AppButton(
                        title: controller.isLoadingReset.value
                            ? "RESETTING..."
                            : "RESET PASSWORD",
                        onTap: controller.isLoadingReset.value
                            ? () {}
                            : () => controller.resetPassword(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.offAllNamed(Routes.LOGIN),
                        child: Text(
                          "Back to Login",
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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