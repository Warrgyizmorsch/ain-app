import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../controllers/assignments_controller.dart';
import '../widget/order_details_view.dart';

class AssignmentsView extends StatelessWidget {
  const AssignmentsView({super.key});

  AssignmentsController get controller => Get.isRegistered<AssignmentsController>()
      ? Get.find<AssignmentsController>()
      : Get.put(AssignmentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const CustomAppBar(
        title: AppStrings.myAssignments,
        showBackButton: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CUSTOM TAB BAR (Using your _TabItem) ---
            Container(
              color: AppColors.bgLight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() => Center(
                      child: _TabItem(
                        title: 'All',
                        isActive: controller.selectedTabIndex.value == 0,
                        onTap: () => controller.selectedTabIndex.value = 0,
                      ),
                    )),
                  ),
                  Expanded(
                    child: Obx(() => Center(
                      child: _TabItem(
                        title: 'Active',
                        isActive: controller.selectedTabIndex.value == 1,
                        onTap: () => controller.selectedTabIndex.value = 1,
                      ),
                    )),
                  ),
                  Expanded(
                    child: Obx(() => Center(
                      child: _TabItem(
                        title: 'Completed',
                        isActive: controller.selectedTabIndex.value == 2,
                        onTap: () => controller.selectedTabIndex.value = 2,
                      ),
                    )),
                  ),
                  Expanded(
                    child: Obx(() => Center(
                      child: _TabItem(
                        title: 'Drafts',
                        isActive: controller.selectedTabIndex.value == 3,
                        onTap: () => controller.selectedTabIndex.value = 3,
                      ),
                    )),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: AppColors.buttonPrimary));
                }

                switch (controller.selectedTabIndex.value) {
                  case 0:
                    return _allList();
                  case 1:
                    return _activeList();
                  case 2:
                    return _deliveredList();
                  case 3:
                    return _draftsList();
                  default:
                    return _allList();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _allList() {
    final list = controller.allAssignments;
    if (list.isEmpty) {
      return _emptyState(Icons.all_inbox, "No Assignments", "You don't have any tasks yet.");
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        if (item is Lead) {
          return _buildLeadItem(item, index);
        } else if (item is ConfirmedOrder) {
          return _buildConfirmedOrderItem(item, index);
        }
        return const SizedBox();
      },
    );
  }

  Widget _activeList() {
    final list = controller.activeAssignments;
    if (list.isEmpty) {
      return _emptyState(Icons.assignment_outlined, "No Active Assignments", "You have no ongoing tasks.");
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        if (item is Lead) {
          return _buildLeadItem(item, index);
        } else if (item is ConfirmedOrder) {
          return _buildConfirmedOrderItem(item, index);
        }
        return const SizedBox();
      },
    );
  }

  Widget _deliveredList() {
    final list = controller.completedOrders;
    if (list.isEmpty) {
      return _emptyState(Icons.check_circle_outline, "No Completed Assignments", "Finished projects will appear here.");
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) => _buildConfirmedOrderItem(list[index], index),
    );
  }

  Widget _draftsList() {
    final list = controller.nonConfirmedLeads;
    if (list.isEmpty) {
      return _emptyState(Icons.drafts_outlined, "No Drafts", "You have no saved drafts or unconfirmed items.");
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) => _buildLeadItem(list[index], index),
    );
  }



  Widget _buildLeadItem(Lead lead, int index) {
    bool showProgress = index % 2 == 0;
    String statusText = showProgress ? "Pending" : "Processing";

    OrderStatus currentStatus = statusText == "Pending"
        ? OrderStatus.pending
        : OrderStatus.inProgress;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: _OrderTile(
        orderId: lead.orderId?.toString() ?? "-",
        serviceName: lead.service ?? "-",
        subtitle: lead.subject ?? "-",
        date: lead.deadline ?? "-",
        price: "£${lead.price ?? "-"}",
        status: currentStatus,
        writerName: lead.writer?.writerName,
        onTap: () {
          Get.to(() => const OrderDetailsView(), arguments: lead);
        },
      ),
    );
  }

  Widget _buildConfirmedOrderItem(ConfirmedOrder order, int index) {
    final bool isDelivered = order.deliveryDate != null && order.deliveryDate!.toString().trim().isNotEmpty;

    OrderStatus currentStatus = isDelivered
        ? OrderStatus.completed
        : OrderStatus.inProgress;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: _OrderTile(
        orderId: order.orderId?.toString() ?? "-",
        serviceName: order.title ?? order.subject ?? "-",
        subtitle: order.moduleCode ?? (isDelivered ? "Module Complete" : "Expert Working"),
        date: order.deliveryDate ?? order.createdAt ?? "-",
        price: "£${order.amount ?? "-"}",
        status: currentStatus,
        writerName: order.writer?.writerName,
        onTap: () {
          Get.to(() => const OrderDetailsView(), arguments: order);
        },
      ),
    );
  }



  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum OrderStatus { completed, inProgress, cancelled, pending }


class _OrderTile extends StatelessWidget {
  final String orderId;
  final String serviceName;
  final String subtitle;
  final String date;
  final String price;
  final OrderStatus status;
  final String? writerName; // <--- Added optional parameter
  final VoidCallback onTap;

  const _OrderTile({
    required this.orderId,
    required this.serviceName,
    required this.subtitle,
    required this.date,
    required this.price,
    required this.status,
    this.writerName, // <--- Added to constructor
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;
    Color iconColor;
    Color iconBgColor;
    String statusText;
    IconData leadingIcon;

    switch (status) {
      case OrderStatus.completed:
        statusColor = AppColors.statusGreen;
        statusBgColor = AppColors.statusGreen.withValues(alpha: 0.15);
        iconColor = AppColors.statusGreen;
        iconBgColor = AppColors.statusGreen.withValues(alpha: 0.15);
        statusText = 'Completed';
        leadingIcon = Icons.assignment_turned_in_outlined;
        break;
      case OrderStatus.inProgress:
        statusColor = AppColors.primaryPurple;
        statusBgColor = AppColors.primaryPurple.withValues(alpha: 0.15);
        iconColor = AppColors.primaryPurple;
        iconBgColor = AppColors.primaryPurple.withValues(alpha: 0.15);
        statusText = 'Not Completed';
        leadingIcon = Icons.assignment_outlined;
        break;
      case OrderStatus.cancelled:
      case OrderStatus.pending:
        statusColor = AppColors.error;
        statusBgColor = AppColors.error.withValues(alpha: 0.15);
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
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // --- CONDITIONAL WRITER DISPLAY ---
                      if (writerName != null && writerName!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.person_pin_outlined, size: 14, color: AppColors.primaryPurple),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "Expert: $writerName",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
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
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: TextStyle(
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
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
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.primaryPurple : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class CustomDashedDivider extends StatelessWidget {
  const CustomDashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: LayoutBuilder(
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
      ),
    );
  }
}