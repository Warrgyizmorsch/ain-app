class OrderListResponse {
  final bool? success;
  final OrderData? data;

  OrderListResponse({this.success, this.data});

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      success: json['success'],
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class OrderData {
  final List<ConfirmedOrder>? confirmedOrders;
  final List<Lead>? nonConfirmedLeads;
  final Summary? summary;

  OrderData({this.confirmedOrders, this.nonConfirmedLeads, this.summary});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      confirmedOrders: json['confirmed_orders'] != null
          ? (json['confirmed_orders'] as List)
          .map((e) => ConfirmedOrder.fromJson(e))
          .toList()
          : [],
      nonConfirmedLeads: json['non_confirmed_leads'] != null
          ? (json['non_confirmed_leads'] as List)
          .map((i) => Lead.fromJson(i))
          .toList()
          : [],
      summary: json['summary'] != null ? Summary.fromJson(json['summary']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'confirmed_orders': confirmedOrders?.map((e) => e.toJson()).toList(),
      'non_confirmed_leads': nonConfirmedLeads?.map((e) => e.toJson()).toList(),
      'summary': summary?.toJson(),
    };
  }
}
class ConfirmedOrder {
  final int? orderId;
  final String? name;
  final String? service;
  final String? workType;
  final String? price;
  final String? deadline;
  final String? status;

  ConfirmedOrder({
    this.orderId,
    this.name,
    this.service,
    this.workType,
    this.price,
    this.deadline,
    this.status,
  });

  factory ConfirmedOrder.fromJson(Map<String, dynamic> json) {
    return ConfirmedOrder(
      orderId: json['order_id'],
      name: json['name'],
      service: json['service'],
      workType: json['work_type'],
      price: json['price']?.toString(),
      deadline: json['deadline'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'name': name,
    'service': service,
    'work_type': workType,
    'price': price,
    'deadline': deadline,
    'status': status,
  };
}
class Lead {
  final String? type;
  final String? confirmedStatus;
  final int? leadId;
  final String? orderId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? countrycode;
  final String? service;
  final String? workType;
  final String? wordCount;
  final String? price;
  final String? deadline;
  final dynamic deliveryTime;
  final String? requirements;
  final int? isAppLead;
  final int? isConverted;
  final dynamic convertedAt;
  final String? createdAt;

  Lead({
    this.type,
    this.confirmedStatus,
    this.leadId,
    this.orderId,
    this.name,
    this.email,
    this.mobile,
    this.countrycode,
    this.service,
    this.workType,
    this.wordCount,
    this.price,
    this.deadline,
    this.deliveryTime,
    this.requirements,
    this.isAppLead,
    this.isConverted,
    this.convertedAt,
    this.createdAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      type: json['type'],
      confirmedStatus: json['confirmed_status'],
      leadId: json['lead_id'],
      orderId: json['order_id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      countrycode: json['countrycode'],
      service: json['service'],
      workType: json['work_type'],
      wordCount: json['word_count'],
      price: json['price'],
      deadline: json['deadline'],
      deliveryTime: json['delivery_time'],
      requirements: json['requirements'],
      isAppLead: json['is_app_lead'],
      isConverted: json['is_converted'],
      convertedAt: json['converted_at'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'confirmed_status': confirmedStatus,
      'lead_id': leadId,
      'order_id': orderId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'countrycode': countrycode,
      'service': service,
      'work_type': workType,
      'word_count': wordCount,
      'price': price,
      'deadline': deadline,
      'delivery_time': deliveryTime,
      'requirements': requirements,
      'is_app_lead': isAppLead,
      'is_converted': isConverted,
      'converted_at': convertedAt,
      'created_at': createdAt,
    };
  }
}

class Summary {
  final int? confirmedCount;
  final int? nonConfirmedCount;

  Summary({this.confirmedCount, this.nonConfirmedCount});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      confirmedCount: json['confirmed_count'],
      nonConfirmedCount: json['non_confirmed_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'confirmed_count': confirmedCount,
      'non_confirmed_count': nonConfirmedCount,
    };
  }
}