import 'dart:io';

class AddPaymentRequestModel {
  final String orderId;
  final String paidAmount;
  final String companyAccounts;
  final String payeeName;
  final String reference;
  final File screenshot;

  AddPaymentRequestModel({
    required this.orderId,
    required this.paidAmount,
    required this.companyAccounts,
    required this.payeeName,
    required this.reference,
    required this.screenshot,
  });

  Map<String, String> toFields() {
    return {
      'order_id': orderId,
      'paid_amount': paidAmount,
      'company_accounts': companyAccounts,
      'payee_name': payeeName,
      'reference': reference,
    };
  }
}