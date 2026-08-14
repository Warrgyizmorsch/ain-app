import 'dart:io';
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
                                ..shader =
                                    LinearGradient(
                                      colors: [
                                        AppColors.secondary,
                                        AppColors.primary,
                                      ],
                                    ).createShader(
                                      const Rect.fromLTWH(0, 0, 200, 20),
                                    ),
                            ),
                          ),
                          TextSpan(
                            text: 'Steps',
                            style: AppTextStyles.sectionHeading.copyWith(
                              fontSize: 24,
                            ),
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

                method: TextFormField(
                  controller: controller.requirementsController,
                  maxLines: 4,
                  style: AppTextStyles.inputText,
                  decoration: InputDecoration(
                    hintText: AppStrings.requirementsHint,
                    hintStyle: AppTextStyles.hintText.copyWith(fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                borderColor: AppColors.lightDivider,
                borderWidth: 0,
              ),
              const SizedBox(height: 16),

              // --- Upload File Section ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'ATTACH DOCUMENTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(OPTIONAL)',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: controller.pickFile,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryPurple.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.cloud_upload_outlined,
                              color: AppColors.primaryPurple,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to browse & attach files',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PDF, DOC, DOCX, ZIP, PNG, JPG (Multiple files supported)',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- Uploaded Files List ---
                  Obx(() {
                    final files = controller.pickedFiles;
                    if (files.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Attached Files (${files.length})',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: files.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final file = files[index];
                            final fileName = file.path
                                .split(RegExp(r'[/\\]'))
                                .last;
                            final fileSize = _getFileSize(file);

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bgLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.lightDivider,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPurple.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getFileIcon(fileName),
                                      color: AppColors.primaryPurple,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fileName,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (fileSize.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            fileSize,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.error,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        controller.removeFile(index),
                                    tooltip: 'Remove file',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
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
                    if (controller.selectedExpert.value != null)
                      _buildSummaryDetailRow(
                        'Assigned Expert',
                        '${controller.selectedExpert.value!.name ?? "Expert"} (ID: #${controller.selectedExpert.value!.id ?? "N/A"})',
                      ),
                    if (controller.selectedService.value != null)
                      _buildSummaryDetailRow(
                        'Service',
                        controller.selectedService.value!.name,
                      ),
                    if (controller.selectedWorkType.value != null)
                      _buildSummaryDetailRow(
                        'Work Type',
                        controller.selectedWorkType.value!,
                      ),
                    if (controller.selectedSubject.value != null)
                      _buildSummaryDetailRow(
                        'Subject',
                        controller.selectedSubject.value!.name,
                      ),
                    if (controller.selectedUrgency.value != null)
                      _buildSummaryDetailRow(
                        'Urgency',
                        controller.selectedUrgency.value!.name,
                      ),
                    if (controller.selectedPageConfig.value != null)
                      _buildSummaryDetailRow(
                        'Word Count',
                        '${controller.selectedPageConfig.value!.value} Words (${controller.selectedPageConfig.value!.name})',
                      ),
                    if (controller.selectedCountry.value != null)
                      _buildSummaryDetailRow(
                        'Country',
                        controller.selectedCountry.value!.name,
                        isLast: true,
                      ),
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
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
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
                  tabViewHeight: 250,
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 3.5: Wallet Payment Option ---
          _buildSectionCard(
            title: "Wallet Payment",
            icon: Icons.account_balance_wallet_outlined,
            children: [
              Obx(() {
                final balance = controller.walletBalance.value;
                final isSelected = controller.useWallet.value;
                final currency = controller.walletCurrency.value;
                final isLoading = controller.isWalletLoading.value;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryPurple.withValues(alpha: 0.08)
                        : AppColors.bgLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryPurple
                          : AppColors.lightDivider,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(
                            alpha: 0.15,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.wallet,
                          color: AppColors.primaryPurple,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Wallet Balance',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    '$currency${balance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      // Checkbox for Use Wallet
                      GestureDetector(
                        onTap: () {
                          if (balance > 0) {
                            controller.toggleUseWallet();
                          } else {
                            Get.snackbar(
                              'Insufficient Wallet Balance',
                              'Your wallet balance is £0.00. Please top up your wallet.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.amberAccent.withValues(
                                alpha: 0.2,
                              ),
                              colorText: Colors.black87,
                            );
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              activeColor: AppColors.primaryPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (val) {
                                if (balance > 0) {
                                  controller.toggleUseWallet();
                                } else {
                                  Get.snackbar(
                                    'Insufficient Wallet Balance',
                                    'Your wallet balance is £0.00. Please top up your wallet.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.amberAccent
                                        .withValues(alpha: 0.2),
                                    colorText: Colors.black87,
                                  );
                                }
                              },
                            ),
                            Text(
                              'Use Wallet',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: balance > 0
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextDisabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 3.6: Apply Coupon Section ---
          // --- Section 3.6: Apply Coupon Section ---
          Obx(() {
            final isApplied = controller.isCouponApplied.value;
            final appliedCode = controller.appliedCouponCode.value;
            final discountAmt = controller.couponDiscountAmount.value;

            if (isApplied) {
              // ACTIVE APPLIED STATE
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.green.shade300,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_offer_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "'$appliedCode' applied",
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "You saved £${discountAmt.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: controller.removeCoupon,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.red.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      child: const Text(
                        'REMOVE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // DEFAULT UNAPPLIED STATE (Matches image_e90ee5.png)
            return GestureDetector(
              onTap: () => showCouponBottomSheet(context, controller),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  // NOTE: For the exact dashed border seen in the image, you would
                  // wrap this Container in a DottedBorder from the 'dotted_border' package.
                  // Using a solid light-purple border here as a native fallback.
                  border: Border.all(
                    color: AppColors.primaryPurple.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Left Purple Icon Box
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_offer_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Middle Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Apply Coupon ✨',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Save extra with promo codes',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right 'APPLY' Button Outline
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryPurple.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'APPLY',
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // --- Section 4: Payment & Terms ---
          _buildSectionCard(
            title: "Price & Terms",
            icon: Icons.receipt_outlined,
            children: [
              // Reactive Real-Time Pricing Summary
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.priceBg.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryPurple.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.priceDetails,
                        style: AppTextStyles.priceTitle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 12),

                      _PriceRow(
                        label: AppStrings.basicPrice,
                        value: controller.formattedEstimatedPrice,
                      ),
                      const SizedBox(height: 8),

                      if (controller.globalDiscountPercentage.value > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppStrings.discount,
                                  style: AppTextStyles.priceLabel,
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF6B6B),
                                        Color(0xFFFF9A5C),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${controller.globalDiscountPercentage.value}% OFF',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '- £${controller.globalDiscountAmount.toStringAsFixed(2)}',
                              style: AppTextStyles.discountValue.copyWith(
                                color: const Color(0xFFFF6B6B),
                              ),
                            ),
                          ],
                        ),

                      if (controller.isCouponApplied.value) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Coupon (${controller.appliedCouponCode.value})',
                                  style: AppTextStyles.priceLabel,
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.confirmation_number_outlined,
                                  size: 14,
                                  color: AppColors.success,
                                ),
                              ],
                            ),
                            Text(
                              '- £${controller.couponDiscountAmount.value.toStringAsFixed(2)}',
                              style: AppTextStyles.discountValue.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          height: 1,
                          color: AppColors.priceDivider,
                        ),
                      ),

                      _PriceRow(
                        label: AppStrings.total,
                        value: controller.formattedFinalPrice,
                        isTotal: !controller.useWallet.value,
                      ),

                      if (controller.useWallet.value) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Wallet Amount Applied',
                                  style: AppTextStyles.priceLabel,
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.account_balance_wallet,
                                  size: 14,
                                  color: AppColors.success,
                                ),
                              ],
                            ),
                            Text(
                              controller.formattedWalletDeduction,
                              style: AppTextStyles.discountValue.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Divider(
                            height: 1,
                            color: AppColors.priceDivider,
                          ),
                        ),
                        _PriceRow(
                          label: 'Net Payable Amount',
                          value: controller.formattedNetPayablePrice,
                          isTotal: true,
                        ),
                      ],
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
                          color: controller.isAccepted.value
                              ? AppColors.primaryPurple
                              : AppColors.appBackground,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: controller.isAccepted.value
                                ? AppColors.primaryPurple
                                : AppColors.lightDivider,
                            width: 1.5,
                          ),
                        ),
                        child: controller.isAccepted.value
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.termsText.copyWith(
                              height: 1.4,
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              const TextSpan(text: AppStrings.termsSuffix),
                              TextSpan(
                                text: AppStrings.termsOfUse,
                                style: AppTextStyles.termsLink.copyWith(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: AppStrings.termsAnd),
                              TextSpan(
                                text: AppStrings.privacyPolicy,
                                style: AppTextStyles.termsLink.copyWith(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: AppStrings.termsMid),
                              TextSpan(
                                text: AppStrings.moneyBackGuarantee,
                                style: AppTextStyles.termsLink.copyWith(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                ),
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
            title: controller.isEditingOrder ? 'Update Order' : 'Add Order',
            onTap: controller.addToCart,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  void showCouponBottomSheet(BuildContext context, dynamic controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.percent_rounded,
                        color: AppColors.primaryPurple,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Apply Coupon Code',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Enter promo code to avail discount',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade200, thickness: 1),
              const SizedBox(height: 16),

              // Obx State Management Body
              Expanded(
                child: Obx(() {
                  final isApplied = controller.isCouponApplied.value;
                  final isApplying = controller.isApplyingCoupon.value;
                  final appliedCode = controller.appliedCouponCode.value;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Input Field Container
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            // Note: For actual dashed borders, consider using the 'dotted_border' package.
                            // Using a solid border here for standard Flutter implementation.
                            border: Border.all(
                              color: AppColors.primaryPurple.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.percent_rounded,
                                  size: 16,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: controller.couponCodeController,
                                  enabled: !isApplied && !isApplying,
                                  textCapitalization: TextCapitalization.characters,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter coupon code',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Apply / Remove Button
                              ElevatedButton(
                                onPressed: isApplying
                                    ? null
                                    : isApplied
                                    ? () => controller.removeCoupon()
                                    : () => controller.applyCoupon(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isApplied ? Colors.red : AppColors.primaryPurple,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                child: isApplying
                                    ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : Text(
                                  isApplied ? 'REMOVE' : 'APPLY',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Available Coupons Header
                        Row(
                          children: [
                            Icon(Icons.confirmation_number_outlined,
                                size: 18, color: AppColors.primaryPurple),
                            const SizedBox(width: 8),
                            const Text(
                              'AVAILABLE COUPONS',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'TAP TO APPLY / REMOVE',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Coupon List
                        if (controller.isCouponsLoading.value)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (controller.availableCoupons.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'No available coupons at the moment.',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.sortedAvailableCoupons.length,
                            itemBuilder: (context, index) {
                              final coupon = controller.sortedAvailableCoupons[index];
                              final code = coupon.couponCode ?? '';
                              final isSelected = isApplied && appliedCode == code;
                              final bool isMinNotMet = coupon.minOrderAmount != null &&
                                  coupon.minOrderAmount! > 0 &&
                                  controller.priceAfterGlobalDiscount < coupon.minOrderAmount!;

                              String title = 'Offer Applied';
                              if (coupon.discountType == 'percentage' && coupon.discountValue != null) {
                                title = 'Get Extra ${coupon.discountValue}% OFF';
                              } else if (coupon.discountValue != null) {
                                title = 'Flat £${coupon.discountValue} OFF';
                              }

                              String subtitle = '';
                              if (isMinNotMet) {
                                final double needed = (coupon.minOrderAmount!.toDouble() - controller.priceAfterGlobalDiscount);
                                final String neededStr = needed > 0 ? needed.toStringAsFixed(2) : '0.00';
                                subtitle = 'Add £$neededStr more to unlock (Min £${coupon.minOrderAmount})';
                              } else {
                                subtitle = coupon.description ?? 'Applicable on your assignments.';
                              }

                              return _buildCouponCard(
                                code: code,
                                title: title,
                                subtitle: subtitle,
                                isSelected: isSelected,
                                isApplying: isApplying,
                                isDisabled: isMinNotMet,
                                onApply: () {
                                  if (isSelected) {
                                    controller.removeCoupon();
                                  } else if (isMinNotMet) {
                                    final double needed = (coupon.minOrderAmount!.toDouble() - controller.priceAfterGlobalDiscount);
                                    final String neededStr = needed > 0 ? needed.toStringAsFixed(2) : '0.00';
                                    Get.snackbar(
                                      'Minimum Order Not Met',
                                      'Add £$neededStr more to unlock \'$code\'. (Min order £${coupon.minOrderAmount!.toStringAsFixed(2)})',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.amberAccent.withValues(alpha: 0.2),
                                      colorText: Colors.black87,
                                    );
                                  } else if (!isApplying) {
                                    controller.applyCoupon(code: code);
                                  }
                                },
                              );
                            },
                          ),

                        const SizedBox(height: 40), // Bottom padding
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

// Helper Widget to build individual coupon cards
  Widget _buildCouponCard({
    required String code,
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isApplying,
    required bool isDisabled,
    required VoidCallback onApply,
  }) {
    final Color tagColor = isDisabled && !isSelected
        ? Colors.grey
        : AppColors.primaryPurple;
    final Color cardBg = isSelected
        ? AppColors.primaryPurple.withValues(alpha: 0.06)
        : isDisabled && !isSelected
            ? Colors.grey.shade50
            : Colors.white;

    return GestureDetector(
      onTap: onApply,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryPurple
                : isDisabled
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Coupon Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: tagColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 14,
                    color: tagColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    code,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: tagColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDisabled && !isSelected ? Colors.grey.shade600 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDisabled && !isSelected ? Colors.red.shade300 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Status Indicator Icon/Badge (Checkmark if selected, chevron icon otherwise)
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                color: isDisabled ? Colors.grey.shade400 : AppColors.primaryPurple,
                size: 22,
              ),
          ],
        ),
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
            color: Colors.black.withValues(alpha: 0.02),
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
                  color: AppColors.primaryPurple.withValues(alpha: 0.15),
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
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightDivider,
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryDetailRow(
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
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
        color: AppColors.primaryPurple.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
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
              ? AppTextStyles.totalLabel.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                )
              : AppTextStyles.priceLabel,
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.totalValue.copyWith(
                  fontSize: 18,
                  color: AppColors.primaryPurple,
                )
              : AppTextStyles.priceValue.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

String _getFileSize(File file) {
  try {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  } catch (_) {
    return '';
  }
}

IconData _getFileIcon(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  switch (ext) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'doc':
    case 'docx':
      return Icons.description;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return Icons.image;
    case 'zip':
    case 'rar':
      return Icons.folder_zip;
    default:
      return Icons.insert_drive_file;
  }
}
