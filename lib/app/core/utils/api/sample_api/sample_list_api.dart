import '../../../constant_api/api_constant.dart';
import '../../../models/sample_model/samples_category_response_model.dart';
import '../../../models/sample_model/samples_details_response_model.dart';
import '../../../models/sample_model/samples_list_model.dart';
import '../../../network/network_api_service.dart';

class SampleListApi {
  static Future<SampleResponseModel> samplesList({
    int? categoryId,
    int? page,
  }) async {
    try {
      String urlString = '${ApiConstant.BASE_URL}${ApiConstant.samplesList}';
      List<String> queryParams = [];

      if (categoryId != null && categoryId != 0) {
        queryParams.add('category=$categoryId');
      }
      if (page != null && page > 0) {
        queryParams.add('page=$page');
      }
      if (queryParams.isNotEmpty) {
        urlString += '?${queryParams.join('&')}';
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
