import '../../../constant_api/api_constant.dart';
import '../../../models/register_model/register_request_model.dart';
import '../../../models/register_model/register_response_model.dart';
import '../../../network/network_api_service.dart';

class AppRegister {
  static Future<RegisterResponseModel> register({
    required RegisterRequestModel request,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.REGISTER}',
      );

      final response = await ApiClient.post(
        url,
        body: request.toJson(),
      );

      return RegisterResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Register Failed: $e');
    }
  }
}