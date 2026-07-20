import '../../../constant_api/api_constant.dart';
import '../../../models/sample_model/samples_category_response_model.dart';
import '../../../models/sample_model/samples_details_response_model.dart';
import '../../../models/sample_model/samples_list_model.dart';
import '../../../network/network_api_service.dart';

class SampleListApi {
  static Future<SampleResponseModel> samplesList({int? categoryId}) async {
    try {
      String urlString = '${ApiConstant.BASE_URL}${ApiConstant.samplesList}';

      if (categoryId != null && categoryId != 0) {
        urlString += '?category=$categoryId';
      }

      final url = Uri.parse(urlString);

      final response = await ApiClient.get(url);

      return SampleResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Sample list Failed: $e');
    }
  }

  static Future<SampleDetailResponseModel> samplesDetails({
    required String slug,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.samplesList}/$slug',
      );

      final response = await ApiClient.get(url);

      return SampleDetailResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Sample Details Failed: $e');
    }
  }

  static Future<SamplesCategoryResponseModel> samplesCategory() async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.samplesCategory}',
      );

      final response = await ApiClient.get(url);

      return SamplesCategoryResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Sample Details Failed: $e');
    }
  }
}
