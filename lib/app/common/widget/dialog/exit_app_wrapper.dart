

import '../../constant/app_imports.dart';

class ExitAppWrapper extends StatelessWidget {
  final Widget child;

  const ExitAppWrapper({super.key, required this.child});

  Future<bool> _showExitDialog() async {
    bool exitApp = false;

    await Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:  Row(
          children: [
            Icon(Icons.exit_to_app, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Exit App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
          ],
        ),
        content: Text(
          'Are you sure you want to exit the application?',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              exitApp = false;
              Get.back();
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              exitApp = true;
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Exit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return exitApp;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final bool shouldExit = await _showExitDialog();
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}