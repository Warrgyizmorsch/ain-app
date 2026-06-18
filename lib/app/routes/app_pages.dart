import 'package:get/get.dart';

import '../modules/add_order/bindings/add_order_binding.dart';
import '../modules/add_order/views/add_order_view.dart';
import '../modules/add_to_cart/bindings/add_to_cart_binding.dart';
import '../modules/add_to_cart/views/add_to_cart_view.dart';
import '../modules/assignments/bindings/assignments_binding.dart';
import '../modules/assignments/views/assignments_view.dart';
import '../modules/bottom_nav_bar/bindings/bottom_nav_bar_binding.dart';
import '../modules/bottom_nav_bar/views/bottom_nav_bar_view.dart';
import '../modules/contact_us/bindings/contact_us_binding.dart';
import '../modules/contact_us/views/contact_us_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login_onborading/bindings/login_onborading_binding.dart';
import '../modules/login_onborading/views/login_onborading_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/widget/change_password_widget.dart';
import '../modules/profile/widget/edit_profile_widget.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM_NAV_BAR,
      page: () => const BottomNavView(),
      binding: BottomNavBarBinding(),
    ),
    GetPage(
      name: _Paths.CONTACTUS,
      page: () => const ContactUsView(),
      binding: ContactUsBinding(),
    ),

    // Profile
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileWidget(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordWidget(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: _Paths.ASSIGNMENTS,
      page: () => const AssignmentsView(),
      binding: AssignmentsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ORDER,
      page: () => const AddOrderView(),
      binding: AddOrderBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_ONBORADING,
      page: () => const LoginOnboradingView(),
      binding: LoginOnboradingBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TO_CART,
      page: () => const AddToCartView(),
      binding: AddToCartBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
  ];
}
