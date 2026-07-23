
import 'package:ain/app/common/constant/app_imports.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showBackButton = true,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Obx(
            () => AppBar(
          backgroundColor: AppColors.appBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,

          leading: leading ??
              (showBackButton
                  ? IconButton(
                onPressed: Get.back,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, // Back button color fixed
                ),
              )
                  : null),

          title: Text(
            title,
            style: AppTextStyles.appBarTitle,
          ),

          actions: actions,
        ),
      ),
    );
  }
}