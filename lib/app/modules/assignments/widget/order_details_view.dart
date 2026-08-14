import 'dart:io';
import 'package:file_picker/file_picker.dart';
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

    String customerMobile = "N/A";
    String workType = "N/A";
    String wordCount = "N/A";
    String price = "0.00";
    String dueAmount = "0.00";

    Writer? assignedWriter;

    List<String> attachments = [];

    bool isCompletedOrder = false;

    if (orderData is Lead) {
      title = orderData.service ?? AppStrings.assignmentDetails;
      orderId = orderData.orderId?.toString() ?? "#0000";
      deadline = orderData.deadline ?? "N/A";
      status = "Pending";
      statusColor = AppColors.warning;
      progress = orderData.progressPercentage != null ? (orderData.progressPercentage! / 100.0) : 0.0;
      progressText = "${orderData.progressPercentage?.toString()}%" ;
      instructions = orderData.requirements ?? instructions;

      customerMobile = "${orderData.countrycode ?? ''} ${orderData.mobile ?? ''}".trim();
      if (customerMobile.isEmpty) customerMobile = "N/A";
      workType = orderData.workType ?? "N/A";
      wordCount = orderData.wordCount ?? "N/A";
      price = orderData.price ?? "0.00";

      assignedWriter = orderData.writer;

      dueAmount = price;

      attachments.addAll(orderData.files ?? []);
      attachments.addAll(orderData.images ?? []);

    } else if (orderData is ConfirmedOrder) {
      title = orderData.title ?? AppStrings.assignmentDetails;
      orderId = orderData.orderId?.toString() ?? "#0000";
      deadline = orderData.deliveryDate ?? "N/A";
      status = orderData.status ?? "Completed";
      statusColor = status == "In Progress" ? AppColors.secondary : AppColors.success;

      progress = orderData.progress != null ? (orderData.progress! / 100.0) : 0.0;
      progressText = "${orderData.progress?.toString()}%" ;

      workType = orderData.type ?? "N/A";
      price = orderData.amount ?? "0.00";

      assignedWriter = orderData.writer;

      final String s = (orderData.status ?? '').toLowerCase().trim();
      final String cs = (orderData.confirmedStatus ?? '').toLowerCase().trim();
      final String dd = (orderData.deliveryDate ?? '').toLowerCase().trim();

      if (s == 'completed' || s == 'delivered' || s == 'done' || s == 'finish' || s == 'finished' ||
          cs == 'completed' || cs == 'delivered' ||
          (dd.isNotEmpty && dd != 'n/a')) {
        isCompletedOrder = true;
      }

      if (isCompletedOrder) {
        dueAmount = "0.00";
      } else if (orderData.dueAmount != null) {
        if (orderData.dueAmount is num) {
          dueAmount = (orderData.dueAmount as num).toStringAsFixed(2);
        } else {
          dueAmount = orderData.dueAmount.toString();
        }
      }

      attachments.addAll(orderData.files ?? []);
      attachments.addAll(orderData.images ?? []);
    }

    List<PaymentHistory> paymentHistoryList = [];
    int timesPaidCount = 0;
    if (orderData is ConfirmedOrder) {
      timesPaidCount = orderData.timesPaidCount ?? 0;
      paymentHistoryList = orderData.paymentHistory ?? [];
    } else if (orderData is Lead) {
      timesPaidCount = 0;
      paymentHistoryList = orderData.paymentHistory ?? [];
    }

    // Payment is pending IF order is NOT completed AND (dueAmount > 0 OR timesPaidCount == 0)

    double parsedDue = double.tryParse(dueAmount) ?? 0.0;
    bool isPaymentPending = !isCompletedOrder && (parsedDue > 0 || timesPaidCount == 0);

    if (isPaymentPending) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPaymentDetailsSheet(context, dueAmount, orderId);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: 'Order Details',
        showBackButton: true,
        actions: [
          if (!isCompletedOrder) ...[
            IconButton(
              icon: Icon(Icons.edit_outlined, color: AppColors.primaryPurple),
              tooltip: 'Edit Order',
              onPressed: () {
                Get.toNamed(Routes.ADD_ORDER, arguments: orderData);
              },
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration:  BoxDecoration(
          color: AppColors.bgLight,
          boxShadow: [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 10,
              offset: const Offset(0, -4),
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
                    onPressed: () {
                      Get.toNamed(Routes.CHAT);
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: Text("Live Chat", style: AppTextStyles.button.copyWith(color: AppColors.primary, fontSize: AppFontSize.s14)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side:  BorderSide(color: AppColors.primary, width: 1.2),
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
                    onPressed: () {
                      controller.makeCall();
                    },
                    icon: const Icon(Icons.phone, size: 18, color: AppColors.white),
                    label: Text("Call Us", style: AppTextStyles.button.copyWith(fontSize: AppFontSize.s14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopCard(title, orderId, deadline, status, statusColor, progress, progressText),
                const SizedBox(height: 12),

                // --- NEW: FULL EXPERT DETAILS SECTION ---
                if (assignedWriter != null) ...[
                  _buildSectionTitle("Assigned Expert"),
                  _buildExpertCard(assignedWriter),
                  const SizedBox(height: 12),
                ],

                _buildSectionTitle("Order Specifications"),
                _buildPremiumBox([
                  _buildIconDetailRow(Icons.work_outline, AppStrings.workType, workType),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Divider(height: 1, color: AppColors.lightDivider)),
                  _buildIconDetailRow(Icons.format_list_numbered, AppStrings.pages, wordCount),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Divider(height: 1, color: AppColors.lightDivider)),
                  _buildIconDetailRow(Icons.monetization_on_outlined, AppStrings.total, "£$price", valueColor: AppColors.textPrimary, isValueBold: true),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Divider(height: 1, color: AppColors.lightDivider)),
                  _buildIconDetailRow(
                    Icons.history,
                    "Times Paid",
                    timesPaidCount == 0 ? "No Payment (0)" : "$timesPaidCount Time(s)",
                    valueColor: timesPaidCount == 0 ? AppColors.error : AppColors.success,
                    isValueBold: true,
                  ),

                  // --- DUE AMOUNT ROW ---
                  if (isPaymentPending) ...[
                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Divider(height: 1, color: AppColors.lightDivider)),
                    _buildIconDetailRow(
                        Icons.account_balance_wallet_outlined,
                        "Due Amount",
                        "£$dueAmount",
                        valueColor: AppColors.error,
                        isValueBold: true
                    ),
                  ],
                ]),
                const SizedBox(height: 12),

                _buildSectionTitle("Instructions"),
                _buildPremiumBox([
                  Text(instructions, style: AppTextStyles.bodySmall.copyWith(height: 1.4)),
                ]),
                const SizedBox(height: 12),

                // --- DYNAMIC UPLOADED FILES SECTION ---
                _buildSectionTitle("Uploaded Files"),

                if (attachments.isNotEmpty)
                  ...attachments.map((fileUrl) {
                    String fileName = fileUrl.split('/').last;
                    String extension = fileName.split('.').last.toLowerCase();

                    bool isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);

                    if (isImage) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.bgLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.lightDivider, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightShadow,
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              fileUrl,
                              height: 180,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  height: 180,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return _buildFileRow(fileName, "Image failed to load");
                              },
                            ),
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: _buildFileRow(fileName, "Attachment"),
                    );
                  })
                else
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                        "No files or images uploaded.",
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)
                    ),
                  ),

                const SizedBox(height: 12),

                // Pass dueAmount & timesPaidCount to PaymentStatusBox
                _buildPaymentStatusBox(context, isPaymentPending, dueAmount, orderId, timesPaidCount),
                const SizedBox(height: 12),

                // --- PAYMENT HISTORY SECTION ---
                _buildSectionTitle("Payment History"),
                if (paymentHistoryList.isNotEmpty)
                  ...paymentHistoryList.map((ph) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildOrderPaymentHistoryCard(ph),
                  ))
                else
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                      "No payment history records found.",
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                const SizedBox(height: 12),

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
                        onTap: () => _showFeedbackDialog(context, orderId),
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
                        onTap: () => _showRaiseTicketDialog(context, orderId),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
        ],
      ),
    );
  }

  // ==========================================
  // PAYMENT BOTTOM SHEETS
  // ==========================================

  void _showPaymentDetailsSheet(BuildContext context, String amountDue, String orderId) {
    if (controller.banksList.isEmpty) {
      controller.bankList();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 24,
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return  SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primaryPurple),
                ),
              );
            }

            if (controller.banksList.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(child: Text("No bank details found.")),
              );
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50, height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(color: AppColors.lightDivider, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.account_balance_wallet, color: AppColors.warning),
                      ),
                      const SizedBox(width: 12),
                      Text("Payment Pending", style: AppTextStyles.h1.copyWith(fontSize: AppFontSize.s18)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please complete your payment to confirm order $orderId and begin the work process.",
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount Due:", style: AppTextStyles.subtitle.copyWith(fontSize: AppFontSize.s14)),
                        Text("£$amountDue", style: AppTextStyles.h1.copyWith(color: AppColors.warning, fontSize: AppFontSize.s20)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text("Bank Transfer Details", style: AppTextStyles.sectionHeading.copyWith(fontSize: AppFontSize.s14)),
                  const SizedBox(height: 12),

                  BankTransferDetailsWidget(
                    banksList: controller.banksList,
                    tabViewHeight: 240,
                    isBottomSheet: true,
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      title: "I Have Paid",
                      onTap: () {
                        Get.back();
                        _showUploadScreenshotSheet(context, orderId);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text("Pay Later", style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  void _showUploadScreenshotSheet(BuildContext context, String orderId) {
    final Rx<File?> selectedFile = Rx<File?>(null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50, height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: AppColors.lightDivider, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child:  Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Text("Upload Payment Proof", style: AppTextStyles.h1.copyWith(fontSize: AppFontSize.s18)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Please upload a screenshot of your successful transaction for order $orderId.",
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                InkWell(
                  onTap: () async {
                    try {
                      FilePickerResult? result = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                      );


                      if (result != null && result.files.single.path != null) {
                        selectedFile.value = File(result.files.single.path!);
                      }
                    } catch (e) {
                      Get.snackbar("Error", "Could not pick file.", backgroundColor: AppColors.error, colorText: AppColors.white);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 1.5, style: BorderStyle.solid),
                    ),
                    child: Obx(() => Column(
                      children: [
                        Icon(
                            selectedFile.value == null ? Icons.image_outlined : Icons.check_circle_outline,
                            color: AppColors.primary,
                            size: 40
                        ),
                        const SizedBox(height: 12),
                        Text(
                          selectedFile.value == null
                              ? "Tap to browse files"
                              : selectedFile.value!.path.split('/').last,
                          style: AppTextStyles.subtitle.copyWith(
                              color: selectedFile.value == null ? AppColors.primary : AppColors.success,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (selectedFile.value == null) ...[
                          const SizedBox(height: 8),
                          Text("Supports JPG, PNG, PDF", style: AppTextStyles.caption),
                        ]
                      ],
                    )),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    title: "Submit Proof",
                    onTap: () {
                      if (selectedFile.value == null) {
                        Get.snackbar("Error", "Please select a file first.", backgroundColor: AppColors.error, colorText: AppColors.white);
                        return;
                      }

                      controller.submitPaymentProof(
                        orderId: orderId,
                        amount: "0",
                        payeeName: "",
                        reference: "",
                        bankCountry: "",
                        selectedFile: selectedFile.value!,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Cancel", style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // UI BUILDER WIDGETS
  // ==========================================

  Widget _buildExpertCard(Writer writer) {
    // Formulate a proper Image URL for the network image fallback
    String imageUrl = "";
    if (writer.image != null && writer.image!.isNotEmpty) {
      if (writer.image!.startsWith("http")) {
        imageUrl = writer.image!;
      } else {
        // Appending the base URL if it's just a relative path
        imageUrl = "https://ain.warrgyizmorsch.com/${writer.image}";
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.lightShadow, blurRadius: 6, offset: const Offset(0, 2))],
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 54, width: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.priceBg,
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3), width: 1.5),
                ),
                clipBehavior: Clip.hardEdge,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.person, color: AppColors.primaryPurple, size: 28),
                )
                    : Icon(Icons.person, color: AppColors.primaryPurple, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        writer.writerName ?? "Expert Assigned",
                        style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold, fontSize: AppFontSize.s15, color: AppColors.textPrimary)
                    ),
                    const SizedBox(height: 2),
                    Text(
                        "@${writer.slug ?? 'expert'}",
                        style: AppTextStyles.caption.copyWith(color: AppColors.primaryPurple, fontWeight: FontWeight.w600)
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: AppColors.lightDivider),
          const SizedBox(height: 14),

          _buildIconDetailRow(Icons.badge_outlined, "Expert ID", "#${writer.id ?? '-'}"),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: AppColors.lightDivider)),

          _buildIconDetailRow(Icons.menu_book_outlined, "Subject", writer.subject ?? "-"),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: AppColors.lightDivider)),

          _buildIconDetailRow(Icons.design_services_outlined, "Service", writer.service ?? "-"),
        ],
      ),
    );
  }

  Widget _buildFileRow(String fileName, String fileSize) {
    String extension = fileName.split('.').last.toLowerCase();

    bool isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
    bool isPdf = extension == 'pdf';
    bool isWord = ['doc', 'docx'].contains(extension);

    IconData fileIcon;
    Color iconColor;

    if (isImage) {
      fileIcon = Icons.image_outlined;
      iconColor = AppColors.primary;
    } else if (isPdf) {
      fileIcon = Icons.picture_as_pdf;
      iconColor = AppColors.error;
    } else if (isWord) {
      fileIcon = Icons.description_outlined;
      iconColor = Colors.blue;
    } else {
      fileIcon = Icons.insert_drive_file_outlined;
      iconColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: AppColors.bgLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.lightDivider, width: 1)
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6)
            ),
            child: Icon(fileIcon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTextStyles.subtitle.copyWith(fontSize: AppFontSize.s12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(fileSize, style: AppTextStyles.caption.copyWith(fontSize: AppFontSize.s10)),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // Add actual download logic here
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.priceBg,
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Text(
                    "Download",
                    style: AppTextStyles.stepBadge.copyWith(color: AppColors.primary, fontSize: AppFontSize.s10)
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusBox(BuildContext context, bool isPending, String amount, String orderId, int timesPaidCount) {
    bool noPayment = isPending || timesPaidCount == 0;
    Color bgColor = noPayment ? AppColors.error.withValues(alpha:0.05) : AppColors.success.withValues(alpha:0.05);
    Color borderColor = noPayment ? AppColors.error.withValues(alpha:0.2) : AppColors.success.withValues(alpha:0.2);
    Color textColor = noPayment ? AppColors.error : AppColors.success;

    String statusLabel = "PAID";
    if (timesPaidCount == 0) {
      statusLabel = "NO PAYMENT";
    } else if (isPending) {
      statusLabel = "PENDING";
    }

    return Column(
      children: [
        Container(
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
                  Icon(noPayment ? Icons.pending_actions : Icons.verified, color: textColor, size: 18),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment Status", style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold, fontSize: AppFontSize.s13)),
                      Text(
                        timesPaidCount == 0 ? "No payments made yet" : "$timesPaidCount payment(s) completed",
                        style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.white.withValues(alpha:0.8), borderRadius: BorderRadius.circular(6)),
                child: Text(
                  statusLabel,
                  style: AppTextStyles.stepBadge.copyWith(color: textColor, letterSpacing: 0.3, fontSize: AppFontSize.s11),
                ),
              ),
            ],
          ),
        ),
        if (noPayment) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              title: "Complete Payment",
              onTap: () => _showPaymentDetailsSheet(context, amount, orderId), // Using exact passed amount here
            ),
          )
        ]
      ],
    );
  }

  Widget _buildOrderPaymentHistoryCard(PaymentHistory item) {
    String status = item.accountStatus ?? "Pending";
    Color statusColor = AppColors.warning;
    Color statusBgColor = AppColors.warning.withValues(alpha: 0.12);

    final sLower = status.toLowerCase();
    if (sLower.contains('approved') || sLower.contains('complete') || sLower.contains('success')) {
      statusColor = AppColors.success;
      statusBgColor = AppColors.success.withValues(alpha: 0.12);
    } else if (sLower.contains('reject') || sLower.contains('fail') || sLower.contains('cancel')) {
      statusColor = AppColors.error;
      statusBgColor = AppColors.error.withValues(alpha: 0.12);
    }

    String amountStr = "0.00";
    if (item.paidAmount != null) {
      amountStr = item.paidAmount.toString();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightDivider),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightShadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.receipt_long, color: AppColors.primaryPurple, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.paymentId != null ? "Payment #${item.paymentId}" : "Payment Record",
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSize.s13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "£$amountStr",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPurple,
                ),
              ),
              if (item.paymentMethod != null && item.paymentMethod!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.tagBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.paymentMethod!,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          if ((item.paymentDate != null && item.paymentDate!.isNotEmpty) ||
              (item.payeeName != null && item.payeeName!.isNotEmpty)) ...[
            const SizedBox(height: 8),
            Divider(height: 1, color: AppColors.lightDivider),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (item.paymentDate != null && item.paymentDate!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        item.paymentDate!,
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                if (item.payeeName != null && item.payeeName!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        item.payeeName!,
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color iconColor, required VoidCallback onTap}) {
    return Material(
      color: AppColors.bgLight,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightDivider, width: 1),
            boxShadow:  [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: const Offset(0, 1))],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconColor.withValues(alpha:0.1), shape: BoxShape.circle),
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
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow:  [BoxShadow(color: AppColors.lightShadow, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Positioned(
                  top: -30, left: -20,
                  child: Container(height: 90, width: 90, decoration:  BoxDecoration(color: AppColors.priceBg, shape: BoxShape.circle)),
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
                              decoration: BoxDecoration(color: statusColor.withValues(alpha:0.1), borderRadius: BorderRadius.circular(6)),
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
                            SizedBox(height: 54, width: 54, child: CircularProgressIndicator(value: progress, strokeWidth: 5, backgroundColor: AppColors.lightDivider, color: AppColors.primary, strokeCap: StrokeCap.round)),
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
          Divider(height: 1, color: AppColors.lightDivider),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration:  BoxDecoration(color: AppColors.background, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12))),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: AppColors.textSecondary),
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
      padding: const EdgeInsets.only(bottom: 6, left: 2, top: 4),
      child: Text(title, style: AppTextStyles.sectionHeading.copyWith(fontSize: AppFontSize.s14)),
    );
  }

  Widget _buildPremiumBox(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(10), boxShadow:  [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: const Offset(0, 1))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildIconDetailRow(IconData icon, String label, String value, {Color? valueColor, bool isValueBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.priceBg, borderRadius: BorderRadius.circular(6)), child: Icon(icon, size: 14, color: AppColors.primary)),
        const SizedBox(width: 10),
        Expanded(flex: 2, child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: isValueBold ? AppTextStyles.subtitle.copyWith(color: valueColor ?? AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: AppFontSize.s13) : AppTextStyles.subtitle.copyWith(color: valueColor ?? AppColors.textPrimary, fontSize: AppFontSize.s13),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // HELP & FEEDBACK DIALOGS
  // ==========================================

  void _showFeedbackDialog(BuildContext context, String orderId) {
    int rating = 0;
    List<String> selectedScopes = [];
    final TextEditingController suggestionController = TextEditingController();
    final List<String> scopeOptions = ['Customer service', 'Work quality', 'Deadline', 'Pricing', 'Originality', 'Revisions'];

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
              backgroundColor: AppColors.bgLight,
              surfaceTintColor: AppColors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Rate your experience', textAlign: TextAlign.center, style: AppTextStyles.h1.copyWith(fontSize: AppFontSize.s16)),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text("How satisfied are you with this assignment?", textAlign: TextAlign.center, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          int starValue = index + 1;
                          bool isFilled = starValue <= rating;
                          return GestureDetector(
                            onTap: () => setState(() => rating = starValue),
                            child: AnimatedScale(scale: rating == starValue ? 1.15 : 1.0, duration: const Duration(milliseconds: 150), child: Icon(isFilled ? Icons.star_rounded : Icons.star_border_rounded, color: isFilled ? const Color(0xFFFFB800) : AppColors.lightDivider, size: 40)),
                          );
                        }),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: AnimatedOpacity(
                          opacity: rating > 0 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(getExperienceText(rating), style: AppTextStyles.subtitle.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: AppFontSize.s15)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text("What could make it even better?", style: AppTextStyles.subtitle.copyWith(fontSize: AppFontSize.s13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: scopeOptions.map((option) {
                          final isSelected = selectedScopes.contains(option);
                          return InkWell(
                            onTap: () => setState(() { isSelected ? selectedScopes.remove(option) : selectedScopes.add(option); }),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: isSelected ? AppColors.priceBg : AppColors.bgLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: isSelected ? AppColors.primary : AppColors.lightDivider)),
                              child: Text(option, style: AppTextStyles.bodySmall.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text("Your Suggestion", style: AppTextStyles.subtitle.copyWith(fontSize: AppFontSize.s13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: suggestionController,
                        maxLines: 3,
                        style: AppTextStyles.inputText.copyWith(fontSize: AppFontSize.s13),
                        decoration: InputDecoration(
                          hintText: 'Tell us how we can improve...',
                          hintStyle: AppTextStyles.hintText.copyWith(fontSize: AppFontSize.s13),
                          filled: true, fillColor: AppColors.background,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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
                    Expanded(child: TextButton(onPressed: () => Get.back(), style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(AppStrings.cancel, style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary, fontSize: AppFontSize.s13)))),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: Obx(() => AppButton(
                          title: controller.isLoadingFeedback.value ? "Submitting..." : AppStrings.submit,
                          onTap: () {
                            if (controller.isLoadingFeedback.value) return;
                            if (rating == 0) {
                              Get.snackbar('Rating Required', 'Please provide a star rating before submitting.', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.error, colorText: AppColors.white, margin: const EdgeInsets.all(12));
                              return;
                            }
                            final request = FeedbackRequest(orderId: orderId, experience: getExperienceText(rating), feedbackScope: selectedScopes.join(", "), yourSuggestion: suggestionController.text.trim());
                            controller.submitFeedback(request: request, context: context);
                          },
                        )),
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
          backgroundColor: AppColors.bgLight,
          surfaceTintColor: AppColors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Raise a Ticket', style: AppTextStyles.h1.copyWith(fontSize: AppFontSize.s16)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
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
                      filled: true, fillColor: AppColors.appBackground,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          actions: [
            Row(
              children: [
                Expanded(child: TextButton(onPressed: () => Get.back(), style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(AppStrings.cancel, style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary, fontSize: AppFontSize.s13)))),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => AppButton(
                    title: controller.isLoadingTicket.value ? "Submitting..." : AppStrings.submit,
                    onTap: () {
                      if (controller.isLoadingTicket.value) return;
                      if (ticketController.text.trim().isEmpty) {
                        Get.snackbar('Validation', 'Please enter your issue before submitting.');
                        return;
                      }
                      controller.raiseTicket(orderId: orderId, comment: ticketController.text.trim(), context: context);
                    },
                  )),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
