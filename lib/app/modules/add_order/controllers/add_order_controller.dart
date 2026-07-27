// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:ain/app/core/models/order_now_model/place_order_request_model.dart';
import 'package:ain/app/core/utils/api/order_now_api/place_order_api.dart';
import '../../../common/constant/app_imports.dart';
import '../../../common/widget/file_picker/app_file_picker.dart';
import '../../../core/utils/api/wallet_api/wallet_api_endpoint.dart';
import '../../../core/models/experts_model/experts_list_response_model.dart';
import '../../../core/models/order_now_model/countries_master_model.dart';
import '../../../core/models/order_now_model/services_master_model.dart';
import '../../../core/models/order_now_model/subjects_master_model.dart';
import '../../../core/models/order_now_model/urgencies_master_model.dart';
import '../../../core/models/order_now_model/word_count_master_model.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../../../core/models/payment_model/bank_list_model.dart';
import '../../../core/utils/api/order_now_api/order_now_dropdown_api.dart';
import '../../../core/utils/api/payment_api/bank_list_api.dart';
import '../../../core/models/order_now_model/edit_order_request_model.dart';
import '../../../core/utils/api/order_now_api/edit_order_api.dart';
import '../../assignments/controllers/assignments_controller.dart';
import '../../bottom_nav_bar/controllers/bottom_nav_bar_controller.dart';

class AddOrderController extends GetxController {
  final isLoading = false.obs;
  final currentStep = 1.obs;
  final isAccepted = false.obs;
  final RxList<File> pickedFiles = <File>[].obs;
  final RxList<BankDetail> banksList = <BankDetail>[].obs;
  final isBankLoading = false.obs;
  final selectedExpert = Rxn<ExpertData>();

  // Wallet State
  final walletBalance = 0.0.obs;
  final walletCurrency = '£'.obs;
  final useWallet = false.obs;
  final isWalletLoading = false.obs;

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
  final wordCountTextController = TextEditingController(text: '250');
  // Mobile Verification Hooks
  final selectedDialCode = '+1'.obs;
  final isMobileValid = true.obs;

  // Form Dropdown Selections
  final selectedSubject = ValueNotifier<SubjectData?>(null);
  final selectedService = ValueNotifier<GetServiceModel?>(null);
  final selectedUrgency = ValueNotifier<UrgencyData?>(null);
  final selectedPageConfig = ValueNotifier<WordCountData?>(null);
  final selectedCountry = ValueNotifier<CountryData?>(null);
  final selectedWorkType = ValueNotifier<String?>(null);

  // Global Calculation Constants
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

  dynamic editingOrderData;
  final currentWordCount = 250.obs;

  @override
  void onInit() {
    super.onInit();
    _attachCalculationListeners();
    updateWordCountConfig();
    fetchAllMasterData();
  }

  void updateWordCountConfig() {
    final int count = currentWordCount.value;

    // Ensure word count never drops below 250 on the UI side
    final int validCount = count < 250 ? 250 : count;
    final int pages = validCount ~/ 250;
    final pageText = pages == 1 ? 'Page' : 'Pages';

    // Multiplier defaults to 1.0 since it is handled directly in baseCost via getWordCountMultiplier
    selectedPageConfig.value = WordCountData(
      id: validCount,
      name: '$pages $pageText / $validCount Words',
      value: validCount,
      multiplier: 1.0,
    );

    wordCountError.value = '';
    update();
  }

  void incrementWordCount() {
    currentWordCount.value += 250;
    wordCountTextController.text = currentWordCount.value.toString();
    updateWordCountConfig();
  }

  void decrementWordCount() {
    if (currentWordCount.value > 250) {
      currentWordCount.value -= 250;
      wordCountTextController.text = currentWordCount.value.toString();
      updateWordCountConfig();
    }
  }

