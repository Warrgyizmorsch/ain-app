
import '../../../common/constant/app_imports.dart';
import '../controllers/profile_controller.dart';

class EditProfileWidget extends GetView<ProfileController> {
  const EditProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:   CustomAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                'P',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 24),

            TextFormFieldCustom(
              title: 'NAME',
              method: TextFormField(
                controller: controller.nameController,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
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
              title: 'EMAIL',
              method: TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
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
              title: 'COUNTRY',
              method: CustomDropdown<String>(
                valueListenable: ValueNotifier(
                  controller.selectedCountry.value,
                ),
                items: controller.countries,
                label: (s) => s,
                hint: 'Select Country',
                onChanged: (value) {
                  controller.selectedCountry.value = value ?? '';
                },
                showBorder: false,
              ),
              borderColor: AppColors.lightDivider,
              borderWidth: 1.5,
              height: 44,
            ),

            const SizedBox(height: 12),

            TextFormFieldCustom(
              title: 'MOBILE NUMBER',
              method: TextFormField(
                controller: controller.mobileController,
                keyboardType: TextInputType.phone,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Enter Mobile Number',
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
              title: 'QUALIFICATIONS (OPTIONAL)',
              method: TextFormField(
                controller: controller.qualificationController,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Enter your qualifications',
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
              title: 'COLLEGE / UNIVERSITY (OPTIONAL)',
              method: TextFormField(
                controller: controller.collegeController,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Enter your university',
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
              title: 'COURSE (OPTIONAL)',
              method: TextFormField(
                controller: controller.courseController,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'Enter your course',
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

            const SizedBox(height: 24),

            AppButton(
              title: 'Update Profile',
              onTap: controller.updateProfile,
            ),
          ],
        ),
      ),
    );
  }
}