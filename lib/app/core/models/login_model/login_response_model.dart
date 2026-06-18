class LoginResponseModel {
  final bool success;
  final String message;
  final String token;
  final UserData data;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.token,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }
}
class UserData {
  final int id;
  final String? name;
  final String? email;
  final String? mobileNo;
  final int? roleId;
  final int? departmentId;
  final String? photo;
  final int? verifyed;
  final int? totalSecondsToday;
  final String? createdAt;
  final String? updatedAt;

  UserData({
    required this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.roleId,
    this.departmentId,
    this.photo,
    this.verifyed,
    this.totalSecondsToday,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'],
      email: json['email'],
      mobileNo: json['mobile_no'],
      roleId: json['role_id'],
      departmentId: json['department_id'],
      photo: json['photo'],
      verifyed: json['verifyed'],
      totalSecondsToday: json['total_seconds_today'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile_no': mobileNo,
      'role_id': roleId,
      'department_id': departmentId,
      'photo': photo,
      'verifyed': verifyed,
      'total_seconds_today': totalSecondsToday,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}