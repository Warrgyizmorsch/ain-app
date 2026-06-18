import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/app_imports.dart';
import '../controllers/assignments_controller.dart';
import '../widget/order_details_view.dart';

class AssignmentsView extends GetView<AssignmentsController> {
  const AssignmentsView({super.key});

  // Theme Colors from the image
  static const Color themeBlue = Color(0xFF0088CC);
  static const Color blobLightBlue = Color(0xFFE1F5FE);
  static const Color buttonPurple = Color(0xFF7E57C2);
  static const Color progressTrack = Color(0xFFE0E0E0);
  static const Color progressFill = Color(0xFF283593);

  // Status Colors
  static const Color statusPending = Color(0xFFE53935);
  static const Color statusInProgress = Color(0xFF673AB7);
  static const Color statusCompleted = Color(0xFF43A047);

  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textGrey = Color(0xFF757575);
  static const Color bgLight = Color(0xFFF8F9FC);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgLight, // Switched to the light background for better card contrast
        appBar: const CustomAppBar(
          title: 'My Order',
          showBackButton: false,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: themeBlue,
                indicatorWeight: 3,
                labelColor: themeBlue,
                unselectedLabelColor: Color(0xFFAAAAAA),
                labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                dividerColor: Color(0xFFE0E0E0),
                tabs: [
                  Tab(text: "Un-Confirmed"),
                  Tab(text: "Confirmed"),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: themeBlue));
                }
                return TabBarView(
                  children: [
                    _currentList(),
                    _deliveredList(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- Current / Pending List ---
  Widget _currentList() {
    if (controller.nonConfirmedLeads.isEmpty) {
      return _emptyState(Icons.assignment_outlined, "No Current Orders", "You have no tasks in progress.");
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.nonConfirmedLeads.length,
      itemBuilder: (context, index) {
        final lead = controller.nonConfirmedLeads[index];

        return _buildOrderCard(
          title: lead.service ?? "Assignment",
          orderId: lead.orderId ?? "#0000",
          deadline: lead.deadline ?? "-",
          status: "Pending",
          statusColor: statusPending,
          showProgress: false,
          onViewOrder: () {
            Get.to(() => const OrderDetailsView(), arguments: lead);
          },
        );
      },
    );
  }

  // --- Delivered / Confirmed List ---
  Widget _deliveredList() {
    if (controller.confirmedOrders.isEmpty) {
      return _emptyState(Icons.check_circle_outline, "No Delivered Orders", "Completed projects will appear here.");
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.confirmedOrders.length,
      itemBuilder: (context, index) {
        final order = controller.confirmedOrders[index];

        return _buildOrderCard(
          title: order.service ?? "Assignment",
          orderId: order.orderId.toString() ?? "#0000",
          deadline: order.deadline ?? "-",
          status: "Completed",
          statusColor: statusCompleted,
          progress: 1.0,
          progressText: "100%",
          showProgress: true,
          onViewOrder: () {
            Get.to(() => const OrderDetailsView(), arguments: order);
          },
        );
      },
    );
  }

  // --- Professionally Upgraded Card UI ---
// --- Professionally Upgraded Card UI ---
  Widget _buildOrderCard({
    required String title,
    required String orderId,
    required String deadline,
    required String status,
    required Color statusColor,
    double? progress,
    String? progressText,
    bool showProgress = true,
    required VoidCallback onViewOrder,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // Ensures the blob stays inside the rounded corners
      child: Stack(
        children: [
          // Decorative Blob
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: blobLightBlue.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: themeBlue, letterSpacing: -0.3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Order ID with Icon
                      Row(
                        children: [
                          const Icon(Icons.tag, size: 14, color: textGrey),
                          const SizedBox(width: 4),
                          const Text("Order ID: ", style: TextStyle(fontSize: 13, color: textGrey, fontWeight: FontWeight.w500)),
                          Text(orderId, style: const TextStyle(fontSize: 13, color: textDark, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Deadline with Icon
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: textGrey),
                          const SizedBox(width: 4),
                          const Text("Deadline: ", style: TextStyle(fontSize: 13, color: textGrey, fontWeight: FontWeight.w500)),
                          Text(deadline, style: const TextStyle(fontSize: 13, color: textDark, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Upgraded View Order Button
                      SizedBox(
                        height: 36, // Slightly taller for easier tapping
                        child: ElevatedButton.icon(
                          onPressed: onViewOrder,
                          icon: const Icon(Icons.visibility_outlined, size: 16, color: Colors.white),
                          label: const Text(
                            "View Order",
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonPurple,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16), // Spacing between left content and right graphic

                // 👇 Right Side: Progress Bar OR Image/Graphic Placeholder 👇
                if (showProgress && progress != null && progressText != null)
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 7,
                            backgroundColor: progressTrack,
                            color: progressFill,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(progressText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textDark)),
                            const Text("Done", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textGrey)),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                // 👇 Beautiful replacement for the missing progress bar 👇
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hourglass_empty_rounded, size: 28, color: statusColor),
                        const SizedBox(height: 6),
                        Text(
                          "Awaiting\nAction",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor, height: 1.2),
                        ),
                      ],
                    ),
                    // If you want to use a local image instead of the icon above,
                    // replace the 'Column' above with this line:
                    // child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset('assets/images/your_placeholder.png', fit: BoxFit.cover)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // --- Empty State ---
  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Icon(icon, size: 50, color: themeBlue.withOpacity(0.5)),
            ),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: textDark)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: textGrey, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}