import 'dart:convert';

class ResetPasswordRequestModel {
  final String token;
  final String email;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequestModel({
    required this.token,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  /// Converts the model instance into a Map for JSON encoding
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }

  /// Helper to get the JSON string for the API body
  String toRawJson() => json.encode(toJson());
}