import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_imports.dart';
import '../controllers/profile_controller.dart';

class ChangePasswordWidget extends GetView<ProfileController> {
  const ChangePasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: CustomAppBar(
          title:"Change Password",
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
      
            Image.asset(
              ImageConstant.lock,
              width: 90,
              height: 90,
            ),
      
            const SizedBox(height: 24),
      
            TextFormFieldCustom(
              title: 'OLD PASSWORD',
              method: TextFormField(
                controller: controller.oldPasswordController,
                obscureText: true,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Old Password',
                  hintStyle: AppTextStyles.hintText,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              borderColor: AppColors.lightDivider,
              borderWidth: 1.5,
              height: 44,
            ),
      
            const SizedBox(height: 12),
      
            TextFormFieldCustom(
              title: 'NEW PASSWORD',
              method: TextFormField(
                controller: controller.newPasswordController,
                obscureText: true,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  hintStyle: AppTextStyles.hintText,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              borderColor: AppColors.lightDivider,
              borderWidth: 1.5,
              height: 44,
            ),
      
            const SizedBox(height: 12),
      
            TextFormFieldCustom(
              title: 'CONFIRM PASSWORD',
              method: TextFormField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  hintStyle: AppTextStyles.hintText,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              borderColor: AppColors.lightDivider,
              borderWidth: 1.5,
              height: 44,
            ),
      
            const SizedBox(height: 30),
      
            AppButton(
              title: 'Update Password',
              onTap: controller.updatePassword,
            ),
          ],
        ),
      ),
    );
  }
}