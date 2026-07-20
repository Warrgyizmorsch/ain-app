import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/image_constant.dart';
import '../../../common/widget/button/custom_app_button.dart';
import '../../../common/widget/button/social_button.dart';
import '../../../common/widget/text_field/custom_text_field.dart';
import '../../../routes/app_pages.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Image.asset(
                  ImageConstant.signupBackground,
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
                          color: Colors.black.withValues(alpha:.15),
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
              "Create A New Account",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [

                  /// NAME
                  Obx(() => Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      TextFieldCustom(
                        controller:
                        controller.nameController,
                        hintText: "Enter Name",
                        labelText: "Name",
                        onChanged: (value) {
                          controller.validateName(
                              value ?? '');
                          return null;
                        },
                      ),
                      if (controller
                          .nameError.value.isNotEmpty)
                        Padding(
                          padding:
                          const EdgeInsets.only(
                              left: 5, top: 5),
                          child: Text(
                            controller.nameError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  )),

                  const SizedBox(height: 12),

                  /// EMAIL
                  Obx(() => Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      TextFieldCustom(
                        controller:
                        controller.emailController,
                        hintText: "Enter Email",
                        labelText: "Email",
                        onChanged: (value) {
                          controller.validateEmail(
                              value ?? '');
                          return null;
                        },
                      ),
                      if (controller
                          .emailError.value.isNotEmpty)
                        Padding(
                          padding:
                          const EdgeInsets.only(
                              left: 5, top: 5),
                          child: Text(
                            controller.emailError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  )),

                  const SizedBox(height: 12),

                  /// MOBILE
                  Obx(() => Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      TextFieldCustom(
                        controller:
                        controller.mobileController,
                        hintText:
                        "Enter Mobile Number",
                        labelText:
                        "Mobile Number",
                        prefixIcon:
                        CountryCodePicker(
                          onChanged: (country) {
                            if (country.dialCode !=
                                null) {
                              controller
                                  .selectedDialCode
                                  .value =
                              country.dialCode!;
                            }
                          },
                          initialSelection: 'IN',
                          favorite: const [
                            '+91',
                            'IN'
                          ],
                          showDropDownButton:
                          true,
                          showCountryOnly:
                          false,
                          padding:
                          EdgeInsets.zero,
                          alignLeft: false,
                          textStyle:
                          const TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w500,
                          ),
                          flagWidth: 24,
                        ),
                        onChanged: (value) {
                          controller.validateMobile(
                              value ?? '');
                          return null;
                        },
                      ),
                      if (controller.mobileError
                          .value.isNotEmpty)
                        Padding(
                          padding:
                          const EdgeInsets.only(
                              left: 5, top: 5),
                          child: Text(
                            controller
                                .mobileError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  )),

                  const SizedBox(height: 12),

                  /// PASSWORD
                  Obx(() => Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      TextFieldCustom(
                        controller: controller
                            .passwordController,
                        hintText:
                        "Enter Password",
                        labelText: "Password",
                        obscureText: true,
                        onChanged: (value) {
                          controller
                              .validatePassword(
                              value ?? '');
                          return null;
                        },
                      ),
                      if (controller.passwordError
                          .value.isNotEmpty)
                        Padding(
                          padding:
                          const EdgeInsets.only(
                              left: 5, top: 5),
                          child: Text(
                            controller
                                .passwordError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  )),

                  const SizedBox(height: 12),

                  /// CONFIRM PASSWORD
                  Obx(() => Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      TextFieldCustom(
                        controller: controller
                            .confirmPasswordController,
                        hintText:
                        "Confirm Password",
                        labelText:
                        "Confirm Password",
                        obscureText: true,
                        onChanged: (value) {
                          controller
                              .validateConfirmPassword(
                              value ?? '');
                          return null;
                        },
                      ),
                      if (controller
                          .confirmPasswordError
                          .value
                          .isNotEmpty)
                        Padding(
                          padding:
                          const EdgeInsets.only(
                              left: 5, top: 5),
                          child: Text(
                            controller
                                .confirmPasswordError
                                .value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  )),

                  const SizedBox(height: 20),

                  /// SIGNUP BUTTON
                  Obx(
                        () => AppButton(
                      title: controller
                          .isLoading.value
                          ? "PLEASE WAIT..."
                          : "SIGN UP",
                      onTap:()=> controller.signup(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12),
                        child: Text("Or"),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialButton(
                        imagePath:
                        ImageConstant.googleIcon,
                        onTap: () {},
                      ),
                      SocialButton(
                        imagePath:
                        ImageConstant.appleIcon,
                        onTap: () {},
                      ),
                      SocialButton(
                        imagePath:
                        ImageConstant.facebookIcon,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "By clicking Sign Up I have read and agree\nwith Terms Sheet & Privacy Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already Have An Account ? ",
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(
                            Routes.LOGIN,
                          );
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}