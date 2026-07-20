import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/login_model/login_response_model.dart';
import '../../../core/models/profile_model/reset_password_request_model.dart';
import '../../../core/models/sample_model/samples_category_response_model.dart';
import '../../../core/models/sample_model/samples_details_response_model.dart';
import '../../../core/models/sample_model/samples_list_model.dart';
import '../../../core/utils/api/profile_api/reset_password_api.dart';
import '../../../core/utils/api/sample_api/sample_list_api.dart';
import '../../../services/storage_services.dart';

class ProfileController extends GetxController {
  // Profile Fields
  final dobController = TextEditingController(text: '12 May 1998');
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  Rx<File?> selectedProfilePhoto = Rx<File?>(null);
  final qualificationController = TextEditingController();
  final collegeController = TextEditingController();
  final courseController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingDetails = false.obs;
  final RxList<SampleItem> sampleList = <SampleItem>[].obs;
  final RxList<SampleCategory> categories = <SampleCategory>[].obs;
  final Rxn<SampleDetailData> sampleDetail = Rxn<SampleDetailData>();

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
  // Country Dropdown
  final selectedCountry = 'India'.obs;

  final countries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
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
    }
    samplesCategory();
  }

  void updateProfile() {
    Get.snackbar('Success', 'Profile Updated Successfully');
  }

  Future<void> openLiveChat() async {
    final Uri uri = Uri.parse('https://assignment-in-need.vercel.app/about');

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
    if (oldPasswordController.text.isEmpty)
      oldPasswordError.value = 'Please enter old password';
    if (newPasswordController.text.isEmpty)
      newPasswordError.value = 'Please enter new password';
    if (confirmPasswordController.text.isEmpty)
      confirmPasswordError.value = 'Please confirm new password';

    if (oldPasswordError.isNotEmpty ||
        newPasswordError.isNotEmpty ||
        confirmPasswordError.isNotEmpty)
      return;

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

  Future<void> getSamples({int? categoryId}) async {
    try {
      isLoading.value = true;

      final response = await SampleListApi.samplesList(categoryId: categoryId);

      if (response.success) {
        sampleList.assignAll(response.data.data);
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<SampleItem> get filteredSamples {
    if (selectedCategory.value == "All") {
      return sampleList;
    }

    return sampleList
        .where((e) => e.categoryName == selectedCategory.value)
        .toList();
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

    super.onClose();
  }
}
