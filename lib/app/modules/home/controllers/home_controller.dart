import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/app_imports.dart';
import '../../../common/widget/file_picker/app_file_picker.dart';
import '../../../core/models/accdemic_tools/assessment_model.dart';
import '../../../core/models/login_model/login_response_model.dart';
import '../../../core/models/notifications_model/get_notifications_model.dart';
import '../../../services/storage_services.dart';

// IMPORTANT: Ensure you have your helper imported
// import '../../../helpers/app_file_picker_helper.dart';

class HomeController extends GetxController {
  RxString username = ''.obs;
  final filters = ['All', 'Unread', 'Important'];
  final selectedFilterIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void closeDrawer() {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      scaffoldKey.currentState?.closeDrawer();
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
  // ==========================================
  // 1. DISSERTATION PLANNER PARAMETERS
  // ==========================================

  final selectedPlannerTab = 'Overview'.obs;

  final plannerOverallProgress = 0.35.obs;
  final plannerChaptersCompleted = 3.obs;
  final plannerTotalChapters = 10.obs;
  final plannerTasksCompleted = 14.obs;
  final plannerTotalTasks = 40.obs;
  final plannerDaysLeft = 86.obs;
  final plannerDeadlineDate = '15 Aug 2025'.obs;
  final plannerDeadlineDay = 'Friday'.obs;

  final chapterProgressList = [
    {'chapter': 'Chapter 1', 'title': 'Introduction', 'progress': 1.0, 'status': 'completed'},
    {'chapter': 'Chapter 2', 'title': 'Literature Review', 'progress': 1.0, 'status': 'completed'},
    {'chapter': 'Chapter 3', 'title': 'Methodology', 'progress': 0.6, 'status': 'in_progress'},
    {'chapter': 'Chapter 4', 'title': 'Data Analysis', 'progress': 0.2, 'status': 'starting'},
    {'chapter': 'Chapter 5', 'title': 'Discussion', 'progress': 0.0, 'status': 'pending'},
  ].obs;

  final upcomingTasksList = [
    {
      'title': 'Define Research Objectives',
      'subtitle': 'Chapter 3 • Methodology',
      'date': '20 May 2025',
      'daysLeft': '3 days left',
      'priority': 'High',
    },
    {
      'title': 'Data Collection',
      'subtitle': 'Chapter 3 • Methodology',
      'date': '28 May 2025',
      'daysLeft': '11 days left',
      'priority': 'Medium',
    },
    {
      'title': 'Analyze Results',
      'subtitle': 'Chapter 4 • Data Analysis',
      'date': '10 Jun 2025',
      'daysLeft': '24 days left',
      'priority': 'Low',
    },
  ].obs;

  void setPlannerTab(String tab) {
    selectedPlannerTab.value = tab;
  }

  // ==========================================
  // 2. APA GENERATOR PARAMETERS
  // ==========================================

  final apaSelectedCategory = 'Website'.obs;
  final apaCategories = ['Website', 'Journal Article', 'Book', 'More'];

  final apaIncludeDoi = true.obs;
  final apaIncludeAccessDate = false.obs;
  final apaIncludePage = false.obs;

  final apaTitleCtrl = TextEditingController();
  final apaUrlCtrl = TextEditingController();
  final apaAuthorCtrl = TextEditingController();
  final apaDateCtrl = TextEditingController();
  final apaSiteNameCtrl = TextEditingController();

  final apaCitationParts = <String, String>{}.obs;

  void setApaCategory(String category) {
    if (category != 'More') {
      apaSelectedCategory.value = category;
    }
  }

  void generateApaCitation() {
    if (apaTitleCtrl.text.isEmpty || apaUrlCtrl.text.isEmpty) {
      Get.snackbar('Missing Fields', 'Please fill in all required fields (*)', backgroundColor: AppColors.error, colorText: AppColors.white);
      return;
    }

    apaCitationParts.value = {
      'author': apaAuthorCtrl.text.trim(),
      'date': apaDateCtrl.text.trim(),
      'title': apaTitleCtrl.text.trim(),
      'siteName': apaSiteNameCtrl.text.trim(),
      'url': apaUrlCtrl.text.trim(),
    };

    Get.snackbar('Success', 'APA Citation generated successfully!', backgroundColor: AppColors.statusGreen, colorText: AppColors.white);
  }

  // ==========================================
  // 3. REFERENCE GENERATOR PARAMETERS (RESTORED)
  // ==========================================

  final refSelectedStyle = 'APA 7th Edition'.obs;
  final refSelectedSource = 'Journal Article'.obs;

  final refTitleCtrl = TextEditingController();
  final refAuthorCtrl = TextEditingController();
  final refJournalCtrl = TextEditingController();
  final refYearCtrl = TextEditingController();
  final refVolCtrl = TextEditingController();
  final refIssueCtrl = TextEditingController();
  final refPagesCtrl = TextEditingController();
  final refDoiCtrl = TextEditingController();

  final refCitationParts = <String, String>{}.obs;

  void generateReference() {
    if (refTitleCtrl.text.isEmpty || refAuthorCtrl.text.isEmpty || refJournalCtrl.text.isEmpty || refYearCtrl.text.isEmpty) {
      Get.snackbar('Missing Fields', 'Please fill in all required fields (*)', backgroundColor: AppColors.error, colorText: AppColors.white);
      return;
    }

    refCitationParts.value = {
      'style': refSelectedStyle.value,
      'author': refAuthorCtrl.text.trim(),
      'year': refYearCtrl.text.trim(),
      'title': refTitleCtrl.text.trim(),
      'journal': refJournalCtrl.text.trim(),
      'volume': refVolCtrl.text.trim(),
      'issue': refIssueCtrl.text.trim(),
      'pages': refPagesCtrl.text.trim(),
      'doi': refDoiCtrl.text.trim(),
    };

    Get.snackbar('Success', 'Reference generated successfully!', backgroundColor: AppColors.statusGreen, colorText: AppColors.white);
  }

  // ==========================================
  // 4. PLAGIARISM CHECKER PARAMETERS
  // ==========================================

  final plagiarismSelectedInputType = 'Text'.obs;
  final plagiarismTextController = TextEditingController();
  final plagiarismWordCount = 0.obs;

  final plagiarismCheckInternet = true.obs;
  final plagiarismCheckAcademic = true.obs;
  final plagiarismExcludeQuotes = false.obs;

  final plagiarismSelectedFileName = ''.obs;
  final plagiarismSelectedFileSize = ''.obs;

  void pickPlagiarismFile() async {
    try {
      // Native OS file picker ko strictly single file ke liye force kiya
      FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: false, // <-- ONLY ALLOW SINGLE FILE
        type: FileType.any,   // <-- ALLOW ALL FILE TYPES (PNG, JPG, PDF, etc.)
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        // Update Plagiarism specific variables
        plagiarismSelectedFileName.value = result.files.single.name;
        plagiarismSelectedFileSize.value = '${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB';

        Get.snackbar(
          'File Selected',
          'Ready for scanning.',
          backgroundColor: AppColors.statusGreen,
          colorText: AppColors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
      Get.snackbar(
          'Error',
          'Could not select file.',
          backgroundColor: AppColors.error,
          colorText: AppColors.white
      );
    }
  }

  void removePlagiarismFile() {
    plagiarismSelectedFileName.value = '';
    plagiarismSelectedFileSize.value = '';
  }

  // ==========================================
  // 5. GRADE CALCULATOR (EXISTING)
  // ==========================================

  final assessments = <Assessment>[].obs;
  final targetGradePercentage = 85.0.obs;


  // ==========================================
  // WORD COUNTER PARAMETERS
  // ==========================================
  // ==========================================
  // 5. WORD COUNTER (NEW LOGIC)
  // ==========================================
  final wordCounterSelectedInputType = 'Text'.obs;
  final wordCounterTextController = TextEditingController();
  final wordCounterUrlController = TextEditingController();

  final fileExtractedText = ''.obs;
  final urlExtractedText = ''.obs;
  final activeTextForCounting = ''.obs;

  final wordCounterSelectedFile = Rxn<File>();
  final wordCounterSelectedFileName = ''.obs;
  final wordCounterSelectedFileSize = ''.obs;

  final isWordCounterProcessing = false.obs;

  void setWordCounterTab(String tab) {
    wordCounterSelectedInputType.value = tab;
    // Tab change karte hi us tab ka data grid ko bhej do
    if (tab == 'Text') {
      activeTextForCounting.value = wordCounterTextController.text;
    } else if (tab == 'File Upload') {
      activeTextForCounting.value = fileExtractedText.value;
    } else if (tab == 'URL') {
      activeTextForCounting.value = urlExtractedText.value;
    }
  }

  void pickWordCounterFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        wordCounterSelectedFile.value = file;
        wordCounterSelectedFileName.value = result.files.single.name;
        wordCounterSelectedFileSize.value = '${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB';

        Get.snackbar(
            'Processing',
            'Extracting text from file...',
            backgroundColor: AppColors.statusOrange,
            colorText: AppColors.white
        );

        await processWordCount(); // Automatically process after upload
      }
    } catch (e) {
      Get.snackbar(
          'Error',
          'Could not select file.',
          backgroundColor: AppColors.error,
          colorText: AppColors.white
      );
    }
  }

  void removeWordCounterFile() {
    wordCounterSelectedFile.value = null;
    wordCounterSelectedFileName.value = '';
    wordCounterSelectedFileSize.value = '';
    fileExtractedText.value = '';
    if (wordCounterSelectedInputType.value == 'File Upload') {
      activeTextForCounting.value = '';
    }
  }

  Future<void> processWordCount() async {
    final type = wordCounterSelectedInputType.value;

    // TEXT
    if (type == 'Text') {
      if (wordCounterTextController.text.trim().isEmpty) {
        Get.snackbar("Empty", "Please enter some text to count.", backgroundColor: AppColors.warning, colorText: AppColors.white);
        return;
      }
      activeTextForCounting.value = wordCounterTextController.text;
      Get.snackbar('Success', 'Text analysis complete!', backgroundColor: AppColors.primaryPurple, colorText: AppColors.white);
    }
    // FILE
    else if (type == 'File Upload') {
      if (wordCounterSelectedFileName.value.isEmpty) {
        Get.snackbar("Empty", "Please upload a document.", backgroundColor: AppColors.warning, colorText: AppColors.white);
        return;
      }
      isWordCounterProcessing.value = true;
      try {
        String fileExt = wordCounterSelectedFileName.value.split('.').last.toLowerCase();
        String extractedText = '';
        if (fileExt == 'txt' && wordCounterSelectedFile.value != null) {
          extractedText = await wordCounterSelectedFile.value!.readAsString();
        } else {
          await Future.delayed(const Duration(seconds: 2));
          extractedText = "This is a simulated extraction of your $fileExt file.\n\nIn a real app, external packages parse DOCX/PDF files.";
        }
        fileExtractedText.value = extractedText;
        activeTextForCounting.value = extractedText;
        Get.snackbar('Success', 'File text extracted and counted!', backgroundColor: AppColors.statusGreen, colorText: AppColors.white);
      } catch (e) {
        Get.snackbar('Error', 'Failed to read the file.', backgroundColor: AppColors.error, colorText: AppColors.white);
      }
      isWordCounterProcessing.value = false;
    }
    // URL
    else if (type == 'URL') {
      final url = wordCounterUrlController.text.trim();
      if (url.isEmpty) {
        Get.snackbar("Empty", "Please enter a valid URL.", backgroundColor: AppColors.warning, colorText: AppColors.white);
        return;
      }
      isWordCounterProcessing.value = true;
      try {
        await Future.delayed(const Duration(seconds: 2));
        String extractedText = "Web scraping result for: $url\n\nThis is mock text extracted from the URL you entered.";
        urlExtractedText.value = extractedText;
        activeTextForCounting.value = extractedText;
        Get.snackbar('Success', 'URL text extracted and counted!', backgroundColor: AppColors.statusGreen, colorText: AppColors.white);
      } catch (e) {
        Get.snackbar('Error', 'Failed to fetch the URL.', backgroundColor: AppColors.error, colorText: AppColors.white);
      }
      isWordCounterProcessing.value = false;
    }
  }



  // ==========================================
  // INITIALIZATION & LISTENERS
  // ==========================================

  @override
  void onInit() {
    super.onInit();
    getData();

    assessments.addAll([
      Assessment(id: '1', title: 'Assignment 1', type: 'Homework', score: 88, outOf: 100, weight: 20),
      Assessment(id: '2', title: 'Midterm Exam', type: 'Exam', score: 76, outOf: 100, weight: 30),
      Assessment(id: '3', title: 'Final Project', type: 'Project', score: 92, outOf: 100, weight: 50),
    ]);

    // 1. Plagiarism Real-Time Count Listener
    plagiarismTextController.addListener(() {
      final text = plagiarismTextController.text.trim();
      if (text.isEmpty) {
        plagiarismWordCount.value = 0;
      } else {
        plagiarismWordCount.value = text.split(RegExp(r'\s+')).length;
      }
    });

    // 2. Word Counter Real-Time Count Listener (THIS WAS MISSING!)
    wordCounterTextController.addListener(() {
      if (wordCounterSelectedInputType.value == 'Text') {
        activeTextForCounting.value = wordCounterTextController.text;
      }
    });
  }

  @override
  void onClose() {
    apaTitleCtrl.dispose();
    apaUrlCtrl.dispose();
    apaAuthorCtrl.dispose();
    apaDateCtrl.dispose();
    apaSiteNameCtrl.dispose();

    refTitleCtrl.dispose();
    refAuthorCtrl.dispose();
    refJournalCtrl.dispose();
    refYearCtrl.dispose();
    refVolCtrl.dispose();
    refIssueCtrl.dispose();
    refPagesCtrl.dispose();
    refDoiCtrl.dispose();

    plagiarismTextController.dispose();

    // Dispose Word Counter Controllers
    wordCounterTextController.dispose();
    wordCounterUrlController.dispose();

    super.onClose();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  void getData() {
    UserData? userData = StorageService.to.getUser();
    if (userData != null) {
      debugPrint("NAME: ${userData.name}");
      username.value = userData.name ?? '';
    }
  }

  final notifications = <NotificationItem>[
    NotificationItem(
      title: 'Draft Uploaded',
      message: 'Your expert has uploaded the draft.',
      time: '10:30 AM',
      bgColor: const Color(0xFF7E3FF2),
      icon: Icons.upload_file,
      isRead: false,
    ),
    NotificationItem(
      title: 'Expert Replied',
      message: 'Dr. Laura Baker replied to your message.',
      time: '09:15 AM',
      bgColor: const Color(0xFF4285F4),
      icon: Icons.chat_bubble_outline,
      isRead: false,
      isImportant: true,
    ),
    NotificationItem(
      title: 'Assignment Delivered',
      message: 'Your assignment has been completed and delivered.',
      time: 'Yesterday',
      bgColor: const Color(0xFFF9A826),
      icon: Icons.assignment_turned_in_outlined,
      isImportant: true,
    ),
    NotificationItem(
      title: 'Payment Received',
      message: 'We have received your payment successfully.',
      time: 'Yesterday',
      bgColor: const Color(0xFF34A853),
      icon: Icons.account_balance_wallet_outlined,
    ),
    NotificationItem(
      title: 'New Message',
      message: 'You have a new message from your expert.',
      time: '2 Jun 2024',
      bgColor: const Color(0xFFEF5350),
      icon: Icons.forum_outlined,
      isRead: false,
    ),
  ].obs;

  List<NotificationItem> get filteredNotifications {
    final currentFilter = filters[selectedFilterIndex.value];

    if (currentFilter == 'Unread') {
      return notifications.where((item) => !item.isRead).toList();
    } else if (currentFilter == 'Important') {
      return notifications.where((item) => item.isImportant).toList();
    }

    return notifications;
  }

  void setFilter(int index) {
    selectedFilterIndex.value = index;
  }

  double get totalWeight {
    return assessments.fold(0, (sum, item) => sum + item.weight);
  }

  double get currentWeightedScore {
    return assessments.fold(0, (sum, item) => sum + (item.score / item.outOf) * item.weight);
  }

  double get currentPercentage {
    if (totalWeight == 0) return 0.0;
    return (currentWeightedScore / totalWeight) * 100;
  }

  String get estimatedGrade {
    final score = currentPercentage;
    if (score >= 90) return 'A';
    if (score >= 80) return 'A-';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';
    return 'F';
  }

  double get neededInRemaining {
    double remainingWeight = 100 - totalWeight;
    if (remainingWeight <= 0) return 0.0;

    double neededScore = targetGradePercentage.value - currentWeightedScore;
    double neededPercentage = (neededScore / remainingWeight) * 100;

    return neededPercentage > 0 ? neededPercentage : 0.0;
  }

  void addAssessment(Assessment newAssessment) {
    if (totalWeight + newAssessment.weight > 100) {
      Get.snackbar('Error', 'Total weight cannot exceed 100%');
      return;
    }
    assessments.add(newAssessment);
  }

  void removeAssessment(String id) {
    assessments.removeWhere((item) => item.id == id);
  }

  void updateTargetGrade(double newTarget) {
    targetGradePercentage.value = newTarget;
  }
}