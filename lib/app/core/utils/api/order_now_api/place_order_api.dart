import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../constant_api/api_constant.dart';
import '../../../models/order_now_model/place_order_request_model.dart';
import '../../../models/order_now_model/place_order_response_model.dart';
import '../../../network/network_api_service.dart';

class PlaceOrderApi {
  static Future<PlaceOrderResponse> placeOrder({
    required PlaceOrderRequest request,
    required List<File> files,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.PLACE_ORDER}',
      );

      final multipartFiles = <http.MultipartFile>[];

      for (final file in files) {
        multipartFiles.add(
          await http.MultipartFile.fromPath(
            'fileUpload[]',
            file.path,
          ),
        );
      }

      final response = await ApiClient.multipartRequest(
        'POST',
        url,
        fields: {
          // 'name': request.name ?? '',
          // 'email': request.email ?? '',
          // 'country': request.country ,
          // 'countrycode': request.countryCode ?? '',
          // 'mobile': request.mobile ?? '',
          'service': request.service ,
          'workType': request.workType ,
          'subject': request.subject ,
          'urgency': request.urgency ,
          'wordCount': request.wordCount.toString() ,
          'topic': request.topic,
          'requirements': request.requirements ,
          'finalPrice': request.finalPrice ,
          'source_page': request.sourcePage ,
        },
        files: multipartFiles,
      );

      return PlaceOrderResponse.fromJson(response);
    } catch (e) {
      throw Exception('Place Order Failed: $e');
    }
  }
}