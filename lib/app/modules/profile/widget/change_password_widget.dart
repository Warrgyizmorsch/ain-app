import '../../../common/constant/app_imports.dart';
import '../controllers/profile_controller.dart';

class ChangePasswordWidget extends GetView<ProfileController> {
    ChangePasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>ProfileController());
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: "Change Password",
      ),
      body: SingleChildScrollView(
        padding:   EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
                SizedBox(height: 10),
              Image.asset(
                ImageConstant.lock,
                width: 90,
                height: 90,
              ),
                SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- OLD PASSWORD ---
                  Obx(() {
                    final hasError = controller.oldPasswordError.isNotEmpty;
                    return TextFormFieldCustom(
                      title: 'OLD PASSWORD',
                      borderColor: hasError ? AppColors.error : AppColors.lightDivider,
                      borderWidth: 1.5,
                      height: 44,
                      method: TextFormField(
                        controller: controller.oldPasswordController,
                        obscureText: true,
                        style: AppTextStyles.inputText,
                        decoration:   InputDecoration(
                          hintText: 'Old Password',
                          hintStyle: AppTextStyles.hintText,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        onChanged: (value) => controller.oldPasswordError.value = '',
                      ),
                    );
                  }),
                  Obx(() => controller.oldPasswordError.isNotEmpty
                      ? Padding(
                    padding:   EdgeInsets.only(top: 4, left: 5),
                    child: Text(controller.oldPasswordError.value,
                        style:   TextStyle(fontSize: 12, color: AppColors.error)),
                  )
                      :   SizedBox.shrink()),
                    SizedBox(height: 12),

                  // --- NEW PASSWORD ---
                  Obx(() {
                    final hasError = controller.newPasswordError.isNotEmpty;
                    return TextFormFieldCustom(
                      title: 'NEW PASSWORD',
                      borderColor: hasError ? AppColors.error : AppColors.lightDivider,
                      borderWidth: 1.5,
                      height: 44,
                      method: TextFormField(
                        controller: controller.newPasswordController,
                        obscureText: true,
                        style: AppTextStyles.inputText,
                        decoration:   InputDecoration(
                          hintText: 'New Password',
                          hintStyle: AppTextStyles.hintText,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        onChanged: (value) => controller.newPasswordError.value = '',
                      ),
                    );
                  }),
                  Obx(() => controller.newPasswordError.isNotEmpty
                      ? Padding(
                    padding:   EdgeInsets.only(top: 4, left: 5),
                    child: Text(controller.newPasswordError.value,
                        style:   TextStyle(fontSize: 12, color: AppColors.error)),
                  )
                      :   SizedBox.shrink()),
                    SizedBox(height: 12),

                  // --- CONFIRM PASSWORD ---
                  Obx(() {
                    final hasError = controller.confirmPasswordError.isNotEmpty;
                    return TextFormFieldCustom(
                      title: 'CONFIRM PASSWORD',
                      borderColor: hasError ? AppColors.error : AppColors.lightDivider,
                      borderWidth: 1.5,
                      height: 44,
                      method: TextFormField(
                        controller: controller.confirmPasswordController,
                        obscureText: true,
                        style: AppTextStyles.inputText,
                        decoration:   InputDecoration(
                          hintText: 'Confirm New Password',
                          hintStyle: AppTextStyles.hintText,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        onChanged: (value) => controller.confirmPasswordError.value = '',
                      ),
                    );
                  }),
                  Obx(() => controller.confirmPasswordError.isNotEmpty
                      ? Padding(
                    padding:   EdgeInsets.only(top: 4, left: 5),
                    child: Text(controller.confirmPasswordError.value,
                        style:   TextStyle(fontSize: 12, color: AppColors.error)),
                  )
                      :   SizedBox.shrink()),
                    SizedBox(height: 30),

                  AppButton(
                    title: 'Update Password',
                    onTap: controller.updatePassword,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}