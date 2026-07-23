import '../../../common/constant/app_imports.dart';
// Yahan apna ExitAppWrapper import karein
import '../../../common/widget/dialog/exit_app_wrapper.dart';
import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavView extends GetView<BottomNavController> {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isHome = controller.selectedIndex.value == 0;
      return PopScope(
        canPop: isHome,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (controller.selectedIndex.value != 0) {
            controller.changeTab(0);
          }
        },
        child: ExitAppWrapper(
          child: Scaffold(
            backgroundColor: AppColors.appBackground,
            body: Stack(
              children: [
                IndexedStack(
                  index: controller.selectedIndex.value,
                  children: controller.pages,
                ),

                  const GlobalChatWidget(bottomMargin: 95.0, rightMargin: 16.0),
              ],
            ),
            // Using extendBody allows the body background to show through the bottom nav transparent areas
            extendBody: true,
            bottomNavigationBar: const _BottomNavBar(),
          ),
        ),
      );
    });
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
          color: Colors.transparent,
          height: 80,
          margin: const EdgeInsets.only(bottom: 0, left: 24, right: 24),
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
                    color: AppColors.background, // Matches the exact light blue background
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
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
                              assetPath: ImageConstant.assignments,
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
                      color: AppColors.primaryPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withValues(alpha: 0.12),
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
            color: isActive ? AppColors.primaryPurple : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.white : AppColors.primaryPurple,
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