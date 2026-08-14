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
      summary:
      json['summary'] != null ? Summary.fromJson(json['summary']) : null,
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
  final String? type;
  final String? confirmedStatus;
  final int? orderDbId;
  final int? leadId;
  final String? orderId;
  final String? orderDate;
  final String? deliveryDate;
  final String? title;
  final String? moduleCode;
  final String? subject;
  final String? status;
  final String? wordCount;
  final String? amount;
  final String? receivedAmount;
  final dynamic dueAmount;
  final int? timesPaidCount;
  final List<PaymentHistory>? paymentHistory;
  final String? createdAt;
  final int? writerId;
  final Writer? writer;
  final List<String>? images;
  final List<String>? files;

  ConfirmedOrder({
    this.type,
    this.confirmedStatus,
    this.orderDbId,
    this.leadId,
    this.orderId,
    this.orderDate,
    this.deliveryDate,
    this.title,
    this.moduleCode,
    this.subject,
    this.status,
    this.wordCount,
    this.amount,
    this.receivedAmount,
    this.dueAmount,
    this.timesPaidCount,
    this.paymentHistory,
    this.createdAt,
    this.writerId,
    this.writer,
    this.images,
    this.files,
  });

  factory ConfirmedOrder.fromJson(Map<String, dynamic> json) {
    return ConfirmedOrder(
      type: json['type'],
      confirmedStatus: json['confirmed_status'],
      orderDbId: json['order_db_id'],
      leadId: json['lead_id'],
      orderId: json['order_id'],
      orderDate: json['order_date']?.toString(),
      deliveryDate: json['delivery_date']?.toString(),
      title: json['title'],
      moduleCode: json['module_code']?.toString(),
      subject: json['subject']?.toString(),
      status: json['status']?.toString(),
      wordCount: json['word_count']?.toString(),
      amount: json['amount']?.toString(),
      receivedAmount: json['received_amount']?.toString(),
      dueAmount: json['due_amount'],
      timesPaidCount: json['times_paid_count'],
      paymentHistory: json['payment_history'] != null
          ? (json['payment_history'] as List)
          .map((e) => PaymentHistory.fromJson(e))
          .toList()
          : [],
      createdAt: json['created_at'],
      writerId: json['writer_id'],
      writer: json['writer'] != null ? Writer.fromJson(json['writer']) : null,
      images: json['images'] != null
          ? List<String>.from(json['images'].map((x) => x.toString()))
          : [],
      files: json['files'] != null
          ? List<String>.from(json['files'].map((x) => x.toString()))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'confirmed_status': confirmedStatus,
    'order_db_id': orderDbId,
    'lead_id': leadId,
    'order_id': orderId,
    'order_date': orderDate,
    'delivery_date': deliveryDate,
    'title': title,
    'module_code': moduleCode,
    'subject': subject,
    'status': status,
    'word_count': wordCount,
    'amount': amount,
    'received_amount': receivedAmount,
    'due_amount': dueAmount,
    'times_paid_count': timesPaidCount,
    'payment_history': paymentHistory?.map((e) => e.toJson()).toList(),
    'created_at': createdAt,
    'writer_id': writerId,
    'writer': writer?.toJson(),
    'images': images,
    'files': files,
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
  final List<PaymentHistory>? paymentHistory;
  final String? createdAt;
  final String? subject;
  final int? writerId;
  final Writer? writer;
  final List<String>? images;
  final List<String>? files;

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
    this.paymentHistory,
    this.createdAt,
    this.subject,
    this.writerId,
    this.writer,
    this.images,
    this.files,
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
      wordCount: json['word_count']?.toString(),
      price: json['price']?.toString(),
      deadline: json['deadline'],
      deliveryTime: json['delivery_time'],
      requirements: json['requirements'],
      isAppLead: json['is_app_lead'],
      isConverted: json['is_converted'],
      convertedAt: json['converted_at'],
      paymentHistory: json['payment_history'] != null
          ? (json['payment_history'] as List)
          .map((e) => PaymentHistory.fromJson(e))
          .toList()
          : [],
      createdAt: json['created_at'],
      subject: json['subject'],
      writerId: json['writer_id'],
      writer: json['writer'] != null ? Writer.fromJson(json['writer']) : null,
      images: json['images'] != null
          ? List<String>.from(json['images'].map((x) => x.toString()))
          : [],
      files: json['files'] != null
          ? List<String>.from(json['files'].map((x) => x.toString()))
          : [],
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
      'payment_history': paymentHistory?.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
      'subject': subject,
      'writer_id': writerId,
      'writer': writer?.toJson(),
      'images': images,
      'files': files,
    };
  }
}

// ---- NEW CLASS ADDED ----
class PaymentHistory {
  final int? paymentId;
  final dynamic paidAmount;
  final String? paymentDate;
  final String? paymentMethod;
  final String? payeeName;
  final String? accountStatus;
  final String? createdAt;

  PaymentHistory({
    this.paymentId,
    this.paidAmount,
    this.paymentDate,
    this.paymentMethod,
    this.payeeName,
    this.accountStatus,
    this.createdAt,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      paymentId: json['payment_id'],
      paidAmount: json['paid_amount'],
      paymentDate: json['payment_date'],
      paymentMethod: json['payment_method'],
      payeeName: json['payee_name'],
      accountStatus: json['account_status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'paid_amount': paidAmount,
      'payment_date': paymentDate,
      'payment_method': paymentMethod,
      'payee_name': payeeName,
      'account_status': accountStatus,
      'created_at': createdAt,
    };
  }
}

class Writer {
  final int? id;
  final String? writerName;
  final String? image;
  final String? subject;
  final String? service;
  final String? slug;

  Writer({
    this.id,
    this.writerName,
    this.image,
    this.subject,
    this.service,
    this.slug,
  });

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      id: json['id'],
      writerName: json['writer_name'],
      image: json['image'],
      subject: json['subject'],
      service: json['service'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'writer_name': writerName,
      'image': image,
      'subject': subject,
      'service': service,
      'slug': slug,
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