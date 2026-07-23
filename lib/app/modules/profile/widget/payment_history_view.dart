import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../../../core/models/payment_model/bank_list_model.dart';
import '../../../core/utils/api/payment_api/bank_list_api.dart';
import '../../assignments/controllers/assignments_controller.dart';
import '../../assignments/widget/order_details_view.dart';

class PaymentHistoryView extends StatefulWidget {
  const PaymentHistoryView({super.key});

  @override
  State<PaymentHistoryView> createState() => _PaymentHistoryViewState();
}

class _PaymentHistoryViewState extends State<PaymentHistoryView> {
  List<BankDetail> banksList = [];
  bool isLoadingBanks = true;

  @override
  void initState() {
    super.initState();
    _fetchBankDetails();
  }

  Future<void> _fetchBankDetails() async {
    try {
      final response = await BankListApi.getBankList();
      if (mounted) {
        setState(() {
          banksList = response.data ?? [];
          isLoadingBanks = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingBanks = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure AssignmentsController is initialized
    final controller = Get.put(AssignmentsController());

    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: AppStrings.payments,
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.primaryPurple),
            onPressed: () {
              controller.getOrderList();
              _fetchBankDetails();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Total Spent Card
            _buildTotalSpentCard(),
            const SizedBox(height: 24),

            // 2. Quick Actions Row
            _buildQuickActionsRow(),
            const SizedBox(height: 32),

            // 3. Transaction History Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.transactionHistory,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.bgLight,
                    border: Border.all(color: AppColors.lightDivider),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt_outlined, size: 16, color: AppColors.textPrimary),
                      const SizedBox(width: 6),
                      Text(
                        'Filter',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Dynamic Transaction List (Confirmed, Processing, Cancelled)
            Obx(() {
              final confirmedOrders = controller.orderResponse.value?.data?.confirmedOrders ?? [];

              if (controller.isLoading.value) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryPurple)),
                );
              }

              if (confirmedOrders.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.bgLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.lightDivider),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      Text(
                        'No transaction history found',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your completed or confirmed payments will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: confirmedOrders.map((order) => _buildConfirmedTransactionTile(order)).toList(),
              );
            }),
            const SizedBox(height: 32),

            // 5. Bank Transfer Details (Same as Order Now Step 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bank Transfer Details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Bank Transfer',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoadingBanks)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(child: CircularProgressIndicator(color: AppColors.primaryPurple)),
              )
            else if (banksList.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: Text("No bank details found.")),
              )
            else
              BankTransferDetailsWidget(
                banksList: banksList,
                tabViewHeight: 250,
              ),
            const SizedBox(height: 32),

            // 6. Support Banner
            const _SupportBanner(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ));
  }

  // ==========================================
  // WIDGET BUILDERS
  // ==========================================

  Widget _buildConfirmedTransactionTile(ConfirmedOrder order) {
    final String title = order.title ?? order.subject ?? 'Assignment Order';
    final String date = order.orderDate ?? order.createdAt ?? order.deliveryDate ?? '-';
    final String orderIdStr = order.orderId?.toString() ?? '0000';
    final String amountStr = '£${order.amount ?? '0.00'}';
    final String rawStatus = (order.status ?? order.confirmedStatus ?? 'Confirmed').toLowerCase();

    IconData icon;
    Color iconColor;
    Color iconBg;
    Color statusColor;
    String statusText;

    if (rawStatus.contains('cancel') || rawStatus.contains('failed')) {
      icon = Icons.cancel_outlined;
      iconColor = AppColors.error;
      iconBg = AppColors.error.withValues(alpha: 0.15);
      statusColor = AppColors.error;
      statusText = 'Cancelled';
    } else if (rawStatus.contains('process') || rawStatus.contains('progress') || rawStatus.contains('pending')) {
      icon = Icons.hourglass_top_outlined;
      iconColor = AppColors.warning;
      iconBg = AppColors.warning.withValues(alpha: 0.15);
      statusColor = AppColors.warning;
      statusText = 'Processing';
    } else {
      icon = Icons.assignment_turned_in_outlined;
      iconColor = AppColors.statusGreen;
      iconBg = AppColors.statusGreen.withValues(alpha: 0.15);
      statusColor = AppColors.statusGreen;
      statusText = 'Confirmed';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          Get.to(() => const OrderDetailsView(), arguments: order);
        },
        borderRadius: BorderRadius.circular(16),
        child: _buildTransactionTile(
          icon: icon,
          iconColor: iconColor,
          iconBg: iconBg,
          title: title,
          date: date,
          orderId: '#$orderIdStr',
          amount: amountStr,
          status: statusText,
          statusColor: statusColor,
        ),
      ),
    );
  }

  Widget _buildTotalSpentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Spent',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '£1,197.00',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Across all transactions',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // Simulated Wallet Illustration
          Container(
            width: 80,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.white70, size: 48),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text('£', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionItem(Icons.credit_card, AppColors.primaryPurple, AppColors.primaryPurple.withValues(alpha: 0.15), 'Payment\nMethods'),
          _buildQuickActionItem(Icons.receipt_long_outlined, AppColors.statusGreen, AppColors.statusGreen.withValues(alpha: 0.15), 'Invoices'),
          _buildQuickActionItem(Icons.autorenew, AppColors.secondary, AppColors.secondary.withValues(alpha: 0.15), 'Subscriptions'),
          _buildQuickActionItem(Icons.shield_outlined, const Color(0xFF1565C0), const Color(0xFF1565C0).withValues(alpha: 0.15), 'Security'),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, Color iconColor, Color bgColor, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String date,
    required String orderId,
    required String amount,
    String status = 'Paid',
    Color? statusColor,
  }) {
    final Color effectiveStatusColor = statusColor ?? AppColors.statusGreen;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  maxLines: 3, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Order $orderId',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: effectiveStatusColor),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }
}

class _SupportBanner extends StatelessWidget {
  const _SupportBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.headset_mic_outlined, color: AppColors.primaryPurple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help with payments?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our support team is here to assist you.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to support
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: const Text(
              'Contact Support',
              style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}