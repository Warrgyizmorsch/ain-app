import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/constant/app_colors.dart';
import '../../../common/constant/image_constant.dart';
import '../../../common/widget/button/custom_app_button.dart';
import '../../../common/widget/text_field/custom_text_field.dart';
import '../controllers/login_controller.dart';

class ForgotPasswordView extends GetView<LoginController> {
  const ForgotPasswordView({super.key});

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

              Obx(() {
                if (controller.isOtpSent.value) {
                  return _buildOtpSection(context);
                } else {
                  return _buildEmailSection(context);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Reset Your Password",
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
            "Enter your email address and we will send you instructions to reset your password.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
              if (controller.emailError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Text(
                    controller.emailError.value,
                    style: TextStyle(color: AppColors.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 30),
              Obx(
                () => AppButton(
                  title: controller.isLoading.value
                      ? "SENDING..."
                      : "SEND INSTRUCTIONS",
                  onTap: controller.isLoading.value
                      ? () {}
                      : () => controller.forgotPassword(
                          controller.emailController.text.trim(),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
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
    );
  }

  Widget _buildOtpSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Verify OTP",
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
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: "We have sent a verification code to\n"),
                TextSpan(
                  text: controller.emailController.text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomOtpInput(
                controller: controller.otpController,
                length: 6,
                onChanged: (value) {
                  controller.validateOtp(value);
                },
              ),
              if (controller.otpError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 5),
                  child: Text(
                    controller.otpError.value,
                    style: TextStyle(color: AppColors.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 30),
              Obx(
                () => AppButton(
                  title: controller.isLoadingOtp.value
                      ? "VERIFYING..."
                      : "VERIFY OTP",
                  onTap: controller.isLoadingOtp.value
                      ? () {}
                      : () => controller.verifyOtp(context),
                ),
              ),
              const SizedBox(height: 20),

              Obx(() {
                final isTimerActive = controller.remainingSeconds.value > 0;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isTimerActive
                          ? "Resend code in "
                          : "Didn't receive the code? ",
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    if (isTimerActive)
                      Text(
                        controller.formattedOtpTimer,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : () => controller.forgotPassword(
                                controller.emailController.text.trim(),
                              ),
                        child: Text(
                          "Resend",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: controller.isLoading.value
                                ? AppColors.lightTextDisabled
                                : AppColors.primaryPurple,
                          ),
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {
                    controller.otpController.clear();
                    controller.isOtpSent.value = false;
                  },
                  child: Text(
                    "Change Email Address",
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
    );
  }
}

class CustomOtpInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final int length;

  const CustomOtpInput({
    super.key,
    required this.controller,
    required this.onChanged,
    this.length = 6,
  });

  @override
  State<CustomOtpInput> createState() => _CustomOtpInputState();
}

class _CustomOtpInputState extends State<CustomOtpInput> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var ctrl in _controllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _updateMainController() {
    String otp = _controllers.map((c) => c.text).join();
    widget.controller.text = otp;
    widget.onChanged(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 45,
          height: 55,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 1,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            cursorColor: AppColors.primaryPurple,
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: AppColors.bgLight,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.lightDivider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.lightDivider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primaryPurple, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < widget.length - 1) {
                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                } else {
                  _focusNodes[index].unfocus();
                }
              } else {
                if (index > 0) {
                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                }
              }
              _updateMainController();
            },
          ),
        );
      }),
    );
  }
}