// ignore_for_file: constant_identifier_names


class ApiConstant {
  static const BASE_URL = "https://ain.warrgyizmorsch.com/api/";
  static const Webview_URL = "https://www.assignnmentinneed.com/PrivacyPolicy";

  static const String FALLBACK_BEARER_TOKEN =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjEiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiU3VwZXIgQWRtaW4iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsIlJvbGVJZCI6IjEiLCJDb21wYW55SWQiOiIxIiwiZXhwIjoxNzYzNDY5ODA5LCJpc3MiOiJZYWNodEJvb2tpbmciLCJhdWQiOiJZYWNodEJvb2tpbmctVXNlcnMifQ.-KP5dh4wHR_MdL_gYRjOi3rqqhGKX6wVjTn_Vq08990";



  // ---------- BOOKING ----------


  static String get baseOrigin {
    final baseUri = Uri.parse(BASE_URL);
    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
    ).toString();
  }

  static String resolveAssetUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final origin = baseOrigin.endsWith('/') ? baseOrigin : '$baseOrigin/';
    return Uri.parse(origin).resolve(normalizedPath).toString();
  }

  // Auth Endpoints
  static const String LOGIN = "app/login";
  static const String REGISTER = "app/register";
  static const String SERVICES = "app/services";
  static const String COUNTRIES = "app/countries";
  static const String WORD_COUNT = "app/word-count";
  static const String URGENCIES = "app/urgencies";
  static const String SUBJECTS = "app/subjects";
  static const String WORK_TYPES = "app/work-types";
  static const String PLACE_ORDER = "app/place-order";
  static const String EDIT_ORDER = "app/edit-order";
  static const String ORDER_LIST = "app/order-list";
  static const String RESET_PASSWORD = "app/reset-password";
  static const String RAISE_TICKET = "app/raise-ticket";
  static const String SUBMIT_FEEDBACK = "submit-feedback";
  static const String samplesList = "samples";
  static const String samplesCategory = "sample-categories";
  static const String writerList = "writer-list";
  static const String experts = "experts";
  static const String googleLogin = "app/google-login";
  static const String forgotPassword = "app/forgot-password";
  static const String forgotPasswordOtp = "app/verify-forgot-password-otp";
  static const String resetPassword = "app/reset-password";
  static const String wallet = "app/wallet-amount";
  static const String walletList = "app/wallet-history";
  static const String bankList = "app/banks";
  static const String addPayment = "app/add-payment";
  static const String profileUpdate = "app/profile-update";
  static const String profile = "app/profile";






}

