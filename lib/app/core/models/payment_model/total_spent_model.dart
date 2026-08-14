class TotalSpentResponseModel {
  bool? success;
  String? message;
  TotalSpentData? data;

  TotalSpentResponseModel({this.success, this.message, this.data});

  factory TotalSpentResponseModel.fromJson(Map<String, dynamic> json) {
    return TotalSpentResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? TotalSpentData.fromJson(json['data']) : null,
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

class TotalSpentData {
  num? totalSpent;
  num? totalOrdersAmount;
  num? totalDueAmount;
  int? confirmedOrdersCount;
  num? totalWalletSpent;
  num? walletBalance;
  String? currency;

  TotalSpentData({
    this.totalSpent,
    this.totalOrdersAmount,
    this.totalDueAmount,
    this.confirmedOrdersCount,
    this.totalWalletSpent,
    this.walletBalance,
    this.currency,
  });

  factory TotalSpentData.fromJson(Map<String, dynamic> json) {
    return TotalSpentData(
      totalSpent: json['total_spent'] is num
          ? json['total_spent']
          : num.tryParse(json['total_spent']?.toString() ?? ''),
      totalOrdersAmount: json['total_orders_amount'] is num
          ? json['total_orders_amount']
          : num.tryParse(json['total_orders_amount']?.toString() ?? ''),
      totalDueAmount: json['total_due_amount'] is num
          ? json['total_due_amount']
          : num.tryParse(json['total_due_amount']?.toString() ?? ''),
      confirmedOrdersCount: json['confirmed_orders_count'] is int
          ? json['confirmed_orders_count']
          : int.tryParse(json['confirmed_orders_count']?.toString() ?? ''),
      totalWalletSpent: json['total_wallet_spent'] is num
          ? json['total_wallet_spent']
          : num.tryParse(json['total_wallet_spent']?.toString() ?? ''),
      walletBalance: json['wallet_balance'] is num
          ? json['wallet_balance']
          : num.tryParse(json['wallet_balance']?.toString() ?? ''),
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_spent': totalSpent,
      'total_orders_amount': totalOrdersAmount,
      'total_due_amount': totalDueAmount,
      'confirmed_orders_count': confirmedOrdersCount,
      'total_wallet_spent': totalWalletSpent,
      'wallet_balance': walletBalance,
      'currency': currency,
    };
  }
}
