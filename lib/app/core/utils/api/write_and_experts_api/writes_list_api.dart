import '../../../constant_api/api_constant.dart';

import '../../../models/experts_model/experts_list_response_model.dart';
import '../../../network/network_api_service.dart';

class WritesListApi {
  static Future<ExpertListResponseModel> writerList() async {
    try {
      String urlString = '${ApiConstant.BASE_URL}${ApiConstant.experts}';


      final url = Uri.parse(urlString);

      final response = await ApiClient.get(url);

      return ExpertListResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Sample list Failed: $e');
    }
  }


}
