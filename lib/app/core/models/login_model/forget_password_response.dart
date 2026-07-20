class ForgetPasswordResponseModel {
  bool success;
  String message;
  int expiresIn;

  ForgetPasswordResponseModel({
    required this.success,
    required this.message,
    required this.expiresIn,
  });

  factory ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponseModel(
      success: json['success'],
      message: json['message'],
      expiresIn: json['expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}

class ForgetPasswordOTPResponseModel {
  bool? success;
  String? message;
  String? resetToken;
  String? expiresIn;

  ForgetPasswordOTPResponseModel({
    this.success,
    this.message,
    this.resetToken,
    this.expiresIn,
  });

  factory ForgetPasswordOTPResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordOTPResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Something went wrong',
      resetToken: json['reset_token'],
      // Safely convert int to String (e.g., 900 to "900")
      expiresIn: json['expires_in']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (resetToken != null) 'reset_token': resetToken,
      if (expiresIn != null) 'expires_in': expiresIn,
    };
  }
}
class ChangePasswordModel {
  bool success;
  String message;

  ChangePasswordModel({
    required this.success,
    required this.message,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      // Safely handles boolean true, string "true", or null
      success: json['success'] == true || json['success'] == 'true',

      // Safely converts to string and provides a fallback if null
      message: json['message']?.toString() ?? 'Unknown error occurred',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}