import 'dart:io';

class PlaceOrderRequest {
  // String name;
  // String email;
  String country;
  // String countryCode;
  // String mobile;
  String service;
  String workType;
  String subject;
  String urgency;
  int wordCount;
  String topic;
  String requirements;
  String finalPrice;
  String sourcePage;
  PlaceOrderRequest({
    // required this.name,
    // required this.email,
    required this.country,
    // required this.countryCode,
    // required this.mobile,
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

  Map<String, dynamic> toJson() {
    return {
      // 'name': name,
      // 'email': email,
      'country': country,
      // 'countrycode': countryCode,
      // 'mobile': mobile,
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
  }
}