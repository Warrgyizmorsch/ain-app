import '../../../constant_api/api_constant.dart';
import '../../../models/profile_model/reset_password_request_model.dart';
import '../../../models/profile_model/reset_password_response_model.dart';
import '../../../network/network_api_service.dart';

class ResetPasswordApi {

  static Future<ResetPasswordResponseModel> resetPassword({
    required ResetPasswordRequestModel request,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.RESET_PASSWORD}',
      );

      final response = await ApiClient.post(
        url,
        body: request.toJson(),
      );

      return ResetPasswordResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Register Failed: $e');
    }
  }
}