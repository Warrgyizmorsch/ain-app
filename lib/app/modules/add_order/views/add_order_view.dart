import '../../../common/constant/app_imports.dart';
import '../controllers/add_order_controller.dart';

class AddOrderView extends GetView<AddOrderController> {
  const AddOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Scaffold(
        backgroundColor: AppColors.background,
        appBar:  CustomAppBar(
            title: controller.currentStep.value == 1
                ? 'Order Assignment'
                : 'Order Now',

        ),
        body: Obx(() {
          return controller.currentStep.value == 1
              ? _buildStep1And2(context)
              : _buildStep3(context);
        }),
      ),
    );
  }

  // ─── STEP 1 & 2 ─────────────────────────────────────────────────────────────
  Widget _buildStep1And2(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step badge
          _StepBadge(label: 'Step ${controller.currentStep.value}/2'),
          const SizedBox(height: 10),

          // Section heading
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Assignment ',
                  style: AppTextStyles.sectionHeading.copyWith(
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 20)),
                  ),
                ),
                TextSpan(
                  text: 'Details',
                  style: AppTextStyles.sectionHeading,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Tell us what you need — we'll handle the rest.",
            style: AppTextStyles.sectionSub,
          ),
          const SizedBox(height: 16),

          // Assignment Topic
          TextFormFieldCustom(
            title: 'ASSIGNMENT TOPIC',
            isRequired: true,
            method: TextFormField(
              controller: controller.topicController,
              style: AppTextStyles.inputText,
              decoration: InputDecoration(
                hintText: 'Assignment topic',
                hintStyle: AppTextStyles.hintText,
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            borderColor: AppColors.lightDivider,
            borderWidth: 1.5,
            height: 44,
          ),
          const SizedBox(height: 12),

          // Subject dropdown
          TextFormFieldCustom(
            title: 'SUBJECT',
            isRequired: true,
            showTitle: true,
            method: CustomDropdown<String>(
              valueListenable: controller.subjectNotifier,
              items: controller.subjects,
              label: (s) => s,
              hint: 'Select Subject',
              onChanged: (v) => controller.subjectNotifier.value = v,
              showBorder: false,
            ),
            borderColor: AppColors.lightDivider,
            borderWidth: 1.5,
            height: 44,
          ),
          const SizedBox(height: 12),

          // Service dropdown
          TextFormFieldCustom(
            title: 'SERVICE',
            method: CustomDropdown<String>(
              valueListenable: controller.serviceNotifier,
              items: controller.services,
              label: (s) => s,
              hint: 'Select Service',
              onChanged: (v) => controller.serviceNotifier.value = v,
              showBorder: false,
            ),
            borderColor: AppColors.lightDivider,
            borderWidth: 1.5,
            height: 44,
          ),
          const SizedBox(height: 12),

          // Deadline
          TextFormFieldCustom(
            title: 'DEADLINE',
            method: TextFormField(
              controller: controller.deadlineController,
              keyboardType: TextInputType.datetime,
              style: AppTextStyles.inputText,
              decoration: InputDecoration(
                hintText: 'MM/DD/YYYY',
                hintStyle: AppTextStyles.hintText,
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            borderColor: AppColors.lightDivider,
            borderWidth: 1.5,
            height: 44,
          ),
          const SizedBox(height: 12),

          // Pages
          TextFormFieldCustom(
            title: 'PAGES',
            method: CustomDropdown<String>(
              valueListenable: controller.pageNotifier,
              items: controller.pages,
              label: (s) => s,
              hint: 'Select Pages',
              onChanged: (v) => controller.pageNotifier.value = v,
              showBorder: false,
            ),
            borderColor: AppColors.lightDivider,
            borderWidth: 1.5,
            height: 44,
          ),
          const SizedBox(height: 12),

          // Work Type dropdown
          TextFormFieldCustom(
            title: 'WORK TYPE',
            method: CustomDropdown<String>(
              valueListenable: controller.workTypeNotifier,
              items: controller.workTypes,
              label: (s) => s,
              hint: 'Select Work Type',
              onChanged: (v) => controller.workTypeNotifier.value = v,
              showBorder: false,
            ),
            borderColor: AppColors.lightDivider,
            borderWidth: 1.5,
            height: 44,
          ),
          const SizedBox(height: 24),

          AppButton(
            title: 'Continue',
            onTap: controller.onContinue,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── STEP 3 ──────────────────────────────────────────────────────────────────
  Widget _buildStep3(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepBadge(label: 'Step 2/2+'),
          const SizedBox(height: 12),

          const Text(
            'SPECIFY YOUR REQUIREMENTS HERE',
            style: AppTextStyles.fieldLabel,
          ),
          const SizedBox(height: 8),

          // Requirements textarea
          TextFormFieldCustom(
            title: '',
            showTitle: false,
            method: TextFormField(
              controller: controller.requirementsController,
              maxLines: 5,
              style: AppTextStyles.inputText,
              decoration: InputDecoration(
                hintText:
                AppStrings.requirementsHint,
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

          // Upload zone
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
          const SizedBox(height: 12),

          // Price box
          Container(
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

                // Basic Price
                _PriceRow(
                  label: AppStrings.basicPrice,
                  value: 'USD 224.52',
                ),
                const SizedBox(height: 6),

                // Discount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(AppStrings.discount, style: AppTextStyles.priceLabel),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
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
                    Text('USD 67.36', style: AppTextStyles.discountValue),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.priceDivider),
                ),

                // Total
                _PriceRow(
                  label: AppStrings.total,
                  value: 'USD 157.16',
                  isTotal: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Terms checkbox
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
                      color: controller.isAccepted.value
                          ? AppColors.primary
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: controller.isAccepted.value
                            ? AppColors.primary
                            : AppColors.lightDivider,
                        width: 1.5,
                      ),
                    ),
                    child: controller.isAccepted.value
                        ? const Icon(Icons.check,
                        size: 11, color: AppColors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.termsText,
                      children: [
                        const TextSpan(
                            text: AppStrings.termsSuffix),
                        TextSpan(
                          text:AppStrings.termsOfUse,
                          style: AppTextStyles.termsLink,
                        ),
                        const TextSpan(text: AppStrings.termsAnd),
                        TextSpan(
                          text: AppStrings.privacyPolicy,
                          style: AppTextStyles.termsLink,
                        ),
                         TextSpan(
                          text:
                        AppStrings.termsMid,
                        ),
                        TextSpan(
                          text: AppStrings.moneyBackGuarantee,
                          style: AppTextStyles.termsLink,
                        ),
                        const TextSpan(
                            text: AppStrings.termsSuffix),
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
}

// ─── LOCAL HELPER WIDGETS ────────────────────────────────────────────────────

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
              ? AppTextStyles.totalLabel
              : AppTextStyles.priceLabel,
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.totalValue
              : AppTextStyles.priceValue,
        ),
      ],
    );
  }
}