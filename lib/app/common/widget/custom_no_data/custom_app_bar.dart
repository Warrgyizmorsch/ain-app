import 'package:ain/app/common/constant/app_imports.dart';


class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
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
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,

      // If leading provided -> show it
      // Else -> show default back button
      leading: leading ??
          (showBackButton
              ? IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios_new),
          )
              : null),

      title: Text(
        title,
        style: AppTextStyles.appBarTitle,
      ),

      actions: actions,
    );
  }
}