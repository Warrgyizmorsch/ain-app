class BankListResponseModel {
  bool? success;
  List<BankDetail>? data;

  BankListResponseModel({this.success, this.data});

  factory BankListResponseModel.fromJson(Map<String, dynamic> json) {
    return BankListResponseModel(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => BankDetail.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((i) => i.toJson()).toList(),
    };
  }
}

class BankDetail {
  int? id;
  String? name;
  String? accountHolder;
  String? accountNumber;
  String? sortCode;

  BankDetail({
    this.id,
    this.name,
    this.accountHolder,
    this.accountNumber,
    this.sortCode,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) {
    return BankDetail(
      id: json['id'],
      name: json['name'],
      accountHolder: json['account_holder'],
      accountNumber: json['account_number'],
      sortCode: json['sort_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'account_holder': accountHolder,
      'account_number': accountNumber,
      'sort_code': sortCode,
    };
  }
}