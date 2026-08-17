import 'package:ain/app/common/constant/app_imports.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../../assignments/controllers/assignments_controller.dart';
import '../../assignments/widget/order_details_view.dart';

class MyOrdersWidget extends StatelessWidget {
  MyOrdersWidget({super.key});

  final AssignmentsController controller = Get.put(AssignmentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: AppStrings.myOrders,
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // --- Tabs ---
              _buildTabs(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Orders List ---
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(color: AppColors.primary),
                            ),
                          );
                        }

                        final assignments = controller.filteredAssignments;
                        if (assignments.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text(
                                'No recent orders found.',
                                style: TextStyle(fontFamily: FontFamily.regular, color: AppColors.textSecondary, fontSize: 16),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: assignments.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = assignments[index];
                            return _buildDynamicOrderTile(item);
                          },
                        );
                      }),

                      const SizedBox(height: 24),

                      // --- Support Banner ---
                      const _SupportBanner(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
        ],
      ),
    ));
  }

  Widget _buildTabs() {
    return Container(
      color: AppColors.bgLight,
      padding: const EdgeInsets.only(top: 4),
      child: Obx(() {
        final currentFilter = controller.selectedFilter.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TabItem(
              title: 'All Orders',
              isActive: currentFilter == OrderFilter.all,
              onTap: () => controller.updateFilter(OrderFilter.all),
            ),
            _TabItem(
              title: 'Completed',
              isActive: currentFilter == OrderFilter.completed,
              onTap: () => controller.updateFilter(OrderFilter.completed),
            ),
            _TabItem(
              title: 'Processing',
              isActive: currentFilter == OrderFilter.inProgress,
              onTap: () => controller.updateFilter(OrderFilter.inProgress),
            ),
            _TabItem(
              title: 'Cancelled',
              isActive: currentFilter == OrderFilter.pending, // Mapped to pending in logic
              onTap: () => controller.updateFilter(OrderFilter.pending),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDynamicOrderTile(dynamic item) {
    String orderId = '';
    String serviceName = 'Unknown Service';
    String date = '';
    String price = '0.00';
    OrderStatus status = OrderStatus.pending;
    String? rawStatus;
    String? deliveryDate;
    int? progressPercentage;

    // Item mapping logic
    if (item is ConfirmedOrder) {
      orderId = item.orderId ?? 'Unknown';
      serviceName = item.title ?? item.subject ?? 'No Title';
      price = item.amount ?? '0.00';
      rawStatus = item.status ?? 'in_progress';
      deliveryDate = item.deliveryDate;
      progressPercentage = item.progressPercentage ?? item.progress ?? 0;

      final String s = (item.status ?? '').toLowerCase().trim();
      if (s == 'completed' || s == 'delivered') {
        status = OrderStatus.completed;
      } else if (s == 'cancelled') {
        status = OrderStatus.cancelled;
      } else {
        status = OrderStatus.inProgress;
      }
      date = item.deliveryDate ?? item.orderDate ?? item.createdAt ?? '';
    } else if (item is Lead) {
      orderId = item.orderId ?? 'Unknown';
      serviceName = item.service ?? item.subject ?? 'No Service';
      date = item.createdAt ?? '';
      price = item.price ?? '0.00';
      status = OrderStatus.pending;
      rawStatus = item.confirmedStatus ?? "pending";
      deliveryDate = item.deadline;
      progressPercentage = item.progressPercentage ?? item.progress;
    }

    // Default formatting if date is empty, adapt to your API's format
    final displayDate = date.isNotEmpty ? date : "May 12, 2025 • 10:30 AM";

    return _OrderTile(
      orderId: orderId.startsWith('#') ? orderId : '#$orderId',
      serviceName: serviceName,
      date: displayDate,
      price: price.startsWith('£') ? price : '£$price',
      status: status,
      rawStatus: rawStatus,
      deliveryDate: deliveryDate,
      progressPercentage: progressPercentage,
      onTap: () {
        Get.to(() => const OrderDetailsView(), arguments: item);
      },
    );
  }
}

// ============================================================================
// CUSTOM WIDGETS
// ============================================================================

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.primaryPurple : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: FontFamily.regular,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.primaryPurple : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

enum OrderStatus { completed, inProgress, cancelled, pending }

class _OrderTile extends StatelessWidget {
  final String orderId;
  final String serviceName;
  final String date;
  final String price;
  final OrderStatus status;
  final String? rawStatus;
  final String? deliveryDate;
  final int? progressPercentage;
  final VoidCallback onTap;

  const _OrderTile({
    required this.orderId,
    required this.serviceName,
    required this.date,
    required this.price,
    required this.status,
    this.rawStatus,
    this.deliveryDate,
    this.progressPercentage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    Color iconBgColor;
    String statusText;
    IconData leadingIcon;

    switch (status) {
      case OrderStatus.completed:
        iconColor = AppColors.statusGreen;
        iconBgColor = AppColors.statusGreen.withValues(alpha: 0.15);
        statusText = 'Completed';
        leadingIcon = Icons.assignment_turned_in_outlined;
        break;
      case OrderStatus.inProgress:
        iconColor = AppColors.primaryPurple;
        iconBgColor = AppColors.primaryPurple.withValues(alpha: 0.15);
        statusText = 'Processing';
        leadingIcon = Icons.assignment_outlined;
        break;
      case OrderStatus.cancelled:
      case OrderStatus.pending:
        iconColor = AppColors.error;
        iconBgColor = AppColors.error.withValues(alpha: 0.15);
        statusText = status == OrderStatus.pending ? 'Pending' : 'Cancelled';
        leadingIcon = Icons.assignment_late_outlined;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
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
          // --- HEADER SECTION ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(leadingIcon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order $orderId',
                        style: TextStyle(
                          fontFamily: FontFamily.regular,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontFamily: FontFamily.regular,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                OrderStatusBadgeWidget(
                  status: rawStatus ?? statusText,
                ),
              ],
            ),
          ),

          const CustomDashedDivider(),

          // --- ITEM DETAILS SECTION ---
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                        serviceName,
                        style: TextStyle(
                          fontFamily: FontFamily.regular,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        deliveryDate != null && deliveryDate!.isNotEmpty
                            ? 'Delivery: $deliveryDate'
                            : 'Delivery: TBD',
                        style: TextStyle(
                          fontFamily: FontFamily.regular,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                OrderProgressStatusWidget(
                  status: rawStatus ?? statusText,
                  deliveryDate: deliveryDate ?? date,
                  progressPercentage: progressPercentage,
                  size: 44,
                ),
              ],
            ),
          ),

          const CustomDashedDivider(),

          // --- FOOTER / TOTAL SECTION ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: TextStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryPurple, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontFamily: FontFamily.regular,
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
              ],
            ),
          ),
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
            child: Icon(Icons.headset_mic_outlined, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help with your order?',
                  style: TextStyle(
                    fontFamily: FontFamily.regular,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our support team is here to help you.',
                  style: TextStyle(
                    fontFamily: FontFamily.regular,
                    fontSize: 12,
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
              backgroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: Text(
              'Contact Support',
              style: TextStyle(fontFamily: FontFamily.regular, color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// Utility widget for the dashed line separator
class CustomDashedDivider extends StatelessWidget {
  const CustomDashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.lightDivider),
              ),
            );
          }),
        );
      },
    );
  }
}