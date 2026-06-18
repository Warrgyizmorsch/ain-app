import 'package:get/get.dart';

class AddToCartController extends GetxController {
  final orderId = ''.obs;
  final service = ''.obs;
  final topic = ''.obs;
  final pages = ''.obs;
  final deadline = ''.obs;
  final amount = '0.00'.obs;

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
  }

  void updateAmount(String value) {
    amount.value = value;
  }

  void clearCart() {
    orderId.value = '';
    service.value = '';
    topic.value = '';
    pages.value = '';
    deadline.value = '';
    amount.value = '0.00';
  }
}