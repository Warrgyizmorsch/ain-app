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
  });

  Map<String, String> toFields() {
    return {
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
  }
}
