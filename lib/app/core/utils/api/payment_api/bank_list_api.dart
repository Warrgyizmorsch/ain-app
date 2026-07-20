import '../../../constant_api/api_constant.dart';
import '../../../models/payment_model/bank_list_model.dart';
import '../../../network/network_api_service.dart';

class BankListApi {
  static Future<BankListResponseModel> getBankList() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.bankList}');

      final response = await ApiClient.get(url);
      return BankListResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

}