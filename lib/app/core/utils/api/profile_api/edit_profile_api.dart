
import 'package:http/http.dart' as http;
import '../../../constant_api/api_constant.dart';
import '../../../models/profile_model/edit_profile_request_model.dart';
import '../../../models/profile_model/edit_profile_response_model.dart';
import '../../../network/network_api_service.dart';

class EditProfileApi {
  static Future<EditProfileResponseModel> updateProfile({
    required EditProfileRequestModel request,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.profileUpdate}',
      );

      final multipartFiles = <http.MultipartFile>[];

      if (request.photo != null) {
        multipartFiles.add(
          await http.MultipartFile.fromPath(
            'photo',
            request.photo!.path,
          ),
        );
      }

      final response = await ApiClient.multipartRequest(
        'POST',
        url,
        fields: request.toFields(),
        files: multipartFiles.isNotEmpty ? multipartFiles : null,
      );

      return EditProfileResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Update Profile Failed: $e');
    }
  }
}
