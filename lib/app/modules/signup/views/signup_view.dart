import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/app_colors.dart';
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
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.appBackground,
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
                            color: AppColors.lightShadow,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        ImageConstant.appLogoFull,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 55),

              Text(
                "Create A New Account",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    /// NAME
                    Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldCustom(
                          controller: controller.nameController,
                          hintText: "Enter Name",
                          labelText: "Name",
                          onChanged: (value) {
                            controller.validateName(value ?? '');
                            return null;
                          },
                        ),
                        if (controller.nameError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Text(
                              controller.nameError.value,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    )),

                    const SizedBox(height: 12),

                    /// EMAIL
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
                        if (controller.emailError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Text(
                              controller.emailError.value,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    )),

                    const SizedBox(height: 12),

                    /// MOBILE
                    Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldCustom(
                          controller: controller.mobileController,
                          hintText: "Enter Mobile Number",
                          labelText: "Mobile Number",
                          prefixIcon: CountryCodePicker(
                            onChanged: (country) {
                              if (country.dialCode != null) {
                                controller.selectedDialCode.value =
                                    country.dialCode!;
                              }
                            },
                            initialSelection: 'IN',
                            favorite: const ['+91', 'IN'],
                            showDropDownButton: true,
                            showCountryOnly: false,
                            padding: EdgeInsets.zero,
                            alignLeft: false,
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            dialogTextStyle: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                            searchStyle: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                            dialogBackgroundColor: AppColors.bgLight,
                            boxDecoration: BoxDecoration(
                              color: AppColors.bgLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.lightDivider),
                            ),
                            searchDecoration: InputDecoration(
                              hintText: "Search country...",
                              hintStyle: TextStyle(color: AppColors.lightTextHint),
                              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                              filled: true,
                              fillColor: AppColors.bgLight,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColors.lightDivider),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColors.primaryPurple),
                              ),
                            ),
                            closeIcon: Icon(
                              Icons.close,
                              color: AppColors.textPrimary,
                            ),
                            flagWidth: 24,
                          ),
                          onChanged: (value) {
                            controller.validateMobile(value ?? '');
                            return null;
                          },
                        ),
                        if (controller.mobileError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Text(
                              controller.mobileError.value,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    )),

                    const SizedBox(height: 12),

                    /// PASSWORD
                    Obx(() => Column(
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
                        if (controller.passwordError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Text(
                              controller.passwordError.value,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    )),

                    const SizedBox(height: 12),

                    /// CONFIRM PASSWORD
                    Obx(() => Column(
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
                        if (controller.confirmPasswordError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Text(
                              controller.confirmPasswordError.value,
                              style: TextStyle(
                                color: AppColors.error,
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
                        title: controller.isLoading.value
                            ? "PLEASE WAIT..."
                            : "SIGN UP",
                        onTap: () => controller.signup(),
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

                    const SizedBox(height: 15),

                    Text(
                      "By clicking Sign Up I have read and agree\nwith Terms Sheet & Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already Have An Account ? ",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offNamed(Routes.LOGIN);
                          },
                          child: Text(
                            "LOGIN",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}