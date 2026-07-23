import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/constant/app_colors.dart';
import '../../../core/utils/api/login_api/app_login.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_services.dart';

class LoginOnboardingController extends GetxController {
  final isLoading = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithGoogle() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      debugPrint("========== GOOGLE SIGN IN START (LOGIN ONBOARDING) ==========");

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
      debugPrint("GOOGLE LOGIN ONBOARDING ERROR : $e");
      Get.snackbar(
        'Error',
        'Google Sign-In failed.',
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
