import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constant/app_imports.dart';

class ContactUsController extends GetxController {
  final phoneNumber = '+44 7300640066';
  final email = 'help@assignmentinneed.com';

  Future<void> makeCall() async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Error',
        'Unable to make a phone call.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> openWhatsapp() async {
    final Uri uri = Uri.parse(
      'https://api.whatsapp.com/send/?phone=447826233106&text&type=phone_number&app_absent=0',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'WhatsApp is not installed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> sendEmail() async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Support Request',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Error',
        'Unable to open email app.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> openLiveChat() async {
    final Uri uri = Uri.parse(
      'https://assignment-in-need.vercel.app/about',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void requestCallBack(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Request Call Back', style: AppTextStyles.h1.copyWith(fontSize: AppFontSize.s16)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please provide your details, and our team will call you shortly.",
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                // Name Field
                TextField(
                  controller: nameController,
                  style: AppTextStyles.inputText.copyWith(fontSize: AppFontSize.s13),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: AppTextStyles.hintText.copyWith(fontSize: AppFontSize.s13),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Phone Field
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: AppTextStyles.inputText.copyWith(fontSize: AppFontSize.s13),
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: AppTextStyles.hintText.copyWith(fontSize: AppFontSize.s13),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          actions: [
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      AppStrings.cancel, // Or just "Cancel" if you don't have this mapped
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: AppFontSize.s13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Submit Button
                Expanded(
                  child: AppButton(
                    title: AppStrings.submit, // Or just "Submit"
                    onTap: () {
                      // Validation
                      if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
                        Get.snackbar(
                          'Validation',
                          'Please enter both your name and phone number.',
                          backgroundColor: AppColors.error,
                          colorText: AppColors.white,
                        );
                        return;
                      }

                      // --- Add API Call Here Later (if needed) ---

                      Get.back(); // Close dialog

                      Get.snackbar(
                        'Success',
                        'Callback request submitted.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.success,
                        colorText: AppColors.white,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}