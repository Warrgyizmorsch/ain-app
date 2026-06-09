import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final amountController = TextEditingController(text: '300');

  final transactions = [
    {
      "title": "AIN",
      "amount": "+\$300",
    }
  ].obs;

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}