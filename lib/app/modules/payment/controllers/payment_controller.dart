import 'package:get/get.dart';

class PaymentController extends GetxController {
  final selectedPaymentMethod = ''.obs;
  final orderId = ''.obs;
  final service = ''.obs;
  final topic = ''.obs;
  final pages = ''.obs;
  final deadline = ''.obs;
  final amount = '0.00'.obs;
  final discount = '0.00'.obs;
  final basePrice = '0.00'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final args = Get.arguments;

    if (args == null) return;

    orderId.value = args['orderId']?.toString() ?? '';
    service.value = args['service']?.toString() ?? '';
    topic.value = args['topic']?.toString() ?? '';
    pages.value = args['pages']?.toString() ?? '';
    deadline.value = args['deadline']?.toString() ?? '';
    amount.value = args['amount']?.toString() ?? '0.00';
    discount.value = args['discount']?.toString() ?? '0.00';
    basePrice.value = args['basePrice']?.toString() ?? '0.00';
  }
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void proceedToPay() {
    if (selectedPaymentMethod.isEmpty) {
      Get.snackbar('Error', 'Please select a payment method');
      return;
    }

    // Call payment API here
  }
}