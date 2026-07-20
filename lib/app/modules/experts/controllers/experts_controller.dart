import 'package:get/get.dart';

import '../../../core/models/experts_model/experts_list_response_model.dart';
import '../../../core/utils/api/write_and_experts_api/writes_list_api.dart';

class ExpertsController extends GetxController {
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingDetails = false.obs;

  final RxList<String> categories = <String>['All'].obs;
  final RxList<ExpertData> allExperts = <ExpertData>[].obs;

  final Rxn<ExpertData> expertDetail = Rxn<ExpertData>();

  @override
  void onInit() {
    super.onInit();
    getExpertsList();
  }

  List<ExpertData> get filteredExperts {
    if (selectedCategory.value == 'All') {
      return allExperts;
    }

    return allExperts
        .where((expert) => expert.subject == selectedCategory.value)
        .toList();
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
            .map<String>((expert) => expert.subject ?? 'Unknown')
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