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
                  return  Padding(
                    padding: EdgeInsets.all(20.0),
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

                final uniqueCountries = controller.banksList
                    .map((bank) => bank.name ?? 'Global')
                    .toSet()
                    .toList();

                return DefaultTabController(
                  length: uniqueCountries.length,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Tab Bar Header
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicatorColor: AppColors.primary,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: Colors.grey.shade600,
                        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        tabs: uniqueCountries.map((country) => Tab(text: country)).toList(),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        height: 200,
                        child: TabBarView(
                          children: uniqueCountries.map((country) {
                            final countryBanks = controller.banksList
                                .where((bank) => (bank.name ?? 'Global') == country)
                                .toList();

                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: countryBanks.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final bank = countryBanks[index];
                                return Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.lightDivider),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildCopyableRow("Account Name", bank.accountHolder ?? "N/A"),
                                       Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: AppColors.lightDivider)),
                                      _buildCopyableRow("Account Number", bank.accountNumber ?? "N/A"),
                                       Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: AppColors.lightDivider)),
                                      _buildCopyableRow("Sort Code / Routing", bank.sortCode ?? "N/A"),
                                    ],
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
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
                    border: Border.all(color: AppColors.primary.withValues(alpha:0.1)),
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
                          color: controller.isAccepted.value ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: controller.isAccepted.value ? AppColors.primary : Colors.grey.shade400,
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
                            style: AppTextStyles.termsText.copyWith(height: 1.4, color: Colors.grey.shade700),
                            children: [
                              const TextSpan(text: AppStrings.termsSuffix),
                              TextSpan(
                                text: AppStrings.termsOfUse,
                                style: AppTextStyles.termsLink.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: AppStrings.termsAnd),
                              TextSpan(
                                text: AppStrings.privacyPolicy,
                                style: AppTextStyles.termsLink.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: AppStrings.termsMid),
                              TextSpan(
                                text: AppStrings.moneyBackGuarantee,
                                style: AppTextStyles.termsLink.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
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
                  color: AppColors.primary.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
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
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to easily copy bank details (Fixed Text Overflow)
  Widget _buildCopyableRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            Get.snackbar(
              "Copied",
              "$label copied to clipboard",
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(12),
              backgroundColor: AppColors.success,
              colorText: Colors.white,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha:0.1), borderRadius: BorderRadius.circular(6)),
            child:  Icon(Icons.copy, size: 16, color: AppColors.primary),
          ),
        ),
      ],
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
        color: AppColors.primary.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha:0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration:  BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.stepBadge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
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
              ? AppTextStyles.totalValue.copyWith(fontSize: 18, color: AppColors.primary)
              : AppTextStyles.priceValue.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}