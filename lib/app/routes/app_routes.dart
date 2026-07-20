// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const HOME = _Paths.HOME;
  static const BOTTOM_NAV_BAR = _Paths.BOTTOM_NAV_BAR;
  static const CONTACTUS = _Paths.CONTACTUS;
  static const PROFILE = _Paths.PROFILE;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const CHANGE_PASSWORD = _Paths.CHANGE_PASSWORD;
  static const ASSIGNMENTS = _Paths.ASSIGNMENTS;
  static const ADD_ORDER = _Paths.ADD_ORDER;
  static const WALLET = _Paths.WALLET;
  static const LOGIN_ONBOARDING = _Paths.LOGIN_ONBOARDING;
  static const ADD_TO_CART = _Paths.ADD_TO_CART;
  static const PAYMENT = _Paths.PAYMENT;
  static const EXPERTS = _Paths.EXPERTS;
  static const RESOURCES = _Paths.RESOURCES;
  static const CHAT = _Paths.CHAT;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const HOME = '/home';
  static const BOTTOM_NAV_BAR = '/bottom-nav-bar';
  static const CONTACTUS = '/contact_us';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const CHANGE_PASSWORD = '/change-password';
  static const ASSIGNMENTS = '/assignments';
  static const ADD_ORDER = '/add-order';
  static const WALLET = '/wallet';
  static const LOGIN_ONBOARDING = '/login-onboarding';
  static const ADD_TO_CART = '/add-to-cart';
  static const PAYMENT = '/payment';
  static const EXPERTS = '/experts';
  static const RESOURCES = '/resources';
  static const CHAT = '/chat';
}
