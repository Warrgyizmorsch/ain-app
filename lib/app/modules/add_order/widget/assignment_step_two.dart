import '../../../common/constant/app_imports.dart';
import '../controllers/add_order_controller.dart';

class RequirementsAndPaymentStep extends GetView<AddOrderController> {
  const RequirementsAndPaymentStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Final ',
                            style: AppTextStyles.sectionHeading.copyWith(
                              fontSize: 24,
                              foreground: Paint()
                                ..shader =  LinearGradient(
                                  colors: [AppColors.secondary, AppColors.primary],
                                ).createShader(const Rect.fromLTWH(0, 0, 200, 20)),
                            ),
                          ),
                          TextSpan(
                            text: 'Steps',
                            style: AppTextStyles.sectionHeading.copyWith(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Upload files and review your order.",
                      style: AppTextStyles.sectionSub.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const _StepBadge(label: 'Step 2/2'),
            ],
          ),
          const SizedBox(height: 24),

          // --- Section 1: Instructions & Files ---
          _buildSectionCard(
            title: "Instructions & Files",
            icon: Icons.description_outlined,
            children: [
              TextFormFieldCustom(
                title: 'REQUIREMENTS',
                isRequired: true,
                method: TextFormField(
                  controller: controller.requirementsController,
                  maxLines: 4,
                  style: AppTextStyles.inputText,
                  decoration: InputDecoration(
                    hintText: AppStrings.requirementsHint,
                    hintStyle: AppTextStyles.hintText.copyWith(
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                borderColor: AppColors.lightDivider,
                borderWidth: 1.5,
              ),
              const SizedBox(height: 16),
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 2: Order Summary ---
          _buildSectionCard(
            title: "Order Summary",
            icon: Icons.receipt_long_outlined,
            children: [
              Obx(() {
                final _ = controller.isLoading.value;

                return Column(
                  children: [
                    if (controller.selectedService.value != null)
                      _buildSummaryDetailRow('Service', controller.selectedService.value!.name),
                    if (controller.selectedWorkType.value != null)
                      _buildSummaryDetailRow('Work Type', controller.selectedWorkType.value!),
                    if (controller.selectedSubject.value != null)
                      _buildSummaryDetailRow('Subject', controller.selectedSubject.value!.name),
                    if (controller.selectedUrgency.value != null)
                      _buildSummaryDetailRow('Urgency', controller.selectedUrgency.value!.name),
                    if (controller.selectedPageConfig.value != null)
                      _buildSummaryDetailRow('Word Count', '${controller.selectedPageConfig.value!.value} Words (${controller.selectedPageConfig.value!.name})'),
                    if (controller.selectedCountry.value != null)
                      _buildSummaryDetailRow('Country', controller.selectedCountry.value!.name, isLast: true),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 3: Bank Transfer Details (Dynamic TabBar) ---
          _buildSectionCard(
            title: "Bank Transfer Details",
            icon: Icons.account_balance,
            children: [
              Obx(() {
                if (controller.isBankLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                if (controller.banksList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text("No bank details found.")),
                  );
                }

                return BankTransferDetailsWidget(
                  banksList: controller.banksList,
                  tabViewHeight: 220,
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 4: Payment & Terms ---
          _buildSectionCard(
            title: "Price & Terms",
            icon: Icons.account_balance_wallet_outlined,
            children: [
              // Reactive Real-Time Pricing Summary
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.priceBg.withValues(alpha:0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryPurple.withValues(alpha:0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.priceDetails, style: AppTextStyles.priceTitle.copyWith(fontSize: 14)),
                      const SizedBox(height: 12),

                      _PriceRow(
                        label: AppStrings.basicPrice,
                        value: controller.formattedEstimatedPrice,
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(AppStrings.discount, style: AppTextStyles.priceLabel),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF6B6B), Color(0xFFFF9A5C)],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  AppStrings.discountBadge,
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '- £${controller.savingsAmount.toStringAsFixed(2)}',
                            style: AppTextStyles.discountValue.copyWith(color: const Color(0xFFFF6B6B)),
                          ),
                        ],
                      ),
                       Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: AppColors.priceDivider),
                      ),

                      _PriceRow(
                        label: AppStrings.total,
                        value: controller.formattedFinalPrice,
                        isTotal: true,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Policy & Terms Conditions Checkbox
              Obx(
                    () => GestureDetector(
                  onTap: controller.toggleAccepted,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: controller.isAccepted.value ? AppColors.primaryPurple : AppColors.appBackground,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: controller.isAccepted.value ? AppColors.primaryPurple : AppColors.lightDivider,
                            width: 1.5,
                          ),
                        ),
                        child: controller.isAccepted.value
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.termsText.copyWith(height: 1.4, color: AppColors.textSecondary),
                            children: [
                              const TextSpan(text: AppStrings.termsSuffix),
                              TextSpan(
                                text: AppStrings.termsOfUse,
                                style: AppTextStyles.termsLink.copyWith(color: AppColors.primaryPurple, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: AppStrings.termsAnd),
                              TextSpan(
                                text: AppStrings.privacyPolicy,
                                style: AppTextStyles.termsLink.copyWith(color: AppColors.primaryPurple, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: AppStrings.termsMid),
                              TextSpan(
                                text: AppStrings.moneyBackGuarantee,
                                style: AppTextStyles.termsLink.copyWith(color: AppColors.primaryPurple, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: AppStrings.termsSuffix),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // --- Bottom Action ---
          AppButton(
            title: 'Place Order & Pay',
            onTap: controller.addToCart,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: AppColors.primaryPurple),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 1, color: AppColors.lightDivider),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// LOCAL WIDGETS
// ---------------------------------------------------------

class _StepBadge extends StatelessWidget {
  final String label;
  const _StepBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha:0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration:  BoxDecoration(
              color: AppColors.primaryPurple,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.stepBadge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryPurple,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.totalLabel.copyWith(fontSize: 16, fontWeight: FontWeight.w800)
              : AppTextStyles.priceLabel,
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.totalValue.copyWith(fontSize: 18, color: AppColors.primaryPurple)
              : AppTextStyles.priceValue.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}