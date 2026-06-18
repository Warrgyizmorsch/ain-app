import '../../../constant_api/api_constant.dart';
import '../../../models/order_now_model/feedback_request_model.dart';
import '../../../models/order_now_model/feedback_response_model.dart';
import '../../../network/network_api_service.dart';

class FeedbackApi {
  static Future<FeedbackResponse> addFeedBack({
    required FeedbackRequest request,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.SUBMIT_FEEDBACK}',
      );

      final response = await ApiClient.post(url, body: request);

      return FeedbackResponse.fromJson(response);
    } catch (e) {
      throw Exception('Raise Ticket Failed: $e');
    }
  }
}
