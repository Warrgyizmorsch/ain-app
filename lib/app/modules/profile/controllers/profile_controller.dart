import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/text_styles.dart';
import '../../home/controllers/home_controller.dart';
import '../../../core/models/login_model/login_response_model.dart';
import '../../../core/models/order_now_model/countries_master_model.dart';
import '../../../core/models/profile_model/edit_profile_request_model.dart';
import '../../../core/models/profile_model/edit_profile_response_model.dart';
import '../../../core/models/profile_model/reset_password_request_model.dart';
import '../../../core/models/sample_model/samples_category_response_model.dart';
import '../../../core/models/sample_model/samples_details_response_model.dart';
import '../../../core/models/sample_model/samples_list_model.dart';
import '../../../core/utils/api/order_now_api/order_now_dropdown_api.dart';
import '../../../core/utils/api/profile_api/edit_profile_api.dart';
import '../../../core/utils/api/profile_api/profile_api.dart';
import '../../../core/utils/api/profile_api/reset_password_api.dart';
import '../../../core/utils/api/sample_api/sample_list_api.dart';
import '../../../services/storage_services.dart';

class ProfileController extends GetxController {
  // Referral Fields
  final RxString referralCode = 'AIN25'.obs;
  final RxString referralLink = 'https://assignmentinneed.com/register?ref=AIN25'.obs;
  final RxInt totalFriendsReferred = 3.obs;
  final RxDouble totalEarned = 30.0.obs;
  final RxDouble pendingBonus = 10.0.obs;

  final RxList<Map<String, dynamic>> bonusMilestones = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> referralHistory = <Map<String, dynamic>>[].obs;

  // Profile Fields
  final dobController = TextEditingController(text: '12 May 1998');
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  Rx<File?> selectedProfilePhoto = Rx<File?>(null);
  RxString networkProfilePhotoUrl = ''.obs;
  final qualificationController = TextEditingController();
  final collegeController = TextEditingController();
  final courseController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingDetails = false.obs;
  final RxList<SampleItem> sampleList = <SampleItem>[].obs;
  final RxList<SampleCategory> categories = <SampleCategory>[].obs;
  final Rxn<SampleDetailData> sampleDetail = Rxn<SampleDetailData>();

  final RxBool isSampleSearching = false.obs;
  final RxString sampleSearchQuery = ''.obs;
  final TextEditingController sampleSearchController = TextEditingController();

  final ScrollController sampleScrollController = ScrollController();
  final RxInt sampleCurrentPage = 1.obs;
  final RxInt sampleLastPage = 1.obs;
  final RxBool isMoreSamplesLoading = false.obs;
  final RxBool hasMoreSamples = true.obs;

  RxString selectedCategory = "All".obs;
  // Change Password Fields
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  // Add these error hooks
  final oldPasswordError = ''.obs;
  final newPasswordError = ''.obs;
  final confirmPasswordError = ''.obs;
  // Country & Country Code
  final selectedCountry = 'India'.obs;
  final selectedCountryCode = '91'.obs;
  final RxList<CountryData> countryList = <CountryData>[].obs;

