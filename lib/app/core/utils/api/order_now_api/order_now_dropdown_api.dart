import '../../../constant_api/api_constant.dart';
import '../../../models/order_now_model/countries_master_model.dart';
import '../../../models/order_now_model/services_master_model.dart';
import '../../../models/order_now_model/subjects_master_model.dart';
import '../../../models/order_now_model/urgencies_master_model.dart';
import '../../../models/order_now_model/word_count_master_model.dart';
import '../../../network/base_api_service.dart';
import '../../../network/network_api_service.dart';

class OrderNowDropdownApi {
  static Future<ServicesOrderNowModel> getServices() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.SERVICES}');

      final response = await ApiClient.get(url);
      return ServicesOrderNowModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }


  static Future<WordCountResponse> getWordCount() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.WORD_COUNT}');

      final response = await ApiClient.get(url);
      return WordCountResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }


  static Future<CountryListResponse> getCountries() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.COUNTRIES}');

      final response = await ApiClient.get(url);
      return CountryListResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  static Future<SubjectsResponse> getSubjects() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.SUBJECTS}');

      final response = await ApiClient.get(url);
      return SubjectsResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }
  static Future<UrgencyListResponse> getUrgencies() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.URGENCIES}');

      final response = await ApiClient.get(url);
      return UrgencyListResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }
}
