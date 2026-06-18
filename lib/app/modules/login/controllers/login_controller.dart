import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/app_imports.dart';
import '../../../core/models/login_model/login_request_model.dart';
import '../../../core/utils/api/login_api/app_login.dart';
import '../../../core/utils/helper/device_helper.dart';
import '../../../services/storage_services.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final rememberMe = false.obs;

  // Validation Errors
  final emailError = ''.obs;
  final passwordError = ''.obs;

  // 🟩 Multi-Account Reactive States
  final savedAccounts = <String, dynamic>{}.obs;
  final filteredEmails = <String>[].obs;
  final showDropdown = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 🟩 Initialize accounts map setup from cache
    loadAllSavedAccounts();

    // 🟩 Set up active listener to filter lists dynamically as user types
    emailController.addListener(_handleEmailTextChanges);
  }

  // ─── MULTI-ACCOUNT SUGGESTIONS LOGIC ──────────────────────────────────────

  /// Extracts the cached account map from local shared storage
  void loadAllSavedAccounts() {
    try {
      savedAccounts.value = StorageService.to.getSavedAccounts();
      rememberMe.value = StorageService.to.getRememberMeStatus();

      // Pre-populate filtered list with all keys initially
      filteredEmails.assignAll(savedAccounts.keys.toList());
    } catch (e) {
      debugPrint('Error loading cached accounts: $e');
    }
  }

  /// Internal listener loop mapping text mutations to search filter operations
  void _handleEmailTextChanges() {
    final String text = emailController.text;
    filterEmailSuggestions(text);
  }

  /// Filters cached matches matching current alphanumeric string queries
  void filterEmailSuggestions(String query) {
    if (query.trim().isEmpty) {
      filteredEmails.assignAll(savedAccounts.keys.toList());
    } else {
      final matches = savedAccounts.keys
          .where((email) => email.toLowerCase().contains(query.trim().toLowerCase()))
          .toList();
      filteredEmails.assignAll(matches);
    }
  }

  /// Auto-fills form values when an email is selected from the suggestion dropdown
  void selectAndFillAccount(String email) {
    emailController.text = email;
    passwordController.text = savedAccounts[email]?.toString() ?? '';
    rememberMe.value = true;
    showDropdown.value = false; // Collapse suggestion list layout

    // Clear active validation error text hooks
    emailError.value = '';
    passwordError.value = '';
  }

  /// Appends or updates the key-value dictionary schema post successful authentication
  void handleRememberMeSaving() {
    if (rememberMe.value) {
      // 🟩 Calls the new map-based save endpoint
      StorageService.to.saveAccount(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }
  // ─────────────────────────────────────────────────────────────────────────

  // Email Validation
  void validateEmail(String value) {
    if (value.trim().isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(value.trim())) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }
  }

  // Password Validation
  void validatePassword(String value) {
    if (value.trim().isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.trim().length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }
  }

  bool validateLogin() {
    validateEmail(emailController.text);
    validatePassword(passwordController.text);

    return emailError.value.isEmpty && passwordError.value.isEmpty;
  }

  Future<void> login(BuildContext context) async {
    if (!validateLogin()) {
      Get.snackbar(
        'Validation Failed',
        'Please complete all required fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      showDropdown.value = false; // Hide dropdown view during network submission

      final response = await AppLogin.login(
        request: LoginRequestModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );

      if (response.success) {
        // Save Token
        await StorageService.to.saveToken(response.token);

        // Save User Data
        await StorageService.to.saveUser(response.data.toJson());

        // 🟩 Persist current account credentials if Remember Me is active
        handleRememberMeSaving();

        UDeviceHelper.showToast(context, response.message);

        Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
      } else {
        UDeviceHelper.showErrorToast(context, response.message);
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
  void sendResetLink() {
    // Your logic here
    print("Reset link sent!");
  }
  @override
  void onClose() {
    // Note: Disposing text controller automatically safely unbinds its internal listeners
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}