  final countries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Albania',
  ];
  final RxString currentTheme = 'System Default'.obs;

  void changeTheme(String themeName) {
    currentTheme.value = themeName;

    switch (themeName) {
      case 'Light':
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 'Dark':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      default:
        Get.changeThemeMode(ThemeMode.system);
        break;
    }
  }
  @override
  void onInit() {
    super.onInit();

    // Fetch the active user's data from SharedPreferences
    UserData? userData = StorageService.to.getUser();

    if (userData != null) {
      nameController.text = userData.name ?? '';
      emailController.text = userData.email ?? '';
      mobileController.text = userData.mobileNo ?? '';
      if (userData.country != null && userData.country!.isNotEmpty) {
        selectedCountry.value = userData.country!;
      }
      if (userData.countrycode != null && userData.countrycode!.isNotEmpty) {
        selectedCountryCode.value = userData.countrycode!;
      }
      if (userData.photo != null && userData.photo!.isNotEmpty) {
        networkProfilePhotoUrl.value = userData.photo!;
      }
    }
    fetchCountries();
    fetchProfile();
    samplesCategory();
    initReferralData();

    sampleScrollController.addListener(() {
      if (sampleScrollController.hasClients &&
          sampleScrollController.position.pixels >=
              sampleScrollController.position.maxScrollExtent - 200) {
        loadMoreSamples();
      }
    });
  }

  Future<void> fetchCountries() async {
    try {
      final response = await OrderNowDropdownApi.getCountries();
      if (response.success && response.data.isNotEmpty) {
        countryList.assignAll(response.data);
      }
    } catch (e) {
      debugPrint('Error fetching countries: $e');
    }
  }

  Future<void> fetchProfile() async {
    try {
      final response = await ProfileApi.getProfile();
      if (response.success && response.data != null) {
        final userData = response.data!;
        await StorageService.to.saveUser(userData);
        nameController.text = userData.name ?? '';
        emailController.text = userData.email ?? '';
        mobileController.text = userData.mobileNo ?? '';
        if (userData.country != null && userData.country!.isNotEmpty) {
          selectedCountry.value = userData.country!;
        }
        if (userData.countrycode != null && userData.countrycode!.isNotEmpty) {
          selectedCountryCode.value = userData.countrycode!;
        }
        if (userData.photo != null && userData.photo!.isNotEmpty) {
          networkProfilePhotoUrl.value = userData.photo!;
        }
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().getData();
        }
        initReferralData();
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final request = EditProfileRequestModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobileNo: mobileController.text.trim(),
        countrycode: selectedCountryCode.value,
        country: selectedCountry.value,
        photo: selectedProfilePhoto.value,
      );

      final EditProfileResponseModel response =
          await EditProfileApi.updateProfile(request: request);

      if (response.success) {
        if (response.data != null) {
          await StorageService.to.saveUser(response.data!);
          if (response.data!.photo != null && response.data!.photo!.isNotEmpty) {
            networkProfilePhotoUrl.value = response.data!.photo!;
          }
        }
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().getData();
        }
        selectedProfilePhoto.value = null;
        Get.snackbar(
          'Success',
          response.message,
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: const Color(0xFFD32F2F),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openLiveChat() async {
    final Uri uri = Uri.parse('https://assignmentinneed.co.uk/privacy-policy');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> selectDOBDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1998, 5, 12), // Default date
      firstDate: DateTime(1900), // Minimum allowed year
      lastDate: DateTime.now(), // Max allowed date (today)
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4527A0), // Deep purple theme for calendar
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      String formattedDate =
          "${picked.day} ${months[picked.month - 1]} ${picked.year}";

      dobController.text = formattedDate;
    }
  }

  Future<void> pickProfilePhoto() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image, // <-- Sirf Images (JPG, PNG, WEBP) allow karega
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        // Controller mein image update kar rahe hain
        selectedProfilePhoto.value = File(result.files.single.path!);

        Get.snackbar(
          'Success',
          'Profile photo selected successfully.',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not select photo.',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
    }
  }

  void updatePassword() async {
    // 1. Reset errors
    oldPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';

    // 2. Validate empty
    if (oldPasswordController.text.isEmpty) {
      oldPasswordError.value = 'Please enter old password';
    }
    if (newPasswordController.text.isEmpty) {
      newPasswordError.value = 'Please enter new password';
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm new password';
    }

    if (oldPasswordError.isNotEmpty ||
        newPasswordError.isNotEmpty ||
        confirmPasswordError.isNotEmpty) {
      return;
    }

    final savedPassword = StorageService.to.getSavedPassword();
    if (oldPasswordController.text.trim() != savedPassword) {
      oldPasswordError.value = 'Incorrect old password';
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      return;
    }

    final String? token = StorageService.to.getToken();
    UserData? user = StorageService.to.getUser();
    final String email =
        user?.email ?? ""; // Ensure your user object has an 'email' key

    if (token == null || email.isEmpty) {
      Get.snackbar('Error', 'Session expired. Please login again.');
      return;
    }

    // 5. Construct Request Model
    ResetPasswordRequestModel request = ResetPasswordRequestModel(
      token: token,
      email: email,
      password: newPasswordController.text.trim(),
      passwordConfirmation: confirmPasswordController.text.trim(),
    );

    // 6. API Call
    try {
      final response = await ResetPasswordApi.resetPassword(request: request);

      if (response.success == true) {
        Get.snackbar('Success', 'Password updated successfully!');

        // Update local storage with the new password
        await StorageService.to.saveAccount(
          email,
          newPasswordController.text.trim(),
        );

        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> getSamples({int? categoryId, bool isRefresh = true}) async {
    try {
      if (isRefresh) {
        isLoading.value = true;
        sampleCurrentPage.value = 1;
        hasMoreSamples.value = true;
      }

      final int? catId = categoryId ??
          (selectedCategory.value == 'All'
              ? null
              : categories.firstWhereOrNull((e) => e.name == selectedCategory.value)?.id);

      final response = await SampleListApi.samplesList(
        categoryId: catId,
        page: sampleCurrentPage.value,
      );

      if (response.success) {
        if (isRefresh) {
          sampleList.assignAll(response.data.data);
        } else {
          sampleList.addAll(response.data.data);
        }
        sampleLastPage.value = response.data.lastPage;
        hasMoreSamples.value = response.data.nextPageUrl != null &&
            sampleCurrentPage.value < response.data.lastPage;
      }
    } catch (_) {
    } finally {
      if (isRefresh) {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadMoreSamples() async {
    if (isMoreSamplesLoading.value || !hasMoreSamples.value || isLoading.value) {
      return;
    }

    try {
      isMoreSamplesLoading.value = true;
      sampleCurrentPage.value += 1;
      await getSamples(isRefresh: false);
    } finally {
      isMoreSamplesLoading.value = false;
    }
  }

  void toggleSampleSearch() {
    isSampleSearching.value = !isSampleSearching.value;
    if (!isSampleSearching.value) {
      clearSampleSearch();
    }
  }

  void updateSampleSearchQuery(String query) {
    sampleSearchQuery.value = query;
  }

  void clearSampleSearch() {
    sampleSearchController.clear();
    sampleSearchQuery.value = '';
  }

  List<SampleItem> get filteredSamples {
    List<SampleItem> list = sampleList;

    if (selectedCategory.value != "All") {
      list = list
          .where((e) => e.categoryName == selectedCategory.value)
          .toList();
    }

    if (sampleSearchQuery.value.trim().isNotEmpty) {
      final query = sampleSearchQuery.value.trim().toLowerCase();
      list = list.where((item) {
        final title = item.title.toLowerCase();
        final type = item.typeName.toLowerCase();
        final category = item.categoryName.toLowerCase();

        return title.contains(query) ||
            type.contains(query) ||
            category.contains(query);
      }).toList();
    }

    return list;
  }

  Future<void> changeCategory(String category) async {
    selectedCategory.value = category;
    await getSamples(
      categoryId: category == 'All'
          ? null
          : categories.firstWhere((e) => e.name == category).id,
    );
  }

  Future<void> samplesDetails({required String slug}) async {
    try {
      isLoadingDetails.value = true;

      final response = await SampleListApi.samplesDetails(slug: slug);

      if (response.success) {
        sampleDetail.value = response.data;
      }
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> samplesCategory() async {
    try {
      isLoadingDetails.value = true;

      final response = await SampleListApi.samplesCategory();

      if (response.success) {
        // 1. Create a custom 'All' category
        final SampleCategory allCategory = SampleCategory(
          id: 0, // Dummy ID
          name: 'All',
          sampleCount: 0,
        );

        // 2. Combine the 'All' category with the API response
        final List<SampleCategory> updatedCategories = [
          allCategory,
          ...?response.data,
        ];

        // 3. Assign the combined list to your observable
        categories.assignAll(updatedCategories);
        await getSamples();
      }
    } finally {
      isLoadingDetails.value = false;
    }
  }

  void initReferralData() {
    UserData? user = StorageService.to.getUser();
    if (user != null) {
      String cleanName = (user.name ?? 'USER')
          .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
          .toUpperCase();
      if (cleanName.length > 4) {
        cleanName = cleanName.substring(0, 4);
      }
      int userId = user.id > 0 ? user.id : 25;
      referralCode.value = 'AIN$cleanName$userId';
    } else {
      referralCode.value = 'AIN25';
    }

    referralLink.value =
        'https://assignmentinneed.com/register?ref=${referralCode.value}';

    bonusMilestones.assignAll([
      {
        'tag': 'EXTRA BONUS',
        'title': 'Invite 5 Friends',
        'subtitle': 'Earn £20 Bonus',
        'bgColor': AppColors.tagBg,
        'current': totalFriendsReferred.value,
        'target': 5,
      },
      {
        'tag': 'MEGA BONUS',
        'title': 'Invite 10 Friends',
        'subtitle': 'Earn £50 Bonus',
        'bgColor': AppColors.priceBg,
        'current': totalFriendsReferred.value,
        'target': 10,
      },
      {
        'tag': 'SUPER BONUS',
        'title': 'Invite 25 Friends',
        'subtitle': 'Earn £150 Bonus',
        'bgColor': const Color(0xFFEDE7F6),
        'current': totalFriendsReferred.value,
        'target': 25,
      },
    ]);

    referralHistory.assignAll([
      {
        'name': 'Sarah Jenkins',
        'date': '20 Jul 2026',
        'status': 'Completed',
        'amount': 10.0,
      },
      {
        'name': 'Alex Rivera',
        'date': '18 Jul 2026',
        'status': 'Completed',
        'amount': 10.0,
      },
      {
        'name': 'Michael Chang',
        'date': '12 Jul 2026',
        'status': 'Completed',
        'amount': 10.0,
      },
      {
        'name': 'David Kim',
        'date': '24 Jul 2026',
        'status': 'Pending',
        'amount': 10.0,
      },
    ]);
  }

  String get shareMessage =>
      "Hey! Join me on Assignment In Need for expert academic writing services. Get 20% OFF on your first order with my referral code '${referralCode.value}' or click: ${referralLink.value}";

  void copyReferralCode() {
    Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar(
      'Copied!',
      'Referral code copied to clipboard',
      backgroundColor: const Color(0xFF4527A0),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void copyReferralLink() {
    Clipboard.setData(ClipboardData(text: referralLink.value));
    Get.snackbar(
      'Copied!',
      'Referral link copied to clipboard',
      backgroundColor: const Color(0xFF4527A0),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.link, color: Colors.white),
    );
  }

  Future<void> shareNative() async {
    try {
      // ignore: deprecated_member_use
      await Share.share(shareMessage, subject: 'Get 20% OFF on Assignment In Need!');
    } catch (e) {
      debugPrint('Error sharing natively: $e');
    }
  }

  Future<void> shareToWhatsApp() async {
    final encodedMessage = Uri.encodeComponent(shareMessage);
    final whatsappUrl = Uri.parse('whatsapp://send?text=$encodedMessage');
    final webUrl = Uri.parse('https://wa.me/?text=$encodedMessage');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        await shareNative();
      }
    } catch (e) {
      await shareNative();
    }
  }

  Future<void> shareToTelegram() async {
    final encodedMessage = Uri.encodeComponent(shareMessage);
    final encodedUrl = Uri.encodeComponent(referralLink.value);
    final tgUrl = Uri.parse('https://t.me/share/url?url=$encodedUrl&text=$encodedMessage');

    try {
      if (await canLaunchUrl(tgUrl)) {
        await launchUrl(tgUrl, mode: LaunchMode.externalApplication);
      } else {
        await shareNative();
      }
    } catch (e) {
      await shareNative();
    }
  }

  Future<void> shareToInstagram() async {
    Clipboard.setData(ClipboardData(text: shareMessage));
    Get.snackbar(
      'Message Copied!',
      'Share message copied. Opening share sheet...',
      backgroundColor: const Color(0xFF4527A0),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    await shareNative();
  }

  Future<void> shareToMessenger() async {
    final encodedUrl = Uri.encodeComponent(referralLink.value);
    final messengerUrl = Uri.parse('fb-messenger://share/?link=$encodedUrl');

    try {
      if (await canLaunchUrl(messengerUrl)) {
        await launchUrl(messengerUrl);
      } else {
        await shareNative();
      }
    } catch (e) {
      await shareNative();
    }
  }

  void showRewardsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Referral Rewards', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4527A0), Color(0xFF6A1B9A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.card_giftcard, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Balance',
                          style: AppTextStyles.caption.copyWith(color: Colors.white70),
                        ),
                        Obx(() => Text(
                          '£${totalEarned.value.toStringAsFixed(2)}',
                          style: AppTextStyles.h1.copyWith(color: Colors.white),
                        )),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.snackbar(
                          'Claim Rewards',
                          'Your reward balance of £${totalEarned.value.toStringAsFixed(2)} will be automatically applied as a discount on your next order!',
                          backgroundColor: Colors.green[700],
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 4),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Redeem', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Referral Activity', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: Obx(() => ListView.separated(
                  shrinkWrap: true,
                  itemCount: referralHistory.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = referralHistory[index];
                    final isCompleted = item['status'] == 'Completed';
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: isCompleted ? Colors.green[50] : Colors.orange[50],
                        child: Icon(
                          isCompleted ? Icons.check_circle : Icons.hourglass_top,
                          color: isCompleted ? Colors.green : Colors.orange,
                        ),
                      ),
                      title: Text(item['name'].toString(), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      subtitle: Text(item['date'].toString(), style: AppTextStyles.caption),
                      trailing: Text(
                        '${isCompleted ? '+' : ''}£${(item['amount'] as double).toStringAsFixed(0)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? Colors.green[700] : Colors.orange[800],
                        ),
                      ),
                    );
                  },
                )),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    qualificationController.dispose();
    collegeController.dispose();
    courseController.dispose();

    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    sampleSearchController.dispose();

    super.onClose();
  }
}
