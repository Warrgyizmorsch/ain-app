import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../constant_api/api_constant.dart';
import '../../../models/order_now_model/edit_order_request_model.dart';
import '../../../models/order_now_model/place_order_response_model.dart';
import '../../../network/network_api_service.dart';

class EditOrderApi {
  static Future<PlaceOrderResponse> editOrder({
    required EditOrderRequest request,
    required List<File> files,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.EDIT_ORDER}',
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
        fields: request.toFields(),
        files: multipartFiles,
      );

      return PlaceOrderResponse.fromJson(response);
    } catch (e) {
      throw Exception('Edit Order Failed: $e');
    }
  }
}
