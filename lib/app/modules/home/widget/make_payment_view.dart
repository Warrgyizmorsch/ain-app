import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../../assignments/controllers/assignments_controller.dart';
import '../../assignments/widget/order_details_view.dart';

class MakePaymentView extends GetView<AssignmentsController> {
  const MakePaymentView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(AssignmentsController());

    return Obx(() {
      final pendingAssignments = controller.nonConfirmedLeads;
      final banksList = controller.banksList;
      final isLoading = controller.isLoading.value;
      final isBankLoading = controller.isBankLoading.value;

      return Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: CustomAppBar(
          title: 'Make Payment',
          showBackButton: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: AppColors.primaryPurple),
              onPressed: () {
                controller.getOrderList();
                controller.bankList();
              },
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: AppColors.primaryPurple))
            : Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Total Spent Card
                        _buildTotalSpentCard(),
                        const SizedBox(height: 24),

                        // 2. Quick Actions Row
                        _buildQuickActionsRow(),
                        const SizedBox(height: 32),

                        // 3. Pending Payments Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.pending_actions, color: AppColors.error, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  'Pending Payments',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${pendingAssignments.length} Pending',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // 4. Pending Assignment Cards from AssignmentsController
                        if (pendingAssignments.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.bgLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.lightDivider),
                            ),
                            child: Center(
                              child: Text(
                                'No pending payments found.',
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ),
                          )
                        else
                          ...pendingAssignments.map((lead) => Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: _buildPendingAssignmentCard(lead),
                          )),

                        const SizedBox(height: 24),

                        // 5. Bank Transfer Details (Same as Order Now Step 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.account_balance_outlined, color: AppColors.primaryPurple, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  'Bank Transfer Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPurple.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Official Accounts',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        if (isBankLoading)
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(child: CircularProgressIndicator(color: AppColors.primaryPurple)),
                          )
                        else if (banksList.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.bgLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.lightDivider),
                            ),
                            child: Center(
                              child: Text("No bank details found.", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                            ),
                          )
                        else
                          BankTransferDetailsWidget(
                            banksList: banksList,
                            tabViewHeight: 250,
                          ),

                        const SizedBox(height: 28),

                        // 6. Support Banner
                        _buildSupportBanner(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                  const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
                ],
              ),
      );
    });
  }

  // ==========================================
  // WIDGET BUILDERS
  // ==========================================

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

  Widget _buildPendingAssignmentCard(Lead lead) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.assignment_late_outlined, color: AppColors.error, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${lead.orderId ?? "0000"}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Deadline: ${lead.deadline ?? '-'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // EDIT SYMBOL
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.ADD_ORDER, arguments: lead);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.edit_outlined, color: AppColors.primaryPurple, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Pending',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Divider(height: 1, color: AppColors.lightDivider),
          ),

          // Details Row
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.tagBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.description_outlined, color: AppColors.primaryPurple, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.service ?? 'Assignment',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lead.subject ?? 'General Subject',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  '£${lead.price ?? '0.00'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Divider(height: 1, color: AppColors.lightDivider),
          ),

          // Footer Action Buttons Row
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Get.to(() => const OrderDetailsView(), arguments: lead);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryPurple, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: AppColors.primaryPurple, size: 16),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => const OrderDetailsView(), arguments: lead);
                  },
                  icon: const Icon(Icons.payment, color: AppColors.white, size: 16),
                  label: const Text(
                    'Make Payment',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportBanner() {
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
                  'Need help with payment?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our support team is available 24/7.',
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
              Get.toNamed(Routes.CHAT);
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
