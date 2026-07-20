import '../../../constant_api/api_constant.dart';
import '../../../models/wallet_history_model/wallet_amount_response_model.dart';
import '../../../models/wallet_history_model/wallet_history_response_model.dart';
import '../../../network/network_api_service.dart';

class WalletApiEndpoint {
  static Future<TransactionResponseModel> getWalletList() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.walletList}');

      final response = await ApiClient.get(url);
      return TransactionResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  static Future<WalletResponseModel> getWalletAmount() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.wallet}');

      final response = await ApiClient.get(url);
      return WalletResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }
}