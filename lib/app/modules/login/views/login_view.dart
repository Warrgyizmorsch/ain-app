import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/image_constant.dart';
import '../../../common/widget/button/custom_app_button.dart';
import '../../../common/widget/button/social_button.dart';
import '../../../common/widget/text_field/custom_text_field.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';
import '../widget/forget_password_view.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
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

            const SizedBox(height: 55),

            Text(
              "Welcome Back To Your Account",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Obx(() {
                        final hasError = controller.emailError.value.isNotEmpty;

                        return Focus(
                          onFocusChange: (hasFocus) {
                            if (hasFocus &&
                                controller.filteredEmails.isNotEmpty) {
                              controller.showDropdown.value = true;
                            } else {
                              Future.delayed(
                                const Duration(milliseconds: 200),
                                () {
                                  if (Get.isRegistered<LoginController>()) {
                                    Get.find<LoginController>().showDropdown.value = false;
                                  }
                                },
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldCustom(
                                controller: controller.emailController,
                                hintText: "Enter Email",
                                labelText: "Email",
                                onChanged: (value) {
                                  controller.validateEmail(value ?? '');
                                  return null;
                                },
                              ),
                              if (hasError)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    left: 5,
                                  ),
                                  child: Text(
                                    controller.emailError.value,
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      Obx(() {
                        final hasError =
                            controller.passwordError.value.isNotEmpty;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldCustom(
                              controller: controller.passwordController,
                              hintText: "Enter Password",
                              labelText: "Password",
                              obscureText: true,
                              onChanged: (value) {
                                controller.validatePassword(value ?? '');
                                return null;
                              },
                            ),
                            if (hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 5),
                                child: Text(
                                  controller.passwordError.value,
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) {
                                controller.rememberMe.value = value ?? false;
                              },
                              activeColor: AppColors.primaryPurple,
                            ),
                          ),
                          Text(
                            "Remember Me",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Get.to(ForgotPasswordView());
                            },
                            child: Text(
                              "Forget Password?",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Obx(
                        () => AppButton(
                          title: controller.isLoading.value
                              ? "PLEASE WAIT..."
                              : "LOGIN",
                          onTap: () => controller.login(),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.lightDivider)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "Or",
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.lightDivider)),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SocialButton(
                            imagePath: ImageConstant.googleIcon,
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

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't Have An Account ? ",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.SIGNUP);
                            },
                            child: Text(
                              "SIGNUP",
                              style: TextStyle(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  Positioned(
                    top: 48,
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      if (controller.showDropdown.value &&
                          controller.filteredEmails.isNotEmpty) {
                        return Container(
                          constraints: const BoxConstraints(maxHeight: 160),
                          decoration: BoxDecoration(
                            color: AppColors.bgLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.lightDivider),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightShadow,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: controller.filteredEmails.length,
                            itemBuilder: (context, index) {
                              final String email =
                                  controller.filteredEmails[index];
                              return ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.account_circle_outlined,
                                  size: 18,
                                  color: AppColors.primaryPurple,
                                ),
                                title: Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                onTap: () {
                                  controller.selectAndFillAccount(email);
                                },
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}