import '../login_model/login_response_model.dart';

class ProfileResponseModel {
  final bool success;
  final UserData? data;

  ProfileResponseModel({
    required this.success,
    this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}