  void setWordCount(int count) {
    // Only clamp to 250 if it's triggered by chips, allow free typing otherwise
    if (count < 250) count = 250;
    currentWordCount.value = count;
    wordCountTextController.text = currentWordCount.value.toString();
    updateWordCountConfig();
  }
  @override
  void onReady() {
    super.onReady();
    populateFormFromArguments();
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

  bool validateStep1() {
    validateTopic(topicController.text);

    subjectError.value = selectedSubject.value == null ? "Please select a subject area" : "";
    serviceError.value = selectedService.value == null ? "Please select a service type" : "";
    workTypeError.value = selectedWorkType.value == null ? "Please select a work type status tier" : "";
    urgencyError.value = selectedUrgency.value == null ? "Please select an urgency timeline" : "";
    wordCountError.value = selectedPageConfig.value == null ? "Please select a word count configuration level" : "";

    return topicError.value.isEmpty &&
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

  void _attachCalculationListeners() {
    selectedPageConfig.addListener(() => update());
    selectedService.addListener(() => update());
    selectedUrgency.addListener(() => update());
    selectedWorkType.addListener(() => update());
  }

  // ─── DYNAMIC PRICING SYSTEM ENGINE ────────────────────────────────────────

  /// Retrieves the specific word-count multiplier based on the pricing table.
  double getWordCountMultiplier(int wordCount) {
    if (wordCount >= 250 && wordCount <= 499) return 2.67;
    if (wordCount >= 500 && wordCount <= 999) return 2.22;
    if (wordCount >= 1000 && wordCount <= 1999) return 1.94;
    if (wordCount >= 2000 && wordCount <= 2999) return 1.67;
    if (wordCount >= 3000 && wordCount <= 3999) return 1.30;
    if (wordCount >= 4000 && wordCount <= 4999) return 1.13;
    if (wordCount >= 5000) return 1.17;

    // Fallback for anything strictly under 250 (though it should be clamped to 250)
    return 2.67;
  }

  double get baseCost {
    if (selectedPageConfig.value == null) return 0.0;

    final int totalWords = selectedPageConfig.value!.value;

    // Formula rule: max(Word Count, 250)
    final int validWords = totalWords < 250 ? 250 : totalWords;
    final double ratePerWord = basePricePerWord.value;

    // 1. Get the exact multiplier from the bracket table
    final double pageTierMultiplier = getWordCountMultiplier(validWords);

    // 2. Calculate the base cost including the bracket multiplier
    final double computedBase = (validWords * ratePerWord) * pageTierMultiplier;

    _logCalculationDebug(
        "Base Cost Calculation:\n"
            "Words: $validWords\n"
            "Rate: £$ratePerWord\n"
            "Tier Multiplier: $pageTierMultiplier\n"
            "Result: £${computedBase.toStringAsFixed(2)}"
    );

    return computedBase;
  }

  double get estimatedPrice {
    if (selectedPageConfig.value == null) return 0.0;

    final double currentBaseCost = baseCost; // Includes the word-tier multiplier

    final double serviceMultiplier = selectedService.value?.multiplier ?? 1.0;
    final double urgencyMultiplier = selectedUrgency.value?.multiplier ?? 1.0;

    // Explicit configuration values for work type
    final double typeMultiplier = (selectedWorkType.value == 'First Class Work') ? 1.3 : 1.0;

    // Formula rule: Base Price x Service Multiplier x Work-Type Multiplier x Urgency Multiplier
    return currentBaseCost * serviceMultiplier * typeMultiplier * urgencyMultiplier;
  }

  double get finalPrice {
    final double currentEstimated = estimatedPrice;
    if (currentEstimated == 0.0) return 0.0;

    // Formula rule: round(Estimated Price x (1 - Discount Rate), 2)
    final double discountRate = globalDiscountPercentage.value / 100.0;
    final double computedFinal = currentEstimated * (1 - discountRate);

    // Rounding is strictly applied to the final monetary result to two decimal places
    return double.parse(computedFinal.toStringAsFixed(2));
  }

  double get savingsAmount {
    // Calculates the exact amount saved for the UI
    final double discountRate = globalDiscountPercentage.value / 100.0;
    return estimatedPrice * discountRate;
  }

  // ─── WALLET DEDUCTION CALCULATIONS ────────────────────────────────────────

  double get walletDeduction {
    if (!useWallet.value) return 0.0;
    final currentFinal = finalPrice;
    final balance = walletBalance.value;
    return balance >= currentFinal ? currentFinal : balance;
  }

  double get netPayablePrice {
    final net = finalPrice - walletDeduction;
    return net < 0 ? 0.0 : net;
  }

  // ─── STRING FINESSE UI FORMATTERS ──────────────────────────────────────────
  String get formattedEstimatedPrice => '£${estimatedPrice.toStringAsFixed(2)}';
  String get formattedDiscount       => '${globalDiscountPercentage.value}% OFF (£${savingsAmount.toStringAsFixed(2)})';
  String get formattedFinalPrice     => '£${finalPrice.toStringAsFixed(2)}';
  String get formattedWalletDeduction => '- ${walletCurrency.value}${walletDeduction.toStringAsFixed(2)}';
  String get formattedNetPayablePrice => '${walletCurrency.value}${netPayablePrice.toStringAsFixed(2)}';

  void toggleUseWallet() {
    useWallet.value = !useWallet.value;
    update();
  }

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
        fetchWalletAmount(),
      ]);

