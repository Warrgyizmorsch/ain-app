class PlaceOrderRequest {
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
  String? couponCode;
  String? orderAmount;
  String? discountAmount;

  PlaceOrderRequest({
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
    this.couponCode,
    this.orderAmount,
    this.discountAmount,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'service': service,
      'workType': workType,
      'subject': subject,
      'urgency': urgency,
      'wordCount': wordCount,
      'topic': topic,
      'requirements': requirements,
      'finalPrice': finalPrice,
      'source_page': sourcePage,
    };
    if (expertId != null && expertId!.isNotEmpty) {
      data['expert_id'] = expertId;
      data['writer_id'] = expertId;
    }
    if (expertName != null && expertName!.isNotEmpty) {
      data['expert_name'] = expertName;
      data['writer_name'] = expertName;
    }

    data['wallet'] = useWallet;
    if (couponCode != null && couponCode!.isNotEmpty) {
      data['coupon_code'] = couponCode;
    }
    if (orderAmount != null && orderAmount!.isNotEmpty) {
      data['order_amount'] = orderAmount;
    }
    if (discountAmount != null && discountAmount!.isNotEmpty) {
      data['discount_amount'] = discountAmount;
    }

    return data;
  }
}
