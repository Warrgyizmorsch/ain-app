import '../../../constant_api/api_constant.dart';
import '../../../models/payment_model/total_spent_model.dart';
import '../../../network/network_api_service.dart';

class TotalSpentApi {
  static Future<TotalSpentResponseModel> getTotalSpent() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.totalSpent}');

      final response = await ApiClient.get(url);
      return TotalSpentResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch total spent details: $e');
    }
  }
}
