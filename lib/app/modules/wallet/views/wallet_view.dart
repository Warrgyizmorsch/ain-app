import '../../../common/constant/app_imports.dart';
import '../controllers/wallet_controller.dart';

class WalletView extends GetView<WalletController> {
    WalletView({super.key});

  String getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'GBP':
        return '£';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return currencyCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon:   Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
        title:   Text(
          'Wallet',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding:   EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          children: [
              SizedBox(height: 20),

            Image.asset(
              ImageConstant.wallet,
              width: 90,
              height: 90,
            ),

              SizedBox(height: 24),

            // Wallet Amount Card
            Container(
              width: 150,
              padding:   EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:   Color(0xFFB6E1FF),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                    Text(
                    "Wallet Amount",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                    SizedBox(height: 8),

                  // Reactive Wallet Amount text
                  Obx(() {
                    if (controller.isLoadingAmount.value) {
                      return   SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getCurrencySymbol(controller.currency.value),
                          style:   TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                          SizedBox(width: 4),
                        Text(
                          controller.walletAmount.value.toStringAsFixed(2),
                          style:   TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

              SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transaction History',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

              SizedBox(height: 12),

            Obx(() {
              if (controller.isLoadingTransactions.value) {
                return   Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.transactions.isEmpty) {
                return   Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'No Transaction history',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics:   NeverScrollableScrollPhysics(),
                itemCount: controller.transactions.length,
                separatorBuilder: (_, _) =>   SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = controller.transactions[index];

                  final isCredit = item.type.toLowerCase() == 'credit';
                  final sign = isCredit ? '+' : '-';
                  final color = isCredit ? Colors.green : Colors.red;

                  return Container(
                    padding:   EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:   Color(0xFFD6B9FF),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.description,
                                style:   TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                                SizedBox(height: 4),
                              Text(
                                item.createdAt,
                                style:   TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$sign${getCurrencySymbol(controller.currency.value)}${item.amount}',
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}