      populateFormFromArguments();
    } catch (e) {
      Get.snackbar('Error', 'Error pairing network drop configurations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'GBP':
      case 'USD':
        return '£';
      case 'EUR':
        return '€';
      default:
        return currencyCode.isEmpty ? '£' : currencyCode;
    }
  }

  Future<void> fetchWalletAmount() async {
    try {
      isWalletLoading.value = true;
      final response = await WalletApiEndpoint.getWalletAmount();
      if (response.success) {
        walletBalance.value = response.data.walletAmount.toDouble();
        walletCurrency.value = getCurrencySymbol(response.data.currency);
      }
    } catch (e) {
      debugPrint('Wallet fetch error in AddOrderController: $e');
    } finally {
      isWalletLoading.value = false;
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
        updateWordCountConfig();
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

  String? _getEditingOrderId() {
    if (editingOrderData == null) return null;
    if (editingOrderData is Lead) {
      return (editingOrderData as Lead).orderId;
    }
    if (editingOrderData is ConfirmedOrder) {
      return (editingOrderData as ConfirmedOrder).orderId;
    }
    if (editingOrderData is Map) {
      return editingOrderData['orderId']?.toString() ?? editingOrderData['order_id']?.toString();
    }
    return null;
  }

  bool get isEditingOrder {
    if (editingOrderData == null) return false;
    if (editingOrderData is Lead || editingOrderData is ConfirmedOrder) return true;
    if (editingOrderData is Map) {
      final map = editingOrderData as Map;
      return (map['orderId'] != null || map['order_id'] != null) && map['expert'] == null;
    }
    return false;
  }

  void populateFormFromArguments() {
    final arg = Get.arguments;
    if (arg == null) return;
    editingOrderData = arg;

    ExpertData? expert;
    bool selectExpertOnly = false;

    if (arg is ExpertData) {
      expert = arg;
    } else if (arg is Map) {
      if (arg['expert'] is ExpertData) {
        expert = arg['expert'] as ExpertData;
      }
      selectExpertOnly = arg['selectExpertOnly'] == true || arg['expertOnly'] == true;
    }

    if (expert != null) {
      selectedExpert.value = expert;

      if (!selectExpertOnly) {
        if (expert.service != null && expert.service!.isNotEmpty && services.isNotEmpty) {
          try {
            final target = expert.service!.toLowerCase().trim();
            final matched = services.firstWhere(
                  (s) => s.name.toLowerCase().trim() == target,
              orElse: () => services.firstWhere(
                    (s) => s.name.toLowerCase().contains(target) || target.contains(s.name.toLowerCase()),
                orElse: () => services.first,
              ),
            );
            selectedService.value = matched;
          } catch (_) {}
        }

        if (expert.subject != null && expert.subject!.isNotEmpty && subjects.isNotEmpty) {
          try {
            final target = expert.subject!.toLowerCase().trim();
            final matched = subjects.firstWhere(
                  (sub) => sub.name.toLowerCase().trim() == target,
              orElse: () => subjects.firstWhere(
                    (sub) => sub.name.toLowerCase().contains(target) || target.contains(sub.name.toLowerCase()),
                orElse: () => subjects.first,
              ),
            );
            selectedSubject.value = matched;
          } catch (_) {}
        }
      }
    } else if (arg is Lead) {
      final lead = arg;

      if (lead.name != null && lead.name!.isNotEmpty) {
        topicController.text = lead.name!;
      } else if (lead.orderId != null && lead.orderId!.isNotEmpty) {
        topicController.text = 'Order #${lead.orderId}';
      }

      if (lead.requirements != null && lead.requirements!.isNotEmpty) {
        requirementsController.text = lead.requirements!;
      }

      if (lead.service != null && lead.service!.isNotEmpty && services.isNotEmpty) {
        try {
          final target = lead.service!.toLowerCase().trim();
          final matched = services.firstWhere(
                (s) => s.name.toLowerCase().trim() == target,
            orElse: () => services.firstWhere(
                  (s) => s.name.toLowerCase().contains(target) || target.contains(s.name.toLowerCase()),
              orElse: () => services.first,
            ),
          );
          selectedService.value = matched;
        } catch (_) {}
      }

      if (lead.subject != null && lead.subject!.isNotEmpty && subjects.isNotEmpty) {
        try {
          final target = lead.subject!.toLowerCase().trim();
          final matched = subjects.firstWhere(
                (sub) => sub.name.toLowerCase().trim() == target,
            orElse: () => subjects.firstWhere(
                  (sub) => sub.name.toLowerCase().contains(target) || target.contains(sub.name.toLowerCase()),
              orElse: () => subjects.first,
            ),
          );
          selectedSubject.value = matched;
        } catch (_) {}
      }

      if (lead.workType != null && lead.workType!.isNotEmpty) {
        try {
          final target = lead.workType!.toLowerCase().trim();
          final matchedWorkType = workTypes.firstWhere(
                (wt) => wt.toLowerCase().trim() == target,
            orElse: () => workTypes.firstWhere(
                  (wt) => target.contains(wt.toLowerCase()) || wt.toLowerCase().contains(target),
              orElse: () => workTypes.first,
            ),
          );
          selectedWorkType.value = matchedWorkType;
        } catch (_) {}
      }

      if (lead.deadline != null && lead.deadline!.isNotEmpty && urgencies.isNotEmpty) {
        try {
          final target = lead.deadline!.toLowerCase().trim();
          final matchedUrgency = urgencies.firstWhere(
                (u) => u.name.toLowerCase().trim() == target,
            orElse: () => urgencies.firstWhere(
                  (u) => u.name.toLowerCase().contains(target) || target.contains(u.name.toLowerCase()),
              orElse: () => urgencies.first,
            ),
          );
          selectedUrgency.value = matchedUrgency;
        } catch (_) {}
      }

      if (lead.wordCount != null && lead.wordCount!.isNotEmpty && wordCount.isNotEmpty) {
        try {
          final cleanWordCount = lead.wordCount!.replaceAll(RegExp(r'[^0-9]'), '');
          if (cleanWordCount.isNotEmpty) {
            final parsedCount = int.tryParse(cleanWordCount);
            if (parsedCount != null) {
              final matchedWord = wordCount.firstWhere(
                    (w) => w.value == parsedCount,
                orElse: () => wordCount.firstWhere(
                      (w) => w.name.toLowerCase().contains(lead.wordCount!.toLowerCase()) || lead.wordCount!.toLowerCase().contains(w.name.toLowerCase()),
                  orElse: () => wordCount.first,
                ),
              );
              selectedPageConfig.value = matchedWord;
            }
          }
        } catch (_) {}
      }

      if (lead.countrycode != null && lead.countrycode!.isNotEmpty && countries.isNotEmpty) {
        try {
          final target = lead.countrycode!.toLowerCase().trim();
          final matchedCountry = countries.firstWhere(
                (c) => c.name.toLowerCase().trim() == target,
            orElse: () => countries.firstWhere(
                  (c) => c.name.toLowerCase().contains(target) || target.contains(c.name.toLowerCase()),
              orElse: () => countries.first,
            ),
          );
          selectedCountry.value = matchedCountry;
        } catch (_) {}
      }
    } else if (arg is ConfirmedOrder) {
      final order = arg;
      if (order.title != null && order.title!.isNotEmpty) {
        topicController.text = order.title!;
      }

      if (order.subject != null && order.subject!.isNotEmpty && subjects.isNotEmpty) {
        try {
          final target = order.subject!.toLowerCase().trim();
          final matched = subjects.firstWhere(
                (sub) => sub.name.toLowerCase().trim() == target,
            orElse: () => subjects.first,
          );
          selectedSubject.value = matched;
        } catch (_) {}
      }

      if (order.wordCount != null && order.wordCount!.isNotEmpty && wordCount.isNotEmpty) {
        try {
          final cleanWordCount = order.wordCount!.replaceAll(RegExp(r'[^0-9]'), '');
          if (cleanWordCount.isNotEmpty) {
            final parsedCount = int.tryParse(cleanWordCount);
            if (parsedCount != null) {
              final matchedWord = wordCount.firstWhere((w) => w.value == parsedCount, orElse: () => wordCount.first);
              selectedPageConfig.value = matchedWord;
            }
          }
        } catch (_) {}
      }
    } else if (arg is Map<String, dynamic>) {
      if (arg['topic'] != null) topicController.text = arg['topic'].toString();
      if (arg['name'] != null) topicController.text = arg['name'].toString();
      if (arg['requirements'] != null) requirementsController.text = arg['requirements'].toString();

      if (arg['service'] != null && services.isNotEmpty) {
        try {
          final target = arg['service'].toString().toLowerCase().trim();
          final matched = services.firstWhere(
                (s) => s.name.toLowerCase().trim() == target,
            orElse: () => services.first,
          );
          selectedService.value = matched;
        } catch (_) {}
      }

      if (arg['subject'] != null && subjects.isNotEmpty) {
        try {
          final target = arg['subject'].toString().toLowerCase().trim();
          final matched = subjects.firstWhere(
                (sub) => sub.name.toLowerCase().trim() == target,
            orElse: () => subjects.first,
          );
          selectedSubject.value = matched;
        } catch (_) {}
      }

      if (arg['workType'] != null) {
        try {
          final target = arg['workType'].toString().toLowerCase().trim();
          final matchedWorkType = workTypes.firstWhere(
                (wt) => wt.toLowerCase().trim() == target,
            orElse: () => workTypes.first,
          );
          selectedWorkType.value = matchedWorkType;
        } catch (_) {}
      }

      if (arg['urgency'] != null && urgencies.isNotEmpty) {
        try {
          final target = arg['urgency'].toString().toLowerCase().trim();
          final matchedUrgency = urgencies.firstWhere(
                (u) => u.name.toLowerCase().trim() == target,
            orElse: () => urgencies.first,
          );
          selectedUrgency.value = matchedUrgency;
        } catch (_) {}
      }

      if (arg['wordCount'] != null && wordCount.isNotEmpty) {
        try {
          final cleanWordCount = arg['wordCount'].toString().replaceAll(RegExp(r'[^0-9]'), '');
          if (cleanWordCount.isNotEmpty) {
            final parsedCount = int.tryParse(cleanWordCount);
            if (parsedCount != null) {
              final matchedWord = wordCount.firstWhere((w) => w.value == parsedCount, orElse: () => wordCount.first);
              selectedPageConfig.value = matchedWord;
            }
          }
        } catch (_) {}
      }
    }
  }

  // ─── NATIVE ENCAPSULATED ATTACHMENT DRIVERS ───────────────────────────────

  Future<void> pickFile() async {
    try {
      isLoading.value = true;
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
    if (!isAccepted.value) {
      Get.snackbar(
        'Terms Required',
        'Please check the terms and conditions policy checkbox before routing order details.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amberAccent.withValues(alpha: 0.1),
        colorText: Colors.black87,
      );
      return;
    }

    if (!validateStep1()) {
      Get.snackbar(
        'Validation Failed',
        'Please complete all highlighted input fields and dropdown selections.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;

      PlaceOrderRequest request = PlaceOrderRequest(
        service: selectedService.value?.name ?? "",
        workType: selectedWorkType.value ?? "Standard",
        subject: selectedSubject.value?.name ?? "",
        urgency: selectedUrgency.value?.id.toString() ?? "5",
        wordCount: selectedPageConfig.value?.value ?? 0,
        topic: topicController.text.trim(),
        requirements: requirementsController.text.trim(),
        sourcePage: selectedExpert.value != null ? "Expert Profile" : "Mobile App",
        expertId: selectedExpert.value?.id?.toString(),
        expertName: selectedExpert.value?.name,
        useWallet: useWallet.value,
        finalPrice: finalPrice.toStringAsFixed(2),
      );

      final existingOrderId = _getEditingOrderId();
      if (existingOrderId != null && existingOrderId.isNotEmpty) {
        EditOrderRequest editRequest = EditOrderRequest(
          orderId: existingOrderId,
          service: selectedService.value?.name ?? "",
          workType: selectedWorkType.value ?? "Standard",
          subject: selectedSubject.value?.name ?? "",
          urgency: selectedUrgency.value?.id.toString() ?? "5",
          wordCount: selectedPageConfig.value?.value ?? 0,
          topic: topicController.text.trim(),
          requirements: requirementsController.text.trim(),
          sourcePage: "Mobile App",
          expertId: selectedExpert.value?.id?.toString(),
          expertName: selectedExpert.value?.name,
          useWallet: useWallet.value,
          walletAmount: walletDeduction.toStringAsFixed(2),
          finalPrice: netPayablePrice.toStringAsFixed(2),
        );

        final response = await EditOrderApi.editOrder(
          request: editRequest,
          files: pickedFiles,
        );

        if (response != null && response.success == true) {
          clearAllFields();

          double pending = netPayablePrice - (useWallet.value ? walletDeduction : 0);

          await _showSuccessDialogAndRoute(
            orderId: existingOrderId,
            walletDeductedAmount: useWallet.value ? walletDeduction : 0,
            dueAmount: pending > 0 ? pending : 0,
          );
          return;
        } else {
          Get.snackbar(
            'Update Error',
            response.message ?? 'Failed to update order. Try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
          return;
        }
      }

      final response = await PlaceOrderApi.placeOrder(
        request: request,
        files: pickedFiles,
      );

      if (response != null && response.success == true) {
        clearAllFields();
        await _showSuccessDialogAndRoute(
          orderId: response.orderId?.toString() ?? "N/A",
          walletDeductedAmount: response.walletDeducted,
          dueAmount: response.dueAmount,
        );
      } else {
        Get.snackbar(
          'Submission Error',
          response.message ?? 'Failed to complete order submission. Try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      debugPrint('CRITICAL DISPATCH ERROR: $e');
      Get.snackbar(
        'Network Error',
        'Something went wrong while transmitting data layer: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _showSuccessDialogAndRoute({
    required String orderId,
    dynamic walletDeductedAmount,
    dynamic dueAmount,
  }) async {

    double deductedAmount = 0.0;
    if (walletDeductedAmount != null) {
      deductedAmount = double.tryParse(walletDeductedAmount.toString()) ?? 0.0;
    }

    // Parse the due amount safely
    double pendingAmount = 0.0;
    if (dueAmount != null) {
      pendingAmount = double.tryParse(dueAmount.toString()) ?? 0.0;
    }

    // 1. Show the dialog
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Success!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Text(
                'Order ID: $orderId',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
              ),

              const SizedBox(height: 16),

              // 2. Conditionally show wallet amount if it was used
              if (deductedAmount > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                    'Wallet Deducted: £${deductedAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue),
                  ),
                ),
              ],

              // 3. Conditionally show Pending or Complete status
              if (pendingAmount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                    'Payment Pending: £${pendingAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.orange),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Text(
                    'Payment Complete',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // 4. Wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    final assignmentsCtrl = Get.isRegistered<AssignmentsController>()
        ? Get.find<AssignmentsController>()
        : Get.put(AssignmentsController());
    assignmentsCtrl.getOrderList();

    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().changeTab(2);
    }

    Get.offAllNamed(
      Routes.BOTTOM_NAV_BAR,
      arguments: {'index': 2},
    );
  }
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
    selectedExpert.value = null;
    useWallet.value = false;
    isAccepted.value = false;
    currentWordCount.value = 250;
    updateWordCountConfig();
  }

  @override
  void onClose() {
    topicController.dispose();
    deadlineController.dispose();
    pagesController.dispose();
    requirementsController.dispose();
    mobileController.dispose();
    nameController.dispose();
    emailController.dispose();
    wordCountTextController.dispose();
    selectedSubject.dispose();
    selectedService.dispose();
    selectedUrgency.dispose();
    selectedPageConfig.dispose();
    selectedCountry.dispose();
    selectedWorkType.dispose();

    super.onClose();
  }
}