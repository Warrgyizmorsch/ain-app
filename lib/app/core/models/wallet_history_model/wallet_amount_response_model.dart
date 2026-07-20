class WalletResponseModel {
  final bool success;
  final WalletData data;

  WalletResponseModel({
    required this.success,
    required this.data,
  });

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletResponseModel(
      success: json["success"] ?? false,
      data: WalletData.fromJson(
        json["data"] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data.toJson(),
    };
  }
}

class WalletData {
  final num walletAmount;
  final String currency;

  WalletData({
    required this.walletAmount,
    required this.currency,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      walletAmount: json["wallet_amount"] ?? 0,
      currency: json["currency"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "wallet_amount": walletAmount,
      "currency": currency,
    };
  }
}