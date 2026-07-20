// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:ain/app/core/models/order_now_model/place_order_request_model.dart';
import 'package:ain/app/core/utils/api/order_now_api/place_order_api.dart';
import '../../../common/constant/app_imports.dart';
import '../../../common/widget/file_picker/app_file_picker.dart'; // Ensure path points to your Custom File Helper
import '../../../core/models/order_now_model/countries_master_model.dart';
import '../../../core/models/order_now_model/services_master_model.dart';
import '../../../core/models/order_now_model/subjects_master_model.dart';
import '../../../core/models/order_now_model/urgencies_master_model.dart';
import '../../../core/models/order_now_model/word_count_master_model.dart';
import '../../../core/models/payment_model/bank_list_model.dart';
import '../../../core/utils/api/order_now_api/order_now_dropdown_api.dart';
import '../../../core/utils/api/payment_api/bank_list_api.dart';

class AddOrderController extends GetxController {
  final isLoading = false.obs;
  final currentStep = 1.obs;
  final isAccepted = false.obs;
  final RxList<File> pickedFiles = <File>[].obs;
  final RxList<BankDetail> banksList = <BankDetail>[].obs;
  final isBankLoading = false.obs;
  // Text Form Controllers
  final topicController = TextEditingController();
  final deadlineController = TextEditingController();
  final pagesController = TextEditingController();
  final requirementsController = TextEditingController();
  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  // Reactive Input Fields Validation Error Hooks
  final fullNameError = RxString('');
  final mobileError = RxString('');
  final emailError = RxString('');
  final topicError = RxString('');

  // Reactive Dropdowns Validation Error Hooks
  final countryError = RxString('');
  final subjectError = RxString('');
  final serviceError = RxString('');
  final workTypeError = RxString('');
  final urgencyError = RxString('');
  final wordCountError = RxString('');

  // Mobile Verification Hooks
  final selectedDialCode = '+1'.obs;
  final isMobileValid = true.obs;

  // Form Dropdown Selections (Using ValueNotifier to map natively with CustomDropdown)
  final selectedSubject = ValueNotifier<SubjectData?>(null);
  final selectedService = ValueNotifier<GetServiceModel?>(null);
  final selectedUrgency = ValueNotifier<UrgencyData?>(null);
  final selectedPageConfig = ValueNotifier<WordCountData?>(null);
  final selectedCountry = ValueNotifier<CountryData?>(null);
  final selectedWorkType = ValueNotifier<String?>(null);

  // Global Calculation Constants (Populated dynamically via Word Count master API)
  final basePricePerWord = 0.0.obs;
  final globalDiscountPercentage = 0.obs;

  // Master Lists
  final RxList<GetServiceModel> services = <GetServiceModel>[].obs;
  final RxList<WordCountData> wordCount = <WordCountData>[].obs;
  final RxList<CountryData> countries = <CountryData>[].obs;
  final RxList<UrgencyData> urgencies = <UrgencyData>[].obs;
  final RxList<SubjectData> subjects = <SubjectData>[].obs;

  // Static Local Dropdown Configurations
  final List<String> workTypes = [
    'Standard',
    'First Class Work',
  ];

  @override
  void onInit() {
    super.onInit();
    // Connect custom listeners to capture underlying ValueNotifier state adjustments
    _attachCalculationListeners();
    // Concurrently download app configuration layers
    fetchAllMasterData();
  }

  // ─── CORE FORM VALIDATIONS ─────────────────────────────────────────────────

  void validateFullName(String value) {
    fullNameError.value = value.trim().isEmpty ? "Full name is required" : "";
  }

  void validateMobileNumber(String value) {
    mobileError.value = value.trim().isEmpty ? "Mobile number is required" : "";
  }

