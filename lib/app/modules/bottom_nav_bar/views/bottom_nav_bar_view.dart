import 'package:ain/app/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/app_imports.dart';
import '../../../routes/app_pages.dart';
import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavView extends GetView<BottomNavController> {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        // Set your background color here (e.g., the slate/grey color from 55646.jpg)
        backgroundColor: const Color(0xFF8B9BB4),
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.pages,
        ),
        // Using extendBody allows the body background to show through the bottom nav transparent areas
        extendBody: true,
        bottomNavigationBar: const _BottomNavBar(),
      ),
    );
  }
}

class _BottomNavBar extends GetView<BottomNavController> {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => SafeArea(
        top: false,
        child: Container(
          // Changing this structure prevents any forced white box below or behind the bar
          color: Colors.transparent,
          height: 80,
          margin: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // ── Main Light Blue Pill Bar ──────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6E8F8), // Matches the exact light blue background
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Left Side: Home & Chat
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _NavItem(
                              index: 0,
                              selectedIndex: controller.selectedIndex.value,
                              onTap: controller.changeTab,
                              assetPath: ImageConstant.homeIcon,
                            ),
                            _NavItem(
                              index: 1,
                              selectedIndex: controller.selectedIndex.value,
                              onTap: controller.changeTab,
                              assetPath: ImageConstant.chatIcon,
                            ),
                          ],
                        ),
                      ),

                      // Spatial gap where the central Add button floats
                      const SizedBox(width: 56),

                      // Right Side: WhatsApp & Profile
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _NavItem(
                              index: 2,
                              selectedIndex: controller.selectedIndex.value,
                              onTap: controller.changeTab,
                              assetPath: ImageConstant.whatsAppIcon,
                            ),
                            _NavItem(
                              index: 3,
                              selectedIndex: controller.selectedIndex.value,
                              onTap: controller.changeTab,
                              assetPath: ImageConstant.profileIcon,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Center Floating Add Button ───────────────────────────────
              Positioned(
                top: 6, // Increased from 0 to 12 to shift the Add button slightly downwards
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.ADD_ORDER),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        ImageConstant.addIcon,
                        width: 24,
                        height: 24,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String assetPath;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.assetPath,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  bool get isActive => selectedIndex == index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.white : const Color(0xFF2B92CE),
                BlendMode.srcIn,
              ),
              child: Image.asset(
                assetPath,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}