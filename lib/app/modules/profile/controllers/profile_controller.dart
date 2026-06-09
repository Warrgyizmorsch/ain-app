import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Profile Fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final qualificationController = TextEditingController();
  final collegeController = TextEditingController();
  final courseController = TextEditingController();

  // Change Password Fields
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Country Dropdown
  final selectedCountry = 'India'.obs;

  final countries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
  ];

  @override
  void onInit() {
    super.onInit();

    // Demo Data
    nameController.text = 'Priyanka Joshi';
    emailController.text = 'Priyanka123456@gmail.com';
    mobileController.text = '+91 1234567890';
  }

  void updateProfile() {
    Get.snackbar(
      'Success',
      'Profile Updated Successfully',
    );
  }

  void updatePassword() {
    if (newPasswordController.text !=
        confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
      );
      return;
    }

    Get.snackbar(
      'Success',
      'Password Updated Successfully',
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    qualificationController.dispose();
    collegeController.dispose();
    courseController.dispose();

    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}