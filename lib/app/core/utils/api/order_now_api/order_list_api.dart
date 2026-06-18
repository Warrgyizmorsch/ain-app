import '../../../constant_api/api_constant.dart';
import '../../../models/order_now_model/order_list_model.dart';
import '../../../network/network_api_service.dart';

class OrderListApi {
  static Future<OrderListResponse> getOrderList() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.ORDER_LIST}');

      final response = await ApiClient.get(url);
      return OrderListResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

}