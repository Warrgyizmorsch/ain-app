import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Note: Adjust these imports based on your actual project structure
import 'package:ain/app/common/constant/app_imports.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../../assignments/controllers/assignments_controller.dart';
import '../../assignments/widget/order_details_view.dart';

class MyOrdersWidget extends StatelessWidget {
  MyOrdersWidget({super.key});

  final AssignmentsController controller = Get.put(AssignmentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey background matching UI
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
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
                  // --- Filter & Sort Row ---
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     // Filter Button
                  //     OutlinedButton.icon(
                  //       onPressed: () {
                  //         // TODO: Implement filter sheet or logic
                  //       },
                  //       icon: const Icon(Icons.filter_alt_outlined, size: 18, color: Colors.black87),
                  //       label: const Text(
                  //         'Filter',
                  //         style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
                  //       ),
                  //       style: OutlinedButton.styleFrom(
                  //         backgroundColor: Colors.white,
                  //         side: BorderSide(color: Colors.grey.shade300),
                  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  //       ),
                  //     ),
                  //
                  //     // Sort Dropdown
                  //     Container(
                  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.grey.shade300),
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Colors.white,
                  //       ),
                  //       child: Row(
                  //         children: [
                  //           const Text(
                  //             'Most Recent',
                  //             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                  //           ),
                  //           const SizedBox(width: 6),
                  //           Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade600),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),

                  // --- Orders List ---
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(color: Color(0xFF5E35B1)),
                        ),
                      );
                    }

                    final assignments = controller.filteredAssignments;
                    if (assignments.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'No recent orders found.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
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

    // Item mapping logic
    if (item is ConfirmedOrder) {
      orderId = item.orderId ?? 'Unknown';
      serviceName = item.title ?? item.subject ?? 'No Title';
      price = item.amount ?? '0.00';

      final isDelivered = item.deliveryDate != null && item.deliveryDate!.trim().isNotEmpty;
      status = isDelivered ? OrderStatus.completed : OrderStatus.inProgress;
      date = isDelivered ? (item.deliveryDate ?? '') : (item.orderDate ?? '');
    } else if (item is Lead) {
      orderId = item.orderId ?? 'Unknown';
      serviceName = item.service ?? item.subject ?? 'No Service';
      date = item.createdAt ?? '';
      price = item.price ?? '0.00';
      status = OrderStatus.pending;
    }

    // Default formatting if date is empty, adapt to your API's format
    final displayDate = date.isNotEmpty ? date : "May 12, 2025 • 10:30 AM";

    return _OrderTile(
      orderId: orderId.startsWith('#') ? orderId : '#$orderId',
      serviceName: serviceName,
      date: displayDate,
      price: price.startsWith('₹') ? price : '₹$price',
      status: status,
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
              color: isActive ? const Color(0xFF5E35B1) : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? const Color(0xFF5E35B1) : Colors.grey.shade500,
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
  final VoidCallback onTap;

  const _OrderTile({
    required this.orderId,
    required this.serviceName,
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
        statusColor = const Color(0xFF388E3C); // Green text
        statusBgColor = const Color(0xFFE8F5E9); // Light green bg
        iconColor = const Color(0xFF388E3C);
        iconBgColor = const Color(0xFFE8F5E9);
        statusText = 'Completed';
        leadingIcon = Icons.assignment_turned_in_outlined;
        break;
      case OrderStatus.inProgress:
        statusColor = const Color(0xFF5E35B1); // Purple text
        statusBgColor = const Color(0xFFEDE7F6); // Light purple bg
        iconColor = const Color(0xFF5E35B1);
        iconBgColor = const Color(0xFFEDE7F6);
        statusText = 'Processing';
        leadingIcon = Icons.assignment_outlined;
        break;
      case OrderStatus.cancelled:
      case OrderStatus.pending: // Grouping pending with cancelled style based on UI
        statusColor = const Color(0xFFD32F2F); // Red text
        statusBgColor = const Color(0xFFFFEBEE); // Light red bg
        iconColor = const Color(0xFFD32F2F);
        iconBgColor = const Color(0xFFFFEBEE);
        statusText = 'Cancelled';
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
                        'Order $orderId',
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
                    color: const Color(0xFFF3E5F5), // Light purple bg for service icon
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
                        '1 Year Subscription', // This matches the subtitle in the design
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
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
                        color: Color(0xFF311B92), // Dark deep purple
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

class _SupportBanner extends StatelessWidget {
  const _SupportBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5), // Light purple background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.headset_mic_outlined, color: Color(0xFF5E35B1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need help with your order?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our support team is here to help you.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
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
              backgroundColor: const Color(0xFF311B92), // Dark deep purple button
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: const Text(
              'Contact Support',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
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
                decoration: BoxDecoration(color: Colors.grey.shade300),
              ),
            );
          }),
        );
      },
    );
  }
}