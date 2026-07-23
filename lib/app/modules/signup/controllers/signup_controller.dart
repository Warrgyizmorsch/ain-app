import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/constant/app_colors.dart';
import '../../../core/models/register_model/register_request_model.dart';
import '../../../core/utils/api/login_api/app_login.dart';
import '../../../core/utils/api/register_api/app_register.dart';
import '../../../core/utils/helper/device_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_services.dart';

class SignupController extends GetxController {
  final isLoading = false.obs;
  final selectedDialCode = '+91'.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> loginWithGoogle() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      debugPrint("========== GOOGLE SIGN IN START (SIGNUP) ==========");

      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String idToken = googleAuth.idToken ?? "";

      if (idToken.isEmpty) {
        Get.snackbar(
          'Error',
          'Google ID Token not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
        );
        isLoading.value = false;
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        final authResponse = await AppLogin.googleLogin(
          idToken: idToken,
          name: user.displayName ?? "",
          email: user.email ?? "",
          mobileNo: user.phoneNumber ?? "",
        );

        if (authResponse.success == true && authResponse.token != null) {
          await StorageService.to.saveToken(authResponse.token);
          if (authResponse.data != null) {
            await StorageService.to.saveUser(authResponse.data);
          }

          final bool isNewUser =
              userCredential.additionalUserInfo?.isNewUser ?? false;

          if (isNewUser) {
            Get.offAllNamed(
              Routes.BOTTOM_NAV_BAR,
              arguments: {
                'id_token': idToken,
                'email': googleUser.email,
                'name': googleUser.displayName ?? "",
                'phone': user.phoneNumber ?? "",
              },
            );
          } else {
            Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
          }
        } else {
          await _auth.signOut();
          await _googleSignIn.signOut();

          Get.snackbar(
            'Login Failed',
            'Failed to authenticate with our servers.',
            backgroundColor: AppColors.error,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Firebase user not found',
          backgroundColor: AppColors.error,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Authentication Failed',
        e.message ?? 'An unknown Firebase error occurred.',
        backgroundColor: AppColors.error,
      );
    } catch (e) {
      debugPrint("GOOGLE SIGNUP ERROR : $e");
      Get.snackbar(
        'Error',
        'Google Sign-In failed.',
        backgroundColor: AppColors.error,
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