  void validateTopic(String value) {
    topicError.value = value.trim().isEmpty ? "Assignment topic is required" : "";
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!_isValidEmail(value)) {
      emailError.value = 'Please enter a valid email address';
    } else {
      emailError.value = '';
    }
  }

  /// Verifies every mandatory checkout node before allowing user step advancement
  bool validateStep1() {
    // 1. Fire absolute evaluations across inline text inputs
    // validateFullName(nameController.text);
    // validateEmail(emailController.text);
    // validateMobileNumber(mobileController.text);
    validateTopic(topicController.text);

    // 2. Fire evaluations on dropdown items
    // countryError.value = selectedCountry.value == null ? "Please select your country" : "";
    subjectError.value = selectedSubject.value == null ? "Please select a subject area" : "";
    serviceError.value = selectedService.value == null ? "Please select a service type" : "";
    workTypeError.value = selectedWorkType.value == null ? "Please select a work type status tier" : "";
    urgencyError.value = selectedUrgency.value == null ? "Please select an urgency timeline" : "";
    wordCountError.value = selectedPageConfig.value == null ? "Please select a word count configuration level" : "";

    // 3. Complete verification if all error paths run clean
    return
      // fullNameError.value.isEmpty &&
      //   emailError.value.isEmpty &&
      //   mobileError.value.isEmpty &&
        topicError.value.isEmpty &&
        // countryError.value.isEmpty &&
        subjectError.value.isEmpty &&
        serviceError.value.isEmpty &&
        workTypeError.value.isEmpty &&
        urgencyError.value.isEmpty &&
        wordCountError.value.isEmpty;
  }

  // ─── STEP NAVIGATION CONTROLS ──────────────────────────────────────────────

  void onContinue() {
    if (validateStep1()) {
      currentStep.value = 3;
    } else {
      Get.snackbar(
        'Validation Failed',
        'Please complete all highlighted input fields and dropdown selections.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha:0.1),
        colorText: Colors.red,
      );
    }
  }

  void onBack() {
    currentStep.value = 1;
  }

  void toggleAccepted() {
    isAccepted.value = !isAccepted.value;
  }

  /// Pipes external model selections to the GetX update lifecycle loop
  void _attachCalculationListeners() {
    selectedPageConfig.addListener(() => update());
    selectedService.addListener(() => update());
    selectedUrgency.addListener(() => update());
    selectedWorkType.addListener(() => update());
  }

  // ─── DYNAMIC PRICING SYSTEM ENGINE ────────────────────────────────────────

  double get baseCost {
    if (selectedPageConfig.value == null) {
      _logCalculationDebug("Base Cost calculation skipped: No Word Count configuration selected yet.");
      return 0.0;
    }

    final int totalWords = selectedPageConfig.value!.value;
    final double pageTierMultiplier = selectedPageConfig.value!.multiplier;
    final double currentBasePrice = basePricePerWord.value;

    final double computedBase = (currentBasePrice * totalWords) * pageTierMultiplier;

    _logCalculationDebug(
        "📐 STEP 1: [Base Cost Calculation]\n"
            "   • Words: $totalWords\n"
            "   • Base Price Per Word: $currentBasePrice\n"
            "   • Page Tier Multiplier: $pageTierMultiplier\n"
            "   • Resulting Base Cost: £${computedBase.toStringAsFixed(2)}"
    );

    return computedBase;
  }

  double get estimatedPrice {
    if (selectedPageConfig.value == null) return 0.0;

    final double currentBaseCost = baseCost;
    final double serviceMultiplier = selectedService.value?.multiplier ?? 1.0;
    final double urgencyMultiplier = selectedUrgency.value?.multiplier ?? 1.0;

    // Fixed: Matches 'First Class Work' dropdown item perfectly
    final double typeMultiplier = (selectedWorkType.value == 'First Class Work') ? 1.3 : 1.0;

    final double computedEstimated = currentBaseCost * serviceMultiplier * typeMultiplier * urgencyMultiplier;

    _logCalculationDebug(
        "⚙️ STEP 2: [Estimated Price Multipliers]\n"
            "   • Running Base Cost Context: £${currentBaseCost.toStringAsFixed(2)}\n"
            "   • Service Multiplier: $serviceMultiplier (${selectedService.value?.name ?? 'None'})\n"
            "   • Work Type Multiplier: $typeMultiplier (${selectedWorkType.value ?? 'None'})\n"
            "   • Urgency Multiplier: $urgencyMultiplier (${selectedUrgency.value?.name ?? 'None'})\n"
            "   • Total Estimated Sum: £${computedEstimated.toStringAsFixed(2)}"
    );

    return computedEstimated;
  }

  double get finalPrice {
    final double currentEstimated = estimatedPrice;
    if (currentEstimated == 0.0) return 0.0;

    final int currentDiscountPercent = globalDiscountPercentage.value;
    final double discountFactor = (100 - currentDiscountPercent) / 100;
    final double computedFinal = currentEstimated * discountFactor;

    _logCalculationDebug(
        "💰 STEP 3: [Final Discount Application]\n"
            "   • Subtotal Estimated: £${currentEstimated.toStringAsFixed(2)}\n"
            "   • System Markdown: $currentDiscountPercent%\n"
            "   • Total Final Balance: £${computedFinal.toStringAsFixed(2)}\n"
            "===================================================="
    );

    return computedFinal;
  }

  /// 4. Evaluates total user financial markdown discount amounts
  double get savingsAmount {
    final double discountFraction = globalDiscountPercentage.value / 100;
    return estimatedPrice * discountFraction;
  }

  // ─── STRING FINESSE UI FORMATTERS ──────────────────────────────────────────
  String get formattedEstimatedPrice => '£${estimatedPrice.toStringAsFixed(2)}';
  String get formattedDiscount       => '${globalDiscountPercentage.value}% OFF (£${savingsAmount.toStringAsFixed(2)})';
  String get formattedFinalPrice     => '£${finalPrice.toStringAsFixed(2)}';

  void _logCalculationDebug(String message) {
    if (Get.isLogEnable) {
      debugPrint('================ [ENGINE CALCULATION] ================');
      debugPrint(message);
    }
  }

  // ─── CONCURRENT LOOKUP INIT API LAYER ──────────────────────────────────────

  Future<void> fetchAllMasterData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        getServices(),
        getWordCount(),
        getCountries(),
        getUrgencies(),
        getSubjects(),
        bankList(),
      ]);

    } catch (e) {
      Get.snackbar('Error', 'Error pairing network drop configurations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getServices() async {
    try {
      final response = await OrderNowDropdownApi.getServices();
      if (response.success) {
        services.assignAll(response.data);
      }
    } catch (e) {
      debugPrint('Services downstream loading failed: $e');
    }
  }

  Future<void> getWordCount() async {
    try {
      final response = await OrderNowDropdownApi.getWordCount();
      if (response.success) {
        basePricePerWord.value = (response.basePricePerWord as num?)?.toDouble() ?? 0.03;
        globalDiscountPercentage.value = (response.discountPercentage as num?)?.toInt() ?? 40;

        wordCount.assignAll(response.data);

        // Pre-selects first dictionary node layout item to solve initial empty 0 computations
        if (wordCount.isNotEmpty) {
          selectedPageConfig.value = wordCount.first;
        }
      }
    } catch (e) {
      debugPrint('Word Count tiers lookup crash fallback: $e');
    }
  }

  Future<void> getCountries() async {
    try {
      final response = await OrderNowDropdownApi.getCountries();
      if (response.success) {
        countries.assignAll(response.data);
      }
    } catch (e) {
      debugPrint('Countries metadata retrieval error: $e');
    }
  }

  Future<void> getUrgencies() async {
    try {
      final response = await OrderNowDropdownApi.getUrgencies();
      if (response.success) {
        urgencies.assignAll(response.data);
      }
    } catch (e) {
      debugPrint('Urgencies parameters collection failed: $e');
    }
  }

  Future<void> getSubjects() async {
    try {
      final response = await OrderNowDropdownApi.getSubjects();
      if (response.success) {
        subjects.assignAll(response.data);
      }
    } catch (e) {
      debugPrint('Academic subjects configuration exception: $e');
    }
  }

  // ─── NATIVE ENCAPSULATED ATTACHMENT DRIVERS ───────────────────────────────

  Future<void> pickFile() async {
    try {
      isLoading.value = true;
      // Triggers multi-format extraction via decoupled Helper module class safely
      final List<File> selectedFiles = await AppFilePickerHelper.pickMultipleFiles();

      if (selectedFiles.isNotEmpty) {
        pickedFiles.addAll(selectedFiles);
      }
    } catch (e) {
      Get.snackbar('File Error', 'Failed to resolve chosen documents: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < pickedFiles.length) {
      pickedFiles.removeAt(index);
    }
  }
  Future<void> bankList() async {
    try {
      isBankLoading.value = true;

      final response = await BankListApi.getBankList();

      if (response.success == true && response.data != null) {
        banksList.assignAll(response.data!);
      } else {
        Get.snackbar(
          'Error',
          'Failed to load bank details',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Bank List Error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong while fetching banks.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isBankLoading.value = false;
    }
  }
  Future<void> addToCart() async {
    // 1. Terms and Conditions validation check
    if (!isAccepted.value) {
      Get.snackbar(
        'Terms Required',
        'Please check the terms and conditions policy checkbox before routing order details.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amberAccent.withValues(alpha:0.1),
        colorText: Colors.black87,
      );
      return;
    }

    // 2. Final security check to ensure no empty or invalid data slips through
    if (!validateStep1()) {
      Get.snackbar(
        'Validation Failed',
        'Please complete all highlighted input fields and dropdown selections.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha:0.1),
        colorText: Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;

      String cleanMobile = mobileController.text.trim().replaceAll(RegExp(r'[^\d]'), '');
      String cleanDialCode = selectedDialCode.value.replaceAll('+', '').trim();

      if (cleanMobile.startsWith(cleanDialCode) && cleanMobile.length > 10) {
        cleanMobile = cleanMobile.substring(cleanDialCode.length);
      }

      if (cleanMobile.startsWith('0') && cleanMobile.length > 10) {
        cleanMobile = cleanMobile.substring(1);
      }

      PlaceOrderRequest request = PlaceOrderRequest(
        // name: nameController.text.trim(),
        // email: emailController.text.trim(),
        // country: selectedCountry.value?.name ?? "",
        // countryCode: cleanDialCode,
        // mobile: cleanMobile,
        service: selectedService.value?.name ?? "",
        workType: selectedWorkType.value ?? "Standard",
        subject: selectedSubject.value?.name ?? "",
        urgency: selectedUrgency.value?.id.toString() ?? "5",
        wordCount: selectedPageConfig.value?.value ?? 0,
        topic: topicController.text.trim(),
        requirements: requirementsController.text.trim(),
        finalPrice: finalPrice.toStringAsFixed(2),
        sourcePage: "Mobile App",
      );

      // 5. Network boundary execute karna
      final response = await PlaceOrderApi.placeOrder(
        request: request,
        files: pickedFiles,
      );

      // 6. Response standard verification logic
      if (response != null && response.success == true) {
        Get.snackbar(
          'Order Placed',
          response.message ?? 'Your assignment order has been submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha:0.1),
          colorText: Colors.green,
        );

        // Optional: Reset fields after successful submission


        // Target navigation stack cleanup routing
        Get.offNamed(
          Routes.PAYMENT,
          arguments: {
            'orderId': response.orderId,
            'topic': topicController.text.trim(),
            'pages': selectedPageConfig.value?.name ?? '',
            'deadline': selectedUrgency.value?.name ?? '',
            'amount': finalPrice.toStringAsFixed(2),
            'service': selectedService.value?.name ?? '',
            'discount':savingsAmount.toStringAsFixed(2),
            'basePrice':formattedEstimatedPrice
          },
        );
        clearAllFields();
      } else {
        Get.snackbar(
          'Submission Error',
          response.message ?? 'Failed to complete order submission. Try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha:0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      debugPrint('CRITICAL DISPATCH ERROR: $e');
      Get.snackbar(
        'Network Error',
        'Something went wrong while transmitting data layer: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha:0.1),
        colorText: Colors.red,
      );
    } finally {
      // 7. Reset loader configuration footprint
      isLoading.value = false;
    }
  }

  /// Helper utility to scrub memory maps clean post successful execution checkout
  void clearAllFields() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    topicController.clear();
    requirementsController.clear();
    pickedFiles.clear();

    selectedSubject.value = null;
    selectedService.value = null;
    selectedUrgency.value = null;
    selectedCountry.value = null;
    selectedWorkType.value = null;
    isAccepted.value = false;
  }

  @override
  void onClose() {
    // Release Text Form memory footprints
    topicController.dispose();
    deadlineController.dispose();
    pagesController.dispose();
    requirementsController.dispose();
    mobileController.dispose();
    nameController.dispose();
    emailController.dispose();

    // Release tracking hooks structures cleanly
    selectedSubject.dispose();
    selectedService.dispose();
    selectedUrgency.dispose();
    selectedPageConfig.dispose();
    selectedCountry.dispose();
    selectedWorkType.dispose();

    super.onClose();
  }
}