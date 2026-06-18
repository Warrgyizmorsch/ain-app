class RegisterRequestModel {
  final String name;
  final String phoneNo;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequestModel({
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone_no": phoneNo,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
    };
  }
}