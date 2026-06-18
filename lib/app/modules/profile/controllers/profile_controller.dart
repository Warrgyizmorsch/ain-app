import 'package:ain/app/core/models/profile_model/reset_password_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/profile_model/reset_password_request_model.dart';
import '../../../core/utils/api/profile_api/reset_password_api.dart';
import '../../../services/storage_services.dart';

class ProfileController extends GetxController {
  // Profile Fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final qualificationController = TextEditingController();
  final collegeController = TextEditingController();
  final courseController = TextEditingController();

  // Change Password Fields
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
// Add these error hooks
  final oldPasswordError = ''.obs;
  final newPasswordError = ''.obs;
  final confirmPasswordError = ''.obs;
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

    // Fetch the active user's data from SharedPreferences
    final Map<String, dynamic>? userData = StorageService.to.getUser();

    if (userData != null) {
      // Populate controllers with real data
      // (Make sure the keys 'name', 'email', and 'mobile' match your actual JSON API response)
      nameController.text = userData['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      mobileController.text = userData['mobile_no'] ?? '';
    } else {
      // Fallback Demo Data if no user is logged in or saved yet
      nameController.text = 'Priyanka Joshi';
      emailController.text = 'Priyanka123456@gmail.com';
      mobileController.text = '+91 1234567890';
    }
  }

  void updateProfile() {
    Get.snackbar(
      'Success',
      'Profile Updated Successfully',
    );
  }

  void updatePassword() async {
    // 1. Reset errors
    oldPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';

    // 2. Validate empty
    if (oldPasswordController.text.isEmpty) oldPasswordError.value = 'Please enter old password';
    if (newPasswordController.text.isEmpty) newPasswordError.value = 'Please enter new password';
    if (confirmPasswordController.text.isEmpty) confirmPasswordError.value = 'Please confirm new password';

    if (oldPasswordError.isNotEmpty || newPasswordError.isNotEmpty || confirmPasswordError.isNotEmpty) return;

    // 3. Logic Validation
    final savedPassword = StorageService.to.getSavedPassword();
    if (oldPasswordController.text.trim() != savedPassword) {
      oldPasswordError.value = 'Incorrect old password';
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      return;
    }

    // 4. Retrieve necessary data from StorageService
    final String? token = StorageService.to.getToken();
    final Map<String, dynamic>? user = StorageService.to.getUser();
    final String email = user?['email'] ?? ""; // Ensure your user object has an 'email' key

    if (token == null || email.isEmpty) {
      Get.snackbar('Error', 'Session expired. Please login again.');
      return;
    }

    // 5. Construct Request Model
    ResetPasswordRequestModel request = ResetPasswordRequestModel(
      token: token,
      email: email,
      password: newPasswordController.text.trim(),
      passwordConfirmation: confirmPasswordController.text.trim(),
    );

    // 6. API Call
    try {
      final response = await ResetPasswordApi.resetPassword(request: request);

      if (response.success == true) {
        Get.snackbar('Success', 'Password updated successfully!');

        // Update local storage with the new password
        await StorageService.to.saveAccount(email, newPasswordController.text.trim());

        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        Get.snackbar('Error', response.message ?? 'Update failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
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