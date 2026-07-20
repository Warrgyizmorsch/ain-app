
import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../controllers/assignments_controller.dart';
import '../widget/order_details_view.dart';

class AssignmentsView extends GetView<AssignmentsController> {
  const AssignmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Local observable to track the active tab index
    final RxInt selectedTabIndex = 0.obs;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const CustomAppBar(
        title: 'My Assignments',
        showBackButton: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CUSTOM TAB BAR (Using your _TabItem) ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Expanded(
                    child: Center(
                      child: _TabItem(
                        title: 'All',
                        isActive: selectedTabIndex.value == 0,
                        onTap: () => selectedTabIndex.value = 0,
                      ),
                    ),
                  )),
                  Obx(() => Expanded(
                    child: Center(
                      child: _TabItem(
                        title: 'Active',
                        isActive: selectedTabIndex.value == 1,
                        onTap: () => selectedTabIndex.value = 1,
                      ),
                    ),
                  )),
                  Obx(() => Expanded(
                    child: Center(
                      child: _TabItem(
                        title: 'Completed',
                        isActive: selectedTabIndex.value == 2,
                        onTap: () => selectedTabIndex.value = 2,
                      ),
                    ),
                  )),
                  Obx(() => Expanded(
                    child: Center(
                      child: _TabItem(
                        title: 'Drafts',
                        isActive: selectedTabIndex.value == 3,
                        onTap: () => selectedTabIndex.value = 3,
                      ),
                    ),
                  )),
                ],
              ),
            ),

            // --- TAB CONTENT VIEW ---
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return  Center(child: CircularProgressIndicator(color: AppColors.buttonPrimary));
                }

                // Switching lists based on the selected tab index
                switch (selectedTabIndex.value) {
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

  // --- 1. All Data List ---
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

  // --- 2. Active List (Unconfirmed + In-Progress Confirmed) ---
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

  // --- 3. Delivered / Confirmed List (Completed Only) ---
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

  // --- 4. Drafts (Unconfirmed) List ---
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

  // ==========================================
  // WIDGET HELPERS FOR REUSABILITY
  // ==========================================

  Widget _buildLeadItem(Lead lead, int index) {
    bool showProgress = index % 2 == 0;
    String statusText = showProgress ? "Pending" : "Processing";

    // Convert status string to enum
    OrderStatus currentStatus = statusText == "Pending"
        ? OrderStatus.pending
        : OrderStatus.inProgress;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: _OrderTile(
        orderId: lead.orderId?.toString() ?? "0000",
        serviceName: lead.service ?? "Assignment",
        subtitle: lead.subject ?? "General subject",
        date: lead.deadline ?? "-",
        price: "£${lead.price ?? "0.00"}",
        status: currentStatus,
        onTap: () {
          Get.to(() => const OrderDetailsView(), arguments: lead);
        },
      ),
    );
  }

  Widget _buildConfirmedOrderItem(ConfirmedOrder order, int index) {
    final bool isDelivered = order.deliveryDate != null && order.deliveryDate!.toString().trim().isNotEmpty;

    // Determine the status enum
    OrderStatus currentStatus = isDelivered
        ? OrderStatus.completed
        : OrderStatus.inProgress;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: _OrderTile(
        orderId: order.orderId?.toString() ?? "0000",
        serviceName: order.title ?? order.subject ?? "Assignment",
        subtitle: order.moduleCode ?? (isDelivered ? "Module Complete" : "Expert Working"),
        date: order.deliveryDate ?? order.createdAt ?? "-",
        price: "£${order.amount ?? "0.00"}",
        status: currentStatus,
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
            Icon(icon, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// CUSTOM COMPONENTS
// ==========================================

enum OrderStatus { completed, inProgress, cancelled, pending }

// 1. The Order Tile Component
class _OrderTile extends StatelessWidget {
  final String orderId;
  final String serviceName;
  final String subtitle;
  final String date;
  final String price;
  final OrderStatus status;
  final VoidCallback onTap;

  const _OrderTile({
    required this.orderId,
    required this.serviceName,
    required this.subtitle,
    required this.date,
    required this.price,
    required this.status,
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
        statusColor = const Color(0xFF388E3C);
        statusBgColor = const Color(0xFFE8F5E9);
        iconColor = const Color(0xFF388E3C);
        iconBgColor = const Color(0xFFE8F5E9);
        statusText = 'Completed';
        leadingIcon = Icons.assignment_turned_in_outlined;
        break;
      case OrderStatus.inProgress:
        statusColor = const Color(0xFF5E35B1);
        statusBgColor = const Color(0xFFEDE7F6);
        iconColor = const Color(0xFF5E35B1);
        iconBgColor = const Color(0xFFEDE7F6);
        statusText = 'Processing';
        leadingIcon = Icons.assignment_outlined;
        break;
      case OrderStatus.cancelled:
      case OrderStatus.pending:
        statusColor = const Color(0xFFD32F2F);
        statusBgColor = const Color(0xFFFFEBEE);
        iconColor = const Color(0xFFD32F2F);
        iconBgColor = const Color(0xFFFFEBEE);
        statusText = status == OrderStatus.pending ? 'Pending' : 'Cancelled';
        leadingIcon = Icons.assignment_late_outlined;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
                        'Order #$orderId',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
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
                    color: const Color(0xFFF3E5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.description_outlined, color: Color(0xFF5E35B1), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF311B92),
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF5E35B1), width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: Color(0xFF5E35B1),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: Color(0xFF5E35B1), size: 16),
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

// 2. The User Provided Custom Tab Item
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
      behavior: HitTestBehavior.opaque, // Ensures the entire expanded area is clickable
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF5E35B1) : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13, // Slightly adjusted for better readability
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? const Color(0xFF5E35B1) : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}

// 3. Custom Dashed Divider
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
              return const SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}