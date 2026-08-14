class CouponResponseModel {
  final bool? success;
  final String? message;
  final int? count;
  final List<CouponModel>? data;

  CouponResponseModel({
    this.success,
    this.message,
    this.count,
    this.data,
  });

  factory CouponResponseModel.fromJson(Map<String, dynamic> json) {
    return CouponResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      count: json['count'] as int?,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => CouponModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'count': count,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class CouponModel {
  final int? id;
  final String? couponCode;
  final String? discountType;
  final num? discountValue;
  final num? minOrderAmount;
  final num? maxDiscountAmount;
  final String? expiresAt;
  final int? usageLimitPerUser;
  final String? description;
  final String? createdAt;

  CouponModel({
    this.id,
    this.couponCode,
    this.discountType,
    this.discountValue,
    this.minOrderAmount,
    this.maxDiscountAmount,
    this.expiresAt,
    this.usageLimitPerUser,
    this.description,
    this.createdAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as int?,
      couponCode: json['coupon_code'] as String?,
      discountType: json['discount_type'] as String?,
      discountValue: json['discount_value'] as num?,
      minOrderAmount: json['min_order_amount'] as num?,
      maxDiscountAmount: json['max_discount_amount'] as num?,
      expiresAt: json['expires_at'] as String?,
      usageLimitPerUser: json['usage_limit_per_user'] as int?,
      description: json['description'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coupon_code': couponCode,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_order_amount': minOrderAmount,
      'max_discount_amount': maxDiscountAmount,
      'expires_at': expiresAt,
      'usage_limit_per_user': usageLimitPerUser,
      'description': description,
      'created_at': createdAt,
    };
  }
}

class ApplyCouponResponseModel {
  final bool? success;
  final String? message;
  final num? discountAmount;
  final num? finalPayableAmount;
  final CouponModel? data;

  ApplyCouponResponseModel({
    this.success,
    this.message,
    this.discountAmount,
    this.finalPayableAmount,
    this.data,
  });

  factory ApplyCouponResponseModel.fromJson(Map<String, dynamic> json) {
    return ApplyCouponResponseModel(
      success: json['success'] as bool? ?? (json['status'] == true),
      message: json['message'] as String?,
      discountAmount: (json['discount_amount'] ?? json['discount']) as num?,
      finalPayableAmount: (json['final_payable_amount'] ?? json['final_amount'] ?? json['payable_amount']) as num?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? CouponModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'discount_amount': discountAmount,
      'final_payable_amount': finalPayableAmount,
      'data': data?.toJson(),
    };
  }
}
