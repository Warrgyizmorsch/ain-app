import 'dart:io';

class EditProfileRequestModel {
  final String name;
  final String email;
  final String mobileNo;
  final String countrycode;
  final String country;
  final File? photo;

  EditProfileRequestModel({
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.countrycode,
    required this.country,
    this.photo,
  });

  Map<String, String> toFields() {
    return {
      'name': name,
      'email': email,
      'mobile_no': mobileNo,
      'countrycode': countrycode,
      'country': country,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile_no': mobileNo,
      'countrycode': countrycode,
      'country': country,
    };
  }
}
