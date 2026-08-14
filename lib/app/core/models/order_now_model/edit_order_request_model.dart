class EditOrderRequest {
  String orderId;
  String service;
  String workType;
  String subject;
  String urgency;
  int wordCount;
  String topic;
  String requirements;
  String finalPrice;
  String sourcePage;
  String? expertId;
  String? expertName;
  bool? useWallet;
  String? walletAmount;
  String? couponCode;
  String? orderAmount;
  String? discountAmount;

  EditOrderRequest({
    required this.orderId,
    required this.service,
    required this.workType,
    required this.subject,
    required this.urgency,
    required this.wordCount,
    required this.topic,
    required this.requirements,
    required this.finalPrice,
    required this.sourcePage,
    this.expertId,
    this.expertName,
    this.useWallet,
    this.walletAmount,
    this.couponCode,
    this.orderAmount,
    this.discountAmount,
  });

  Map<String, String> toFields() {
    final fields = <String, String>{
      'order_id': orderId,
      'service': service,
      'workType': workType,
      'subject': subject,
      'urgency': urgency,
      'wordCount': wordCount.toString(),
      'topic': topic,
      'requirements': requirements,
      'finalPrice': finalPrice,
      'source_page': sourcePage,
    };
    if (expertId != null && expertId!.isNotEmpty) {
      fields['expert_id'] = expertId!;
      fields['writer_id'] = expertId!;
    }
    if (expertName != null && expertName!.isNotEmpty) {
      fields['expert_name'] = expertName!;
      fields['writer_name'] = expertName!;
    }
    if (useWallet == true) {
      fields['use_wallet'] = '1';
      fields['wallet_amount'] = walletAmount ?? '0';
    }
    if (couponCode != null && couponCode!.isNotEmpty) {
      fields['coupon_code'] = couponCode!;
    }
    if (orderAmount != null && orderAmount!.isNotEmpty) {
      fields['order_amount'] = orderAmount!;
    }
    if (discountAmount != null && discountAmount!.isNotEmpty) {
      fields['discount_amount'] = discountAmount!;
    }
    return fields;
  }
}
