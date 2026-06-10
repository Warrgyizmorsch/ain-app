import 'dart:io';


import '../../../common/constant/app_imports.dart';
import '../controllers/add_order_controller.dart';

class RequirementsAndPaymentStep extends GetView<AddOrderController> {
  const RequirementsAndPaymentStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => _StepBadge(label: 'Step ${controller.currentStep.value}/2')),
          const SizedBox(height: 12),

          const Text(
            'SPECIFY YOUR REQUIREMENTS HERE',
            style: AppTextStyles.fieldLabel,
          ),
          const SizedBox(height: 8),

          // Requirements Textarea
          TextFormFieldCustom(
            title: '',
            showTitle: false,
            method: TextFormField(
              controller: controller.requirementsController,
              maxLines: 5,
              style: AppTextStyles.inputText,
              decoration: InputDecoration(
                hintText: AppStrings.requirementsHint,
                hintStyle: AppTextStyles.hintText.copyWith(
                  fontSize: AppFontSize.s12,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            borderColor: AppColors.lightDivider,
            borderWidth: 1.5,
          ),
          const SizedBox(height: 8),

          // Upload File Interaction Zone
          GestureDetector(
            onTap: controller.pickFile,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.lightDivider,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.upload_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.dropFilesHint,
                    style: AppTextStyles.uploadHint,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Reactive Selection Attachment Preview List
          Obx(() {
            if (controller.pickedFiles.isEmpty) {
              return const SizedBox.shrink();
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.pickedFiles.length,
              itemBuilder: (context, index) {
                final file = controller.pickedFiles[index];
                final fileName = file.path.split(Platform.isWindows ? '\\' : '/').last;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.lightDivider, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.insert_drive_file_outlined, size: 20, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          fileName,
                          style: AppTextStyles.inputText.copyWith(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                        onPressed: () => controller.removeFile(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          const SizedBox(height: 16),

          // ─── DYNAMIC SELECTION SUMMARY BREAKUP ───
          Obx(() {
            final _ = controller.isLoading.value;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightDivider, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SELECTED DETAILS',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),

                  if (controller.selectedService.value != null)
                    _buildSummaryDetailRow('Service:', controller.selectedService.value!.name),
                  if (controller.selectedWorkType.value != null)
                    _buildSummaryDetailRow('Work Type:', controller.selectedWorkType.value!),
                  if (controller.selectedSubject.value != null)
                    _buildSummaryDetailRow('Subject:', controller.selectedSubject.value!.name),
                  if (controller.selectedUrgency.value != null)
                    _buildSummaryDetailRow('Urgency:', controller.selectedUrgency.value!.name),
                  if (controller.selectedPageConfig.value != null)
                    _buildSummaryDetailRow('Word Count:', '${controller.selectedPageConfig.value!.value} Words (${controller.selectedPageConfig.value!.name})'),
                  if (controller.selectedCountry.value != null)
                    _buildSummaryDetailRow('Country:', controller.selectedCountry.value!.name),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // Reactive Real-Time Pricing Summary Invoice Box
          Obx(() {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.priceBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.priceDetails, style: AppTextStyles.priceTitle),
                  const SizedBox(height: 8),

                  _PriceRow(
                    label: AppStrings.basicPrice,
                    value: controller.formattedEstimatedPrice,
                  ),
                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(AppStrings.discount, style: AppTextStyles.priceLabel),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF9A5C),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              AppStrings.discountBadge,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '£${controller.savingsAmount.toStringAsFixed(2)}',
                        style: AppTextStyles.discountValue,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
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
          const SizedBox(height: 12),

          // Policy & Terms Conditions Checkbox Verification Input
          Obx(
                () => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: controller.toggleAccepted,
                  child: Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: controller.isAccepted.value ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: controller.isAccepted.value ? AppColors.primary : AppColors.lightDivider,
                        width: 1.5,
                      ),
                    ),
                    child: controller.isAccepted.value
                        ? const Icon(Icons.check, size: 11, color: AppColors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.termsText,
                      children: [
                        const TextSpan(text: AppStrings.termsSuffix),
                        TextSpan(
                          text: AppStrings.termsOfUse,
                          style: AppTextStyles.termsLink,
                        ),
                        const TextSpan(text: AppStrings.termsAnd),
                        TextSpan(
                          text: AppStrings.privacyPolicy,
                          style: AppTextStyles.termsLink,
                        ),
                        TextSpan(
                          text: AppStrings.termsMid,
                        ),
                        TextSpan(
                          text: AppStrings.moneyBackGuarantee,
                          style: AppTextStyles.termsLink,
                        ),
                        const TextSpan(text: AppStrings.termsSuffix),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          AppButton(title: 'Add to Cart', onTap: controller.addToCart),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummaryDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

// Local Helper Step Badge Widget
class _StepBadge extends StatelessWidget {
  final String label;
  const _StepBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.stepBadge),
        ],
      ),
    );
  }
}

// Local Helper Price Row Widget
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
          style: isTotal ? AppTextStyles.totalLabel : AppTextStyles.priceLabel,
        ),
        Text(
          value,
          style: isTotal ? AppTextStyles.totalValue : AppTextStyles.priceValue,
        ),
      ],
    );
  }
}