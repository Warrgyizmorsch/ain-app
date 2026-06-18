class RegisterResponseModel {
  final bool success;
  final String message;
  final String token;
  final RegisterUserData data;

  RegisterResponseModel({
    required this.success,
    required this.message,
    required this.token,
    required this.data,
  });

  factory RegisterResponseModel.fromJson(
      Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      token: json["token"] ?? "",
      data: RegisterUserData.fromJson(
        json["data"] ?? {},
      ),
    );
  }
}
class RegisterUserData {
  final int id;
  final int roleId;
  final String name;
  final String mobileNo;
  final String email;
  final String createdAt;
  final String updatedAt;

  RegisterUserData({
    required this.id,
    required this.roleId,
    required this.name,
    required this.mobileNo,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegisterUserData.fromJson(
      Map<String, dynamic> json) {
    return RegisterUserData(
      id: json["id"] ?? 0,
      roleId: json["role_id"] ?? 0,
      name: json["name"] ?? "",
      mobileNo: json["mobile_no"] ?? "",
      email: json["email"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "role_id": roleId,
      "name": name,
      "mobile_no": mobileNo,
      "email": email,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}