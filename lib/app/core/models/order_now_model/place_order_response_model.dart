class PlaceOrderResponse {
  bool? success;
  String? message;
  String? orderId;
  int? leadId;
  int? isAppLead;
  int? writerId;
  dynamic totalAmount;
  dynamic receivedAmount;
  dynamic dueAmount;
  bool? walletUsed;
  dynamic walletDeducted;
  dynamic walletBalance;

  PlaceOrderResponse({
    this.success,
    this.message,
    this.orderId,
    this.leadId,
    this.isAppLead,
    this.writerId,
    this.totalAmount,
    this.receivedAmount,
    this.dueAmount,
    this.walletUsed,
    this.walletDeducted,
    this.walletBalance,
  });

  factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponse(
      success: json['success'],
      message: json['message'],
      orderId: json['order_id'],
      leadId: json['lead_id'],
      isAppLead: json['is_app_lead'],
      writerId: json['writer_id'],
      totalAmount: json['total_amount'],
      receivedAmount: json['received_amount'],
      dueAmount: json['due_amount'],
      walletUsed: json['wallet_used'],
      walletDeducted: json['wallet_deducted'],
      walletBalance: json['wallet_balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'order_id': orderId,
      'lead_id': leadId,
      'is_app_lead': isAppLead,
      'writer_id': writerId,
      'total_amount': totalAmount,
      'received_amount': receivedAmount,
      'due_amount': dueAmount,
      'wallet_used': walletUsed,
      'wallet_deducted': walletDeducted,
      'wallet_balance': walletBalance,
    };
  }
}