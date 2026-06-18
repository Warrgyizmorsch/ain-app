import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section: Top background graphic with centered circular logo
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
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      ImageConstant.appLogo,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 55),

            const Text(
              "Welcome Back To Your Account",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              // Parent Stack to manage Z-index overlay rendering properly
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  // Main Form Elements Layout Column
                  Column(
                    children: [

                      /// EMAIL INPUT FIELD
                      Obx(() {
                        final hasError = controller.emailError.value.isNotEmpty;

                        return Focus(
                          onFocusChange: (hasFocus) {
                            if (hasFocus && controller.filteredEmails.isNotEmpty) {
                              controller.showDropdown.value = true;
                            } else {
                              Future.delayed(const Duration(milliseconds: 200), () {
                                controller.showDropdown.value = false;
                              });
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
                                  padding: const EdgeInsets.only(top: 5, left: 5),
                                  child: Text(
                                    controller.emailError.value,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      /// PASSWORD INPUT FIELD
                      Obx(() {
                        final hasError = controller.passwordError.value.isNotEmpty;

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
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),

                      const SizedBox(height: 10),

                      /// REMEMBER ME CHECKBOX ROW
                      Row(
                        children: [
                          Obx(
                                () => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) {
                                controller.rememberMe.value = value ?? false;
                              },
                            ),
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(fontSize: 12),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Get.to(ForgotPasswordView());
                            },
                            child: const Text(
                              "Forget Password?",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// LOGIN ACTION BUTTON
                      Obx(
                            () => AppButton(
                          title: controller.isLoading.value
                              ? "PLEASE WAIT..."
                              : "LOGIN",
                          onTap:()=> controller.login(context),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Or"),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// SOCIAL MEDIA CONNECTIONS
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

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't Have An Account ? ",
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.SIGNUP);
                            },
                            child: const Text(
                              "SIGNUP",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  // ─── FLOATING OVERLAY DROPDOWN MENU LIST ───────────────────
                  // FIXED: Positioned is now a direct child of the Stack.
                  // Obx is placed inside the child parameter to handle state shifts safely.
                  Positioned(
                    top: 48, // Floats overlay directly over content fields below it
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      if (controller.showDropdown.value && controller.filteredEmails.isNotEmpty) {
                        return Container(
                          constraints: const BoxConstraints(maxHeight: 160),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
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
                              final String email = controller.filteredEmails[index];
                              return ListTile(
                                dense: true,
                                leading: const Icon(
                                  Icons.account_circle_outlined,
                                  size: 18,
                                  color: Colors.deepPurple,
                                ),
                                title: Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
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
    );
  }
}