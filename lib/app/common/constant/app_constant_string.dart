class AppStrings {
  AppStrings._();

  // ── App ──────────────────────────────────────────────────────────────────────
  static const String appName = 'AIN';

  // ── Common ───────────────────────────────────────────────────────────────────
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String submit = 'Submit';
  static const String save = 'Save';
  static const String update = 'Update';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String search = 'Search';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String done = 'Done';
  static const String retry = 'Retry';
  static const String continue_ = 'Continue';
  static const String addToCart = 'Add to Cart';

  // ── Authentication ───────────────────────────────────────────────────────────
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String register = 'Register';
  static const String forgotPassword = 'Forgot Password?';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String mobileNumber = 'Mobile Number';

  // ── Validation ───────────────────────────────────────────────────────────────
  static const String enterEmail = 'Please enter email';
  static const String enterPassword = 'Please enter password';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String termsRequired =
      'Please accept the terms to continue.';

  // ── Home ─────────────────────────────────────────────────────────────────────
  static const String welcome = 'Welcome';
  static const String dashboard = 'Dashboard';
  static const String profile = 'Profile';
  static const String settings = 'Settings';

  // ── Add Order — AppBar ───────────────────────────────────────────────────────
  static const String orderAssignment = 'Order Assignment';
  static const String orderNow = 'Order Now';

  // ── Add Order — Step Badge ───────────────────────────────────────────────────
  static const String step1of2 = 'Step 1/2';
  static const String step2of2 = 'Step 2/2';
  static const String step3of3 = 'Step 3/3';

  // ── Add Order — Section Heading ──────────────────────────────────────────────
  static const String assignmentDetails = 'Assignment Details';
  static const String assignmentDetailsSub =
      "Tell us what you need — we'll handle the rest.";

  // ── Add Order — Field Labels ─────────────────────────────────────────────────
  static const String assignmentTopic = 'ASSIGNMENT TOPIC';
  static const String subject = 'SUBJECT';
  static const String service = 'SERVICE';
  static const String deadline = 'DEADLINE';
  static const String pages = 'PAGES';
  static const String workType = 'WORK TYPE';
  static const String specifyRequirements =
      'SPECIFY YOUR REQUIREMENTS HERE';

  // ── Add Order — Field Hints ──────────────────────────────────────────────────
  static const String assignmentTopicHint = 'Assignment topic';
  static const String selectSubject = 'Select Subject';
  static const String selectService = 'Select Service';
  static const String deadlineHint = 'MM/DD/YYYY';
  static const String pagesHint = 'Pages';
  static const String selectWorkType = 'Select Work Type';
  static const String requirementsHint =
      'Describe your assignment instructions, formatting style, '
      'deadline, and any specific requirements...';

  // ── Add Order — Upload ───────────────────────────────────────────────────────
  static const String dropFilesHint = 'Drop files here or click to upload';

  // ── Add Order — Price Box ────────────────────────────────────────────────────
  static const String priceDetails = 'Price Details';
  static const String basicPrice = 'Basic Price (USD)';
  static const String discount = 'Discount';
  static const String discountBadge = 'HOT';
  static const String total = 'Total';

  // ── Add Order — Terms ────────────────────────────────────────────────────────
  static const String termsPrefix = 'I have read and I accept the ';
  static const String termsOfUse = 'Terms of Use';
  static const String termsAnd = ' and ';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsMid =
      '. I also consent to the use of cookies for a '
      'personalised experience and acknowledge the terms of the ';
  static const String moneyBackGuarantee = 'Money Back Guarantee';
  static const String termsSuffix = ' applicable to this order.';

  // ── Error ────────────────────────────────────────────────────────────────────
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
  static const String noInternet = 'No internet connection available.';
  static const String serverError = 'Server error. Please try later.';
}