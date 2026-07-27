import '../../../common/constant/app_imports.dart';
import '../../../services/storage_services.dart';
import '../controllers/profile_controller.dart';
import '../widget/change_password_widget.dart';
import '../widget/edit_profile_widget.dart';
import '../widget/my_order_widget.dart';
import '../widget/payment_history_view.dart';
import '../widget/refer_and_earn_screen.dart';
import '../widget/saved_sample_widget.dart';


class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar:   CustomAppBar(
        title: AppStrings.profile,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding:   EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Gradient Card ---
            Obx(
              () => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
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
                              size: 32,
                              color: AppColors.textGrey,
                            )
                          : null,
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
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.emailController.text,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              AppStrings.premiumMember,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

              SizedBox(height: 24),

            // --- Menu Section ---
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightShadow, // Replaced grey withOpacity(0.08)
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset:   Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _ProfileMenuTile(
                    icon: Icons.receipt_long_outlined,
                    title: AppStrings.myOrders,
                    onTap: () {
                      Get.to(() => MyOrdersWidget());
                    },
                  ),
                  _Divider(),
                  _ProfileMenuTile(
                    icon: Icons.payment_outlined,
                    title: AppStrings.payments,
                    onTap: () {
                      // Note: adjust route if this should be const
                      Get.to(PaymentHistoryView());
                    },
                  ),
                  _Divider(),
                  _ProfileMenuTile(
                    icon: Icons.bookmark_border_outlined,
                    title: AppStrings.savedSamples,
                    onTap: () {
                      // Note: adjust route if this should be const
                      Get.to(SavedSamplesView());
                    },
                  ),
                  _Divider(),
                  _ProfileMenuTile(
                    icon: Icons.card_giftcard_outlined,
                    title: AppStrings.referAndEarn,
                    subtitle: AppStrings.inviteAndEarnRewards,
                    onTap: () {
                      Get.to(  ReferAndEarnScreen());
                    },
                  ),
                  _Divider(),
                  Obx(() => _ProfileMenuTile(
                    icon: Icons.palette_outlined,
                    title: AppStrings.appTheme,
                    subtitle: ThemeService.to.themeModeName,
                    onTap: () {
                      ThemeSelectionDialog.show(context);
                    },
                  )),
                  _Divider(),
                  _ProfileMenuTile(
                    icon: Icons.manage_accounts_outlined,
                    title: AppStrings.editProfile,
                    onTap: () {
                      Get.to(  EditProfileWidget());
                    },
                  ),
                  _Divider(),
                  _ProfileMenuTile(
                    icon: Icons.lock_outline,
                    title: AppStrings.changePassword,
                    onTap: () {
                      Get.to(  ChangePasswordWidget());
                    },
                  ),
                  _Divider(),
                  _ProfileMenuTile(
                    icon: Icons.help_outline,
                    title: AppStrings.privacyPolicy,
                    onTap: () {
                      controller.openLiveChat();
                    },
                  ),

                ],
              ),
            ),

              SizedBox(height: 10),

            // --- Log Out Button ---
            TextButton.icon(
              onPressed: () async {
                await StorageService.to.clearAuthData();
                Get.offAllNamed(Routes.LOGIN); // Assuming Routes is imported properly
              },
              icon:   Icon(Icons.logout, color: AppColors.error),
              label: Text(
                AppStrings.logout,
                style: AppTextStyles.button.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding:   EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

              SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// Custom divider to match the inset seen in typical lists
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: EdgeInsets.only(left: 56, right: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.lightDivider,
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20), // Matches container bounds if it's the first/last item
      child: Padding(
        padding:   EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 24),
              SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: AppFontSize.s14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                      SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 12,
                        color: AppColors.lightTextDisabled,
                      ),
                    ),
                  ],
                ],
              ),
            ),
              Icon(Icons.chevron_right, color: AppColors.lightTextHint, size: 22),
          ],
        ),
      ),
    );
  }
}