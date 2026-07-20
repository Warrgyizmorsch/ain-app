import '../../../common/constant/app_imports.dart';
import '../../../core/models/wallet_history_model/wallet_history_response_model.dart';
import '../../../core/utils/api/wallet_api/wallet_api_endpoint.dart'; // Adjust path if needed


class WalletController extends GetxController {
  final RxBool isLoadingAmount = true.obs;
  final RxBool isLoadingTransactions = true.obs;

  final RxNum walletAmount = RxNum(0);
  final RxString currency = 'GBP'.obs;

  final RxList<Transaction> transactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletAmount();
    fetchTransactions();
  }

  Future<void> fetchWalletAmount() async {
    try {
      isLoadingAmount(true);
      final response = await WalletApiEndpoint.getWalletAmount();

      if (response.success) {
        walletAmount.value = response.data.walletAmount;
        currency.value = response.data.currency;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch wallet amount');
      debugPrint('Wallet Amount Error: $e');
    } finally {
      isLoadingAmount(false);
    }
  }

  Future<void> fetchTransactions() async {
    try {
      isLoadingTransactions(true);
      final response = await WalletApiEndpoint.getWalletList();

      if (response.success) {
        transactions.assignAll(response.data.transactions);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch transaction history');
      debugPrint('Transaction Error: $e');
    } finally {
      isLoadingTransactions(false);
    }
  }
}