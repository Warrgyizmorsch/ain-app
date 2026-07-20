import '../../../constant_api/api_constant.dart';
import '../../../models/login_model/forget_password_response.dart';
import '../../../models/login_model/login_request_model.dart';
import '../../../models/login_model/login_response_model.dart';
import '../../../network/network_api_service.dart';

class AppLogin {
  static Future<LoginResponseModel> login({
    required LoginRequestModel request,
  }) async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.LOGIN}');

      final response = await ApiClient.post(url, body: request.toJson());

      return LoginResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  static Future<LoginResponseModel> googleLogin({
    required String idToken,
    required String name,
    required String email,
    required String mobileNo,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.googleLogin}',
      );
      final Map<String, dynamic> requestBody = {
        'id_token': idToken,
        'name': name,
        'email': email,
        'mobile_no': mobileNo,
      };
      final response = await ApiClient.post(url, body: requestBody);

      return LoginResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  static Future<ForgetPasswordResponseModel> forgotPassword({
    required String email,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.forgotPassword}',
      );
      final Map<String, dynamic> requestBody = {'email': email};
      final response = await ApiClient.post(url, body: requestBody);

      return ForgetPasswordResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  static Future<ForgetPasswordOTPResponseModel> forgotPasswordOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.forgotPasswordOtp}',
      );
      final Map<String, dynamic> requestBody = {'email': email, 'otp': otp};
      final response = await ApiClient.post(url, body: requestBody);

      return ForgetPasswordOTPResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  static Future<ChangePasswordModel> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.resetPassword}',
      );
      final Map<String, dynamic> requestBody = {
        'email': email,
        'reset_token': resetToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
      final response = await ApiClient.post(url, body: requestBody);

      return ChangePasswordModel.fromJson(response);
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }
}
