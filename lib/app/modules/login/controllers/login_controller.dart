// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../common/constant/app_imports.dart';
import '../../../core/models/login_model/login_request_model.dart';
import '../../../core/utils/api/login_api/app_login.dart';
import '../../../core/utils/helper/device_helper.dart';
import '../../../services/storage_services.dart';
import '../widget/change_password_by_email_view.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final otpError = ''.obs;
  final resetToken = ''.obs;
  final isOtpSent = false.obs;
  final isLoadingOtp = false.obs;
  final remainingSeconds = 0.obs;
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final newPasswordError = ''.obs;
  final confirmPasswordError = ''.obs;
  final isLoadingReset = false.obs;
  Timer? _otpTimer;
  final isLoading = false.obs;
  final rememberMe = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final savedAccounts = <String, dynamic>{}.obs;
  final filteredEmails = <String>[].obs;
  final showDropdown = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllSavedAccounts();
    emailController.addListener(_handleEmailTextChanges);
  }

  void loadAllSavedAccounts() {
    try {
      savedAccounts.value = StorageService.to.getSavedAccounts();
      rememberMe.value = StorageService.to.getRememberMeStatus();
      filteredEmails.assignAll(savedAccounts.keys.toList());
    } catch (e) {
      debugPrint('Error loading cached accounts: $e');
    }
  }

  void _handleEmailTextChanges() {
    final String text = emailController.text;
    filterEmailSuggestions(text);
  }

  void filterEmailSuggestions(String query) {
    if (query.trim().isEmpty) {
      filteredEmails.assignAll(savedAccounts.keys.toList());
    } else {
      final matches = savedAccounts.keys
          .where(
            (email) => email.toLowerCase().contains(query.trim().toLowerCase()),
          )
          .toList();
      filteredEmails.assignAll(matches);
    }
  }

  void selectAndFillAccount(String email) {
    emailController.text = email;
    passwordController.text = savedAccounts[email]?.toString() ?? '';
    rememberMe.value = true;
    showDropdown.value = false;
    emailError.value = '';
    passwordError.value = '';
  }

  void handleRememberMeSaving() {
    if (rememberMe.value) {
      StorageService.to.saveAccount(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  void validateEmail(String value) {
    if (value.trim().isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(value.trim())) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }
  }

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

  Future<void> login() async {
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
      showDropdown.value = false;

      final response = await AppLogin.login(
        request: LoginRequestModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );

      if (response.success) {
        await StorageService.to.saveToken(response.token);
        await StorageService.to.saveUser(response.data);
        handleRememberMeSaving();
        UDeviceHelper.showToast( response.message);
        Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
      } else {
        UDeviceHelper.showErrorToast(response.message);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void validateNewPassword(String val) {
    if (val.isEmpty) {
      newPasswordError.value = "Password is required";
    } else if (val.length < 6) {
      newPasswordError.value = "Password must be at least 6 characters";
    } else {
      newPasswordError.value = '';
    }
    if (confirmPasswordController.text.isNotEmpty) {
      validateConfirmPassword(confirmPasswordController.text);
    }
  }

  void validateConfirmPassword(String val) {
    if (val.isEmpty) {
      confirmPasswordError.value = "Confirm Password is required";
    } else if (val != newPasswordController.text) {
      confirmPasswordError.value = "Passwords do not match";
    } else {
      confirmPasswordError.value = '';
    }
  }

  Future<void> resetPassword() async {
    validateNewPassword(newPasswordController.text);
    validateConfirmPassword(confirmPasswordController.text);

    if (newPasswordError.isNotEmpty || confirmPasswordError.isNotEmpty) {
      UDeviceHelper.showErrorToast("Please fix the errors above");
      return;
    }

    try {
      isLoadingReset.value = true;

      final response = await AppLogin.resetPassword(
        email: emailController.text.trim(),
        resetToken: resetToken.value,
        password: newPasswordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );

      if (response.success == true) {
        UDeviceHelper.showToast(response.message);

        emailController.clear();
        otpController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        isOtpSent.value = false;
        resetToken.value = '';

        Get.offAllNamed(Routes.LOGIN);
      } else {
        UDeviceHelper.showErrorToast( response.message);
      }
    } catch (e) {
      debugPrint("RESET PASSWORD ERROR: $e");
      UDeviceHelper.showErrorToast(

        "An error occurred. Please try again.",
      );
    } finally {
      isLoadingReset.value = false;
    }
  }

  void sendResetLink() {
    debugPrint("Reset link sent!");
  }

  Future<void> loginWithGoogle() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      debugPrint("========== GOOGLE SIGN IN START ==========");

      await _googleSignIn.signOut();
      debugPrint("OLD GOOGLE SESSION CLEARED");

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint("USER CANCELLED LOGIN");
        isLoading.value = false;
        return;
      }

      debugPrint("SELECTED EMAIL : ${googleUser.email}");

      // 3. Authenticate with Google
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
        debugPrint("FIREBASE LOGIN SUCCESS. CALLING BACKEND API...");
        final authResponse = await AppLogin.googleLogin(
          idToken: idToken,
          name: user.displayName ?? "",
          email: user.email ?? "",
          mobileNo: user.phoneNumber ?? "",
        );

        if (authResponse.success == true && authResponse.token != null) {
          // Save Session
          await StorageService.to.saveToken(authResponse.token);
          if (authResponse.data != null) {
            await StorageService.to.saveUser(authResponse.data);
          }

          debugPrint("API LOGIN SUCCESS");

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
      debugPrint("GOOGLE LOGIN ERROR : $e");
      Get.snackbar(
        'Error',
        'Google Sign-In failed.',
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email, ) async {
    validateEmail(email);
    if (email.isEmpty || emailError.isNotEmpty) {
      UDeviceHelper.showErrorToast(
        emailError.value.isNotEmpty
            ? emailError.value
            : "Please enter your email",
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await AppLogin.forgotPassword(email: email);

      if (response.success == true) {
        UDeviceHelper.showToast(response.message);
        isOtpSent.value = true;

        startOtpTimer(response.expiresIn.toString());
      } else {
        UDeviceHelper.showErrorToast( response.message);
      }
    } catch (e) {
      debugPrint("FORGOT PASSWORD ERROR : $e");
      UDeviceHelper.showErrorToast(

        "An error occurred. Please try again.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void validateOtp(String val) {
    if (val.isEmpty) {
      otpError.value = "OTP is required";
    } else if (val.length < 4) {
      otpError.value = "Please enter a valid OTP";
    } else {
      otpError.value = '';
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    validateOtp(otp);
    if (otp.isEmpty || otpError.isNotEmpty) {
      UDeviceHelper.showErrorToast(
        otpError.value.isNotEmpty ? otpError.value : "Please enter the OTP",
      );
      return;
    }

    try {
      isLoadingOtp.value = true;

      final response = await AppLogin.forgotPasswordOtp(email: email, otp: otp);

      if (response.success == true) {
        UDeviceHelper.showToast(

          response.message ?? "OTP verified successfully!",
        );

        if (response.resetToken != null) {
          resetToken.value = response.resetToken!;
        }

        Get.off(() => const ChangePasswordView());
      } else {
        UDeviceHelper.showErrorToast(

          response.message ?? "Invalid OTP entered.",
        );
      }
    } catch (e) {
      debugPrint("OTP VERIFY ERROR : $e");
      UDeviceHelper.showErrorToast(

        "An error occurred. Please try again.",
      );
    } finally {
      isLoadingOtp.value = false;
    }
  }

  void startOtpTimer(String? expiresIn) {
    _otpTimer?.cancel();
    int seconds = 120;
    if (expiresIn != null && expiresIn.isNotEmpty) {
      seconds = int.tryParse(expiresIn) ?? 120;
    }

    remainingSeconds.value = seconds;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String get formattedOtpTimer {
    int min = remainingSeconds.value ~/ 60;
    int sec = remainingSeconds.value % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      debugPrint("LOGOUT SUCCESS");
    } catch (e) {
      debugPrint("LOGOUT ERROR : $e");
    }
  }
}
