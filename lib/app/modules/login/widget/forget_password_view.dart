import 'package:ain/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/image_constant.dart';
import '../../../common/widget/button/custom_app_button.dart';
import '../../../common/widget/text_field/custom_text_field.dart';

class ForgotPasswordView extends GetView<LoginController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section (Same as LoginView)
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
                    child: Image.asset(ImageConstant.appLogo),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Reset Your Password",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Enter your email address and we will send you instructions to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  /// EMAIL INPUT FIELD
                  Obx(() => Column(
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
                      if (controller.emailError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 5),
                          child: Text(
                            controller.emailError.value,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  )),

                  const SizedBox(height: 30),

                  /// RESET ACTION BUTTON
                  Obx(() => AppButton(
                    title: controller.isLoading.value ? "SENDING..." : "SEND INSTRUCTIONS",
                    onTap: controller.sendResetLink,
                  ),),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Back to Login"),
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