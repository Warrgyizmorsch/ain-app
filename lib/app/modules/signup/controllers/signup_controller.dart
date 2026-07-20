import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/register_model/register_request_model.dart';
import '../../../core/utils/api/register_api/app_register.dart';
import '../../../core/utils/helper/device_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_services.dart';

class SignupController extends GetxController {
  final isLoading = false.obs;
  final selectedDialCode = '+91'.obs;

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameError = ''.obs;
  final mobileError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;


  void validateName(String value) {
    nameError.value =
    value.trim().isEmpty ? 'Name is required' : '';
  }

  void validateMobile(String value) {
    if (value.trim().isEmpty) {
      mobileError.value = 'Mobile number is required';
    } else if (value.trim().length < 10) {
      mobileError.value = 'Enter valid mobile number';
    } else {
      mobileError.value = '';
    }
  }

  void validateEmail(String value) {
    if (value.trim().isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(value.trim())) {
      emailError.value = 'Enter valid email';
    } else {
      emailError.value = '';
    }
  }

  void validatePassword(String value) {
    if (value.trim().isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.trim().length < 6) {
      passwordError.value =
      'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }
  }

  void validateConfirmPassword(String value) {
    if (value.trim().isEmpty) {
      confirmPasswordError.value =
      'Confirm password is required';
    } else if (value != passwordController.text.trim()) {
      confirmPasswordError.value =
      'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }

  bool validateForm() {
    validateName(nameController.text);
    validateMobile(mobileController.text);
    validateEmail(emailController.text);
    validatePassword(passwordController.text);
    validateConfirmPassword(
      confirmPasswordController.text,
    );

    return nameError.value.isEmpty &&
        mobileError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty;
  }

  Future<void> signup() async {
    if (!validateForm()) {
      Get.snackbar(
        'Validation Failed',
        'Please complete all required fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await AppRegister.register(
        request: RegisterRequestModel(
          name: nameController.text.trim(),
          phoneNo:
          '${selectedDialCode.value}${mobileController.text.trim()}',
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          confirmPassword:
          confirmPasswordController.text.trim(),
        ),
      );

      if (response.success) {
        await StorageService.to.saveToken(
          response.token,
        );

        await StorageService.to.saveUser(
          response.data,
        );

        UDeviceHelper.showToast( response.message);

        Get.offAllNamed(
          Routes.BOTTOM_NAV_BAR,
        );
      } else {
        UDeviceHelper.showErrorToast( response.message);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}