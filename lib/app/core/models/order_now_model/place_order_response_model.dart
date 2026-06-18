class PlaceOrderResponse {
  bool? success;
  String? message;
  String? orderId;
  int? leadId;
  int? isAppLead;

  PlaceOrderResponse({
    this.success,
    this.message,
    this.orderId,
    this.leadId,
    this.isAppLead,
  });

  factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponse(
      success: json['success'],
      message: json['message'],
      orderId: json['order_id'],
      leadId: json['lead_id'],
      isAppLead: json['is_app_lead'],
    );
  }
}