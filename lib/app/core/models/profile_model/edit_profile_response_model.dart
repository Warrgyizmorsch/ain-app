import '../login_model/login_response_model.dart';

class EditProfileResponseModel {
  final bool success;
  final String message;
  final UserData? data;

  EditProfileResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory EditProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return EditProfileResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}