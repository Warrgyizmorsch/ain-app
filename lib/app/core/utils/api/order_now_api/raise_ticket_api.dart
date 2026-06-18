import '../../../constant_api/api_constant.dart';
import '../../../models/order_now_model/raise_ticket_response.dart';
import '../../../network/network_api_service.dart';

class RaiseTicketApi {
  static Future<RaiseTicketResponse> addRaiseTicket({
    required String orderId,
    required String comment,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.RAISE_TICKET}',
      );

      final body = {
        "order_id": orderId,
        "comment": comment,
      };

      final response = await ApiClient.post(
        url,
        body: body,
      );

      return RaiseTicketResponse.fromJson(response);
    } catch (e) {
      throw Exception('Raise Ticket Failed: $e');
    }
  }
}