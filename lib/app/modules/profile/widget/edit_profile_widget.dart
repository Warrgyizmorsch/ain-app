import '../../../common/constant/app_imports.dart';
import '../controllers/profile_controller.dart';

class EditProfileWidget extends GetView<ProfileController> {
  const EditProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileController());

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: CustomAppBar(
          title: AppStrings.editProfile,
          showBackButton: true,

          actions: [
            TextButton(
              onPressed: controller.isLoading.value ? null : controller.updateProfile,
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      AppStrings.save,
                      style: TextStyle(
                        color: AppColors.primary, // Dynamic Purple
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Top Header Card ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary, // Dynamic primary color
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            image: controller.selectedProfilePhoto.value != null
                                ? DecorationImage(
                                    image: FileImage(
                                      controller.selectedProfilePhoto.value!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : (controller.networkProfilePhotoUrl.value.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          controller.networkProfilePhotoUrl.value,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null),
                          ),
                          child: (controller.selectedProfilePhoto.value == null &&
                                  controller.networkProfilePhotoUrl.value.isEmpty)
                              ? Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.lightTextHint,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: controller.pickProfilePhoto,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ), // Keeps white border for contrast
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.nameController.text.isNotEmpty
                                ? controller.nameController.text
                                : 'User Name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.emailController.text,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.workspace_premium,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Premium Member',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // --- 2. Personal Information ---
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              _buildFieldRow(
                icon: Icons.person_outline,
                label: 'Full Name',
                child: _buildTextField(
                  controller: controller.nameController,
                  hint: 'Enter Name',
                  keyboardType: TextInputType.name,
                ),
              ),
              const SizedBox(height: 16),

              _buildFieldRow(
                icon: Icons.mail_outline,
                label: 'Email Address',
                child: _buildTextField(
                  controller: controller.emailController,
                  hint: 'Enter Email',
                  isReadOnly: true,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16),

              _buildFieldRow(
                icon: Icons.phone_outlined,
                label: 'Phone Number',
                child: _buildTextField(
                  controller: controller.mobileController,
                  hint: '+91 98765 43210',
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 16),



              _buildFieldRow(
                icon: Icons.public_outlined,
                label: 'Country',
                child: _buildCountryDropdown(),
              ),
              const SizedBox(height: 32),


              // --- 3. Account Preferences ---
              Text(
                'Account Preferences',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              _buildPreferenceRow(
                icon: Icons.notifications_none,
                title: 'Notifications',
                subtitle: 'Manage how you want to receive updates',
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              _buildPreferenceRow(
                icon: Icons.palette_outlined,
                title: 'Theme',
                subtitle: 'Choose your app theme',
                trailing: _buildThemeDropdown(),
              ),
              const SizedBox(height: 32),

              // --- 4. Profile Photo Section ---
              Text(
                'Profile Photo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.lightDivider,
                          shape: BoxShape.circle,
                          image: controller.selectedProfilePhoto.value != null
                              ? DecorationImage(
                                  image: FileImage(
                                    controller.selectedProfilePhoto.value!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : (controller.networkProfilePhotoUrl.value.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        controller.networkProfilePhotoUrl.value,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                        ),
                        child: (controller.selectedProfilePhoto.value == null &&
                                controller.networkProfilePhotoUrl.value.isEmpty)
                            ? Icon(
                                Icons.person,
                                size: 36,
                                color: AppColors.lightTextHint,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: controller.pickProfilePhoto,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile Photo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'JPG, PNG or WEBP. Max size 2MB.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        OutlinedButton.icon(
                          onPressed: controller.pickProfilePhoto,
                          icon: Icon(
                            Icons.upload_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            'Change Photo',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // --- 5. Delete Account Button ---
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  label: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.error.withValues(alpha: 0.1),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
      ],
    ),
  ));
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================

  Widget _buildFieldRow({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 0.1,
            ), // Dynamic light background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              child,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isReadOnly = false,
    Widget? suffixIcon,
    Widget? prefixIcon, // Added for the minus button
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    TextAlign textAlign = TextAlign.start, // Added to center the number
    Function(String)? onChanged, // Added to update GetX state
    List<TextInputFormatter>? inputFormatters, // Added to force numbers only
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      textAlign: textAlign, // Applied here
      onChanged: onChanged, // Applied here
      inputFormatters: inputFormatters, // Applied here
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: AppColors.lightTextHint),
        filled: true,
        fillColor: AppColors.bgLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        prefixIcon: prefixIcon, // Applied here
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isReadOnly ? Colors.transparent : AppColors.lightDivider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return PopupMenuButton<String>(
      initialValue: controller.selectedCountry.value,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.bgLight,
      onSelected: (String country) {
        controller.selectedCountry.value = country;
      },
      itemBuilder: (BuildContext context) {
        final list = controller.countryList.isNotEmpty
            ? controller.countryList.map((c) => c.name).toList()
            : controller.countries;
        return list
            .map(
              (c) => PopupMenuItem<String>(
                value: c,
                child: Text(
                  c,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            )
            .toList();
      },
      child: _buildDropdownTrailing(controller.selectedCountry.value),
    );
  }

  Widget _buildDropdownTrailing(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        border: Border.all(color: AppColors.lightDivider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeDropdown() {
    final themeService = ThemeService.to;
    final currentThemeText = themeService.themeModeName;

    return PopupMenuButton<ThemeMode>(
      initialValue: themeService.themeMode,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.bgLight,
      onSelected: (ThemeMode newMode) {
        themeService.updateThemeMode(newMode);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.system,
          child: Row(
            children: [
              Icon(
                Icons.phone_android_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                'System Default',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: themeService.themeMode == ThemeMode.system
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.light,
          child: Row(
            children: [
              Icon(
                Icons.light_mode_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                'Light Mode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: themeService.themeMode == ThemeMode.light
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.dark,
          child: Row(
            children: [
              Icon(
                Icons.dark_mode_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: themeService.themeMode == ThemeMode.dark
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
      child: _buildDropdownTrailing(currentThemeText),
    );
  }

  Widget _buildPreferenceRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}
