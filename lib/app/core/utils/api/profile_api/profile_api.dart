import '../../../constant_api/api_constant.dart';
import '../../../models/profile_model/profile_response_model.dart';
import '../../../network/network_api_service.dart';

class ProfileApi {
  static Future<ProfileResponseModel> getProfile() async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.profile}',
      );

      final response = await ApiClient.get(url);

      return ProfileResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Get Profile Failed: $e');
    }
  }
}
