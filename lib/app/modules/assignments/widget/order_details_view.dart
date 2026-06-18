
import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/feedback_request_model.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../controllers/assignments_controller.dart';

class OrderDetailsView extends GetView<AssignmentsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // --- DATA EXTRACTION ---
    final dynamic orderData = Get.arguments;

    String title = AppStrings.assignmentDetails;
    String orderId = "#0000";
    String deadline = "N/A";
    String status = "Unknown";
    Color statusColor = AppColors.textSecondary;
    double progress = 0.0;
    String progressText = "0%";
    String instructions = "No specific instructions provided.";

    String customerName = "N/A";
    String customerEmail = "N/A";
    String customerMobile = "N/A";
    String workType = "N/A";
    String wordCount = "N/A";
    String price = "0.00";

    if (orderData is Lead) {
      title = orderData.service ?? AppStrings.assignmentDetails;
      orderId = orderData.orderId?.toString() ?? "#0000";
      deadline = orderData.deadline ?? "N/A";
      status = "Pending";
      statusColor = AppColors.warning;
      progress = 0.3;
      progressText = "30%";
      instructions = orderData.requirements ?? instructions;

      customerName = orderData.name ?? "N/A";
      customerEmail = orderData.email ?? "N/A";
      customerMobile = "${orderData.countrycode ?? ''} ${orderData.mobile ?? ''}".trim();
      if (customerMobile.isEmpty) customerMobile = "N/A";
      workType = orderData.workType ?? "N/A";
      wordCount = orderData.wordCount ?? "N/A";
      price = orderData.price ?? "0.00";

    } else if (orderData is ConfirmedOrder) {
      title = orderData.service ?? AppStrings.assignmentDetails;
      orderId = orderData.orderId?.toString() ?? "#0000";
      deadline = orderData.deadline ?? "N/A";
      status = orderData.status ?? "Completed";
      statusColor = status == "In Progress" ? AppColors.secondary : AppColors.success;
      progress = 1.0;
      progressText = "100%";

      customerName = orderData.name ?? "N/A";
      workType = orderData.workType ?? "N/A";
      price = orderData.price ?? "0.00";
    }

    bool isPaymentPending = (status == "Pending");

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Order Details',
        showBackButton: true,
      ),
      // 1. STICKY BOTTOM BAR: Now holds urgent communication actions
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: Text("Live Chat", style: AppTextStyles.button.copyWith(color: AppColors.primary, fontSize: AppFontSize.s14)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone, size: 18, color: AppColors.white),
                    label: Text("Call Us", style: AppTextStyles.button.copyWith(fontSize: AppFontSize.s14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0), // Compact body padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Details Card
            _buildTopCard(title, orderId, deadline, status, statusColor, progress, progressText),
            const SizedBox(height: 12), // Reduced spacing between sections

            // Customer Information
            _buildSectionTitle("Customer Details"),
            _buildPremiumBox([
              _buildIconDetailRow(Icons.person_outline, "Name", customerName),
              const Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Divider(height: 1, color: AppColors.lightDivider)),
              _buildIconDetailRow(Icons.email_outlined, "Email", customerEmail),
              const Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Divider(height: 1, color: AppColors.lightDivider)),
              _buildIconDetailRow(Icons.phone_outlined, "Mobile", customerMobile),
            ]),
            const SizedBox(height: 12),

            // Order Specifications
            _buildSectionTitle("Order Specifications"),
            _buildPremiumBox([
              _buildIconDetailRow(Icons.work_outline, AppStrings.workType, workType),
              const Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Divider(height: 1, color: AppColors.lightDivider)),
              _buildIconDetailRow(Icons.format_list_numbered, AppStrings.pages, wordCount),
              const Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Divider(height: 1, color: AppColors.lightDivider)),
              _buildIconDetailRow(Icons.monetization_on_outlined, AppStrings.total, "\$$price",
                  valueColor: AppColors.primary, isValueBold: true),
            ]),
            const SizedBox(height: 12),

            // Instructions
            _buildSectionTitle("Instructions"),
            _buildPremiumBox([
              Text(
                instructions,
                style: AppTextStyles.bodySmall.copyWith(height: 1.4), // Tighter text
              ),
            ]),
            const SizedBox(height: 12),

            // Uploaded Files
            _buildSectionTitle("Uploaded Files"),
            _buildFileRow("Assignment_Brief.pdf", "1.2 MB"),
            const SizedBox(height: 6),
            _buildFileRow("Reference_Notes.docx", "845 KB"),
            const SizedBox(height: 12),

            // Payment Status
            _buildPaymentStatusBox(isPaymentPending),
            const SizedBox(height: 12),

            // 2. HELP & FEEDBACK SECTION: Moved here logically
            _buildSectionTitle("Help & Feedback"),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    icon: Icons.star_border_rounded,
                    title: "Rate Order",
                    subtitle: "Give Feedback",
                    iconColor: AppColors.warning,
                    onTap: () => _showFeedbackDialog(context,orderId),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionCard(
                    context,
                    icon: Icons.support_agent_rounded,
                    title: "Issue?",
                    subtitle: "Raise Ticket",
                    iconColor: AppColors.error,
                    onTap: () => _showRaiseTicketDialog(context,orderId),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Bottom padding for scroll clearance
          ],
        ),
      ),
    );
  }

  // --- UI Builder Widgets ---

  // New Action Card for Feedback & Tickets
  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color iconColor, required VoidCallback onTap}) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightDivider, width: 1),
            boxShadow: const [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 1))],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: 8),
              Text(title, style: AppTextStyles.subtitle.copyWith(fontSize: AppFontSize.s13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: AppFontSize.s10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopCard(String title, String orderId, String deadline, String status, Color statusColor, double progress, String progressText) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.lightShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Positioned(
                  top: -30, left: -20,
                  child: Container(
                    height: 90, width: 90,
                    decoration: const BoxDecoration(color: AppColors.priceBg, shape: BoxShape.circle),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: AppFontSize.s16)),
                            const SizedBox(height: 6),
                            _buildMiniDetail("Order ID", orderId),
                            const SizedBox(height: 2),
                            _buildMiniDetail(AppStrings.deadline, deadline),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text(status, style: AppTextStyles.stepBadge.copyWith(color: statusColor, fontSize: AppFontSize.s10)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 54, width: 54,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 54, width: 54,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 5,
                                backgroundColor: AppColors.lightDivider,
                                color: AppColors.primary,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Text(progressText, style: AppTextStyles.h1.copyWith(fontSize: AppFontSize.s12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.lightDivider),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text("Estimated completion: Tomorrow", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: AppFontSize.s11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDetail(String label, String value) {
    return RichText(
      text: TextSpan(
        text: "$label: ", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: AppFontSize.s12),
        children: [TextSpan(text: value, style: AppTextStyles.subtitle.copyWith(fontSize: AppFontSize.s12))],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(title, style: AppTextStyles.sectionHeading.copyWith(fontSize: AppFontSize.s14)),
    );
  }

  Widget _buildPremiumBox(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildIconDetailRow(IconData icon, String label, String value, {Color? valueColor, bool isValueBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppColors.priceBg, borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, size: 14, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: isValueBold
                ? AppTextStyles.subtitle.copyWith(color: valueColor ?? AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: AppFontSize.s13)
                : AppTextStyles.subtitle.copyWith(color: valueColor ?? AppColors.textPrimary, fontSize: AppFontSize.s13),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildFileRow(String fileName, String fileSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightDivider, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName, style: AppTextStyles.subtitle.copyWith(fontSize: AppFontSize.s12)),
                const SizedBox(height: 2),
                Text(fileSize, style: AppTextStyles.caption.copyWith(fontSize: AppFontSize.s10)),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.priceBg, borderRadius: BorderRadius.circular(6)),
              child: Text("Download", style: AppTextStyles.stepBadge.copyWith(color: AppColors.primary, fontSize: AppFontSize.s10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusBox(bool isPending) {
    Color bgColor = isPending ? AppColors.error.withOpacity(0.05) : AppColors.success.withOpacity(0.05);
    Color borderColor = isPending ? AppColors.error.withOpacity(0.2) : AppColors.success.withOpacity(0.2);
    Color textColor = isPending ? AppColors.error : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(isPending ? Icons.pending_actions : Icons.verified, color: textColor, size: 18),
              const SizedBox(width: 8),
              Text("Payment Status", style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold, fontSize: AppFontSize.s13)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(6)),
            child: Text(
              isPending ? "PENDING" : "PAID",
              style: AppTextStyles.stepBadge.copyWith(color: textColor, letterSpacing: 0.3, fontSize: AppFontSize.s11),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context, String orderId) {
    // --- Local State for the Dialog ---
    int rating = 0;
    List<String> selectedScopes = [];
    final TextEditingController suggestionController = TextEditingController();

    // Options for the feedback scope
    final List<String> scopeOptions = [
      'Customer service',
      'Work quality',
      'Deadline',
      'Pricing',
      'Originality',
      'Revisions'
    ];

    // Helper to map star rating to experience string
    String getExperienceText(int r) {
      switch (r) {
        case 1: return "Worst";
        case 2: return "Poor";
        case 3: return "Average";
        case 4: return "Good";
        case 5: return "Excellent";
        default: return "";
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Rate your experience',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(fontSize: AppFontSize.s16),
              ),
              content: SizedBox(
                width: double.maxFinite, // Ensures dialog expands to fit content
                child: SingleChildScrollView( // Prevents keyboard overflow
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ==========================================
                      // 1. PREMIUM STAR RATING
                      // ==========================================
                      Center(
                        child: Text(
                          "How satisfied are you with this assignment?",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          5,
                              (index) {
                            int starValue = index + 1;
                            bool isFilled = starValue <= rating;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  rating = starValue;
                                });
                              },
                              child: AnimatedScale(
                                scale: rating == starValue ? 1.15 : 1.0,
                                duration: const Duration(milliseconds: 150),
                                child: Icon(
                                  isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: isFilled ? const Color(0xFFFFB800) : AppColors.lightDivider,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Dynamic Experience Label
                      Center(
                        child: AnimatedOpacity(
                          opacity: rating > 0 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            getExperienceText(rating),
                            style: AppTextStyles.subtitle.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: AppFontSize.s15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ==========================================
                      // 2. FEEDBACK SCOPE (CHIPS)
                      // ==========================================
                      Text(
                        "What could make it even better?",
                        style: AppTextStyles.subtitle.copyWith(fontSize: AppFontSize.s13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: scopeOptions.map((option) {
                          final isSelected = selectedScopes.contains(option);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedScopes.remove(option);
                                } else {
                                  selectedScopes.add(option);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.priceBg : AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.lightDivider,
                                ),
                              ),
                              child: Text(
                                option,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // ==========================================
                      // 3. YOUR SUGGESTION (TEXT FIELD)
                      // ==========================================
                      Text(
                        "Your Suggestion",
                        style: AppTextStyles.subtitle.copyWith(fontSize: AppFontSize.s13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: suggestionController,
                        maxLines: 3,
                        style: AppTextStyles.inputText.copyWith(fontSize: AppFontSize.s13),
                        decoration: InputDecoration(
                          hintText: 'Tell us how we can improve...',
                          hintStyle: AppTextStyles.hintText.copyWith(fontSize: AppFontSize.s13),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          AppStrings.cancel,
                          style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary, fontSize: AppFontSize.s13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child:Obx(
                              () => AppButton(
                            title: controller.isLoadingFeedback.value
                                ? "Submitting..."
                                : AppStrings.submit,
                            onTap: () {
                              if (controller.isLoadingFeedback.value) return;

                              if (rating == 0) {
                                Get.snackbar(
                                  'Rating Required',
                                  'Please provide a star rating before submitting.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.error,
                                  colorText: AppColors.white,
                                  margin: const EdgeInsets.all(12),
                                );
                                return;
                              }

                              final request = FeedbackRequest(
                                orderId: orderId,
                                experience: getExperienceText(rating),
                                feedbackScope: selectedScopes.join(", "),
                                yourSuggestion: suggestionController.text.trim(),
                              );

                              controller.submitFeedback(
                                request: request,
                                context: context,
                              );
                            },
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRaiseTicketDialog(BuildContext context, String orderId) {
    final TextEditingController ticketController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Raise a Ticket', style: AppTextStyles.h1.copyWith(fontSize: AppFontSize.s16)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Please describe your issue in detail. Our team will get back to you shortly.", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                TextField(
                  controller: ticketController,
                  maxLines: 4,
                  style: AppTextStyles.inputText.copyWith(fontSize: AppFontSize.s13),
                  decoration: InputDecoration(
                    hintText: 'Type your issue here...',
                    hintStyle: AppTextStyles.hintText.copyWith(fontSize: AppFontSize.s13),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: Text(AppStrings.cancel, style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary, fontSize: AppFontSize.s13)),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                      () => AppButton(
                    title: controller.isLoadingTicket.value
                        ? "Submitting..."
                        : AppStrings.submit,
                    onTap: () {
                      if (controller.isLoadingTicket.value) return;

                      if (ticketController.text.trim().isEmpty) {
                        Get.snackbar(
                          'Validation',
                          'Please enter your issue before submitting.',
                        );
                        return;
                      }

                      controller.raiseTicket(
                        orderId: orderId,
                        comment: ticketController.text.trim(),
                        context: context,
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}