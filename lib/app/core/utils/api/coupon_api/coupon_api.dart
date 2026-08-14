import '../../../constant_api/api_constant.dart';
import '../../../models/coupon_model/coupon_model.dart';
import '../../../network/network_api_service.dart';

class CouponApi {
  static Future<CouponResponseModel> getCoupons() async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.COUPONS}');
      final response = await ApiClient.get(url);
      return CouponResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch coupons: $e');
    }
  }

  static Future<ApplyCouponResponseModel> applyCoupon({
    required String couponCode,
    required num orderAmount,
  }) async {
    try {
      final url = Uri.parse('${ApiConstant.BASE_URL}${ApiConstant.APPLY_COUPON}');
      final body = {
        'coupon_code': couponCode,
        'order_amount': orderAmount,
      };
      final response = await ApiClient.post(url, body: body);
      return ApplyCouponResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to apply coupon: $e');
    }
  }
}
