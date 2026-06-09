import 'package:get/get.dart';

import '../../../common/constant/app_imports.dart';

class AddOrderController extends GetxController {
  /// STEP 1 -> Assignment Details
  /// STEP 3 -> Requirements & Payment
  final currentStep = 1.obs;

  final isAccepted = false.obs;

  // Text controllers
  final topicController = TextEditingController();
  final deadlineController = TextEditingController();
  final pagesController = TextEditingController();
  final requirementsController = TextEditingController();

  // Dropdown notifiers
  final subjectNotifier = ValueNotifier<String?>(null);
  final serviceNotifier = ValueNotifier<String?>(null);
  final workTypeNotifier = ValueNotifier<String?>(null);

  // Dropdown data
  final subjects = [
    'Mathematics',
    'English',
    'Science',
    'History',
    'Computer Science',
  ];

  final services = [
    'Essay Writing',
    'Research Paper',
    'Dissertation',
    'Case Study',
  ];

  final workTypes = [
    'Original',
    'Editing',
    'Proofreading',
    'Formatting',
  ];
  final pageNotifier = ValueNotifier<String?>(null);

  final pages = [
    '1 Page (250 Words)',
    '2 Pages (500 Words)',
    '3 Pages (750 Words)',
    '4 Pages (1000 Words)',
    '5 Pages (1250 Words)',
    '6 Pages (1500 Words)',
    '7 Pages (1750 Words)',
    '8 Pages (2000 Words)',
    '9 Pages (2250 Words)',
    '10 Pages (2500 Words)',
  ];
  /// STEP 1 -> STEP 2 (Requirements Screen)
  void onContinue() {
    currentStep.value = 3;
  }

  /// STEP 2 -> STEP 1
  void onBack() {
    currentStep.value = 1;
  }

  void toggleAccepted() {
    isAccepted.value = !isAccepted.value;
  }

  void pickFile() {
    // TODO: Implement File Picker
  }

  void addToCart() {
    if (!isAccepted.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept the terms to continue.',
      );
      return;
    }

    // TODO: Submit Order
  }

  @override
  void onClose() {
    topicController.dispose();
    deadlineController.dispose();
    pagesController.dispose();
    requirementsController.dispose();

    subjectNotifier.dispose();
    serviceNotifier.dispose();
    workTypeNotifier.dispose();
    pageNotifier.dispose();
    super.onClose();
  }
}



































// import 'package:get/get.dart';
//
// import '../../../common/constant/app_imports.dart';
//
// // ─── CONTROLLER ──────────────────────────────────────────────────────────────
//
// class AddOrderController extends GetxController {
//   final currentStep = 1.obs;
//   final isAccepted  = false.obs;
//
//   // Text controllers
//   final topicController        = TextEditingController();
//   final deadlineController     = TextEditingController();
//   final pagesController        = TextEditingController();
//   final requirementsController = TextEditingController();
//
//   // Dropdown notifiers
//   final subjectNotifier  = ValueNotifier<String?>(null);
//   final serviceNotifier  = ValueNotifier<String?>(null);
//   final workTypeNotifier = ValueNotifier<String?>(null);
//
//   // Dropdown data
//   final subjects  = ['Mathematics', 'English', 'Science', 'History', 'Computer Science'];
//   final services  = ['Essay Writing', 'Research Paper', 'Dissertation', 'Case Study'];
//   final workTypes = ['Original', 'Editing', 'Proofreading', 'Formatting'];
//
//   void onContinue() {
//     if (currentStep.value < 3) currentStep.value++;
//   }
//
//   void toggleAccepted() => isAccepted.value = !isAccepted.value;
//
//   void pickFile() {
//     // Integrate file_picker here
//   }
//
//   void addToCart() {
//     if (!isAccepted.value) {
//       Get.snackbar('Terms Required', 'Please accept the terms to continue.');
//       return;
//     }
//     // Submit order
//   }
//
//   @override
//   void onClose() {
//     topicController.dispose();
//     deadlineController.dispose();
//     pagesController.dispose();
//     requirementsController.dispose();
//     subjectNotifier.dispose();
//     serviceNotifier.dispose();
//     workTypeNotifier.dispose();
//     super.onClose();
//   }
// }
