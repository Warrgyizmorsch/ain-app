class AddPaymentResponseModel {
  bool? success;
  String? message;
  PaymentDetails? payment;

  AddPaymentResponseModel({
    this.success,
    this.message,
    this.payment,
  });

  factory AddPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return AddPaymentResponseModel(
      success: json['success'],
      message: json['message'],
      payment: json['payment'] != null
          ? PaymentDetails.fromJson(json['payment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'payment': payment?.toJson(),
    };
  }
}

class PaymentDetails {
  int? id;
  String? orderId;
  dynamic paidAmount;
  int? accountStatus;
  String? screenshotUrl;

  PaymentDetails({
    this.id,
    this.orderId,
    this.paidAmount,
    this.accountStatus,
    this.screenshotUrl,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      id: json['id'],
      orderId: json['order_id'],
      paidAmount: json['paid_amount'],
      accountStatus: json['account_status'],
      screenshotUrl: json['screenshot_url'], // Nullable hai, isliye easily handle ho jayega
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'paid_amount': paidAmount,
      'account_status': accountStatus,
      'screenshot_url': screenshotUrl,
    };
  }
}