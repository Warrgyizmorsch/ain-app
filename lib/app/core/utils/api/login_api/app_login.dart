import '../../../constant_api/api_constant.dart';
import '../../../models/login_model/login_request_model.dart';
import '../../../models/login_model/login_response_model.dart';
import '../../../network/network_api_service.dart';

class AppLogin {
  static Future<LoginResponseModel> login({
    required LoginRequestModel request,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.LOGIN}',
      );

      final response = await ApiClient.post(
        url,
        body: request.toJson(),
      );

      return LoginResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }
}