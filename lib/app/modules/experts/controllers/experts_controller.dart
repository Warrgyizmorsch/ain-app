import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/experts_model/experts_list_response_model.dart';
import '../../../core/utils/api/write_and_experts_api/writes_list_api.dart';

class ExpertsController extends GetxController {
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingDetails = false.obs;

  final TextEditingController searchController = TextEditingController();

  final RxList<String> categories = <String>['All'].obs;
  final RxList<ExpertData> allExperts = <ExpertData>[].obs;

  final Rxn<ExpertData> expertDetail = Rxn<ExpertData>();

  @override
  void onInit() {
    super.onInit();
    getExpertsList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  List<ExpertData> get filteredExperts {
    List<ExpertData> list = allExperts;

    if (selectedCategory.value != 'All') {
      list = list
          .where((expert) => expert.subject == selectedCategory.value)
          .toList();
    }

    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.trim().toLowerCase();
      list = list.where((expert) {
        final name = expert.name?.toLowerCase() ?? '';
        final subject = expert.subject?.toLowerCase() ?? '';
        final service = expert.service?.toLowerCase() ?? '';
        final location = expert.location?.toLowerCase() ?? '';
        final skills = expert.skills?.join(' ').toLowerCase() ?? '';
        final helpus = expert.helpus?.join(' ').toLowerCase() ?? '';

        return name.contains(query) ||
            subject.contains(query) ||
            service.contains(query) ||
            location.contains(query) ||
            skills.contains(query) ||
            helpus.contains(query);
      }).toList();
    }

    return list;
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      clearSearch();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> getExpertsList() async {
    try {
      isLoading.value = true;

      final response = await WritesListApi.writerList();

      if (response.success == true && response.data != null) {
        allExperts.assignAll(response.data!);

        final List<String> uniqueSubjects = response.data!
            .where((expert) => expert.subject != null && expert.subject!.trim().isNotEmpty)
            .map<String>((expert) => expert.subject!)
            .toSet()
            .toList();

        categories.assignAll(['All', ...uniqueSubjects]);
      } else {
        Get.snackbar(
          'Notice',
          'No experts found at the moment.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}