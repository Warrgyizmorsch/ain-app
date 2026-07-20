import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../constant_api/api_constant.dart';
import '../../../models/payment_model/add_payment_sc_request_model.dart';
import '../../../models/payment_model/add_payment_sc_response_model.dart';
import '../../../network/network_api_service.dart';

class AddPaymentScApi {
  static Future<AddPaymentResponseModel> addPayment({
    required AddPaymentRequestModel request,
    required List<File> files,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstant.BASE_URL}${ApiConstant.addPayment}',
      );

      final multipartFiles = <http.MultipartFile>[];

      for (final file in files) {
        multipartFiles.add(
          await http.MultipartFile.fromPath(
            'screenshot',
            file.path,
          ),
        );
      }

      final response = await ApiClient.multipartRequest(
        'POST',
        url,
        fields: {
          'order_id': request.orderId,
          'paid_amount': request.paidAmount,
          'company_accounts': request.companyAccounts,
          'payee_name': request.payeeName,
          'reference': request.reference,
        },
        files: multipartFiles,
      );

      return AddPaymentResponseModel.fromJson(response);
    } catch (e) {
      // Exception message updated for clarity
      throw Exception('Add Payment Failed: $e');
    }
  }
}