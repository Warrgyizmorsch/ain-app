
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/constant/app_imports.dart';

class UDeviceHelper {
  // uDeviceHelper._();

  //----------TOAST------------//
  static showToast(BuildContext context, String msg,
      {ToastGravity gravity = ToastGravity.BOTTOM}) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: AppColors.primary,
      textColor: AppColors.white,
      fontSize: 15,
    );
  }
  static showErrorToast(BuildContext context, String msg,
      {ToastGravity gravity = ToastGravity.BOTTOM}) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: AppColors.error,
      textColor: AppColors.white,
      fontSize: 15,
    );
  }

  static printLog(String tag, String str) {
    log("$tag -->> $str");
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  static bool isLandscapeOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom == 0;
  }

  static bool isPortraitOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom != 0;
  }

  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  static double getKeyboardHeight(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom;
  }
}