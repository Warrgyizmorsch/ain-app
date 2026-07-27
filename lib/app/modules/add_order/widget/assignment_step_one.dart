import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/services_master_model.dart';
import '../../../core/models/order_now_model/subjects_master_model.dart';
import '../../../core/models/order_now_model/urgencies_master_model.dart';
import '../controllers/add_order_controller.dart';

class AssignmentDetailsStep extends GetView<AddOrderController> {
  const AssignmentDetailsStep({super.key});

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
                            text: 'Assignment ',
                            style: AppTextStyles.sectionHeading.copyWith(
                              fontSize: 24,
                              foreground: Paint()
                                ..shader =  LinearGradient(
                                  colors: [AppColors.secondary, AppColors.primary],
                                ).createShader(const Rect.fromLTWH(0, 0, 200, 20)),
                            ),
                          ),
                          TextSpan(
                            text: 'Details',
                            style: AppTextStyles.sectionHeading.copyWith(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Tell us what you need — we'll handle the rest.",
                      style: AppTextStyles.sectionSub.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => _StepBadge(label: 'Step ${controller.currentStep.value}/2')),
            ],
          ),
          const SizedBox(height: 24),

          // --- Section 1: General Information ---
          _buildSectionCard(
            title: "General Information",
            icon: Icons.info_outline_rounded,
            children: [
            //   // Country Dropdown
            //   Obx(() => TextFormFieldCustom(
            //     title: 'COUNTRY',
            //     isRequired: true,
            //     method: CustomDropdown<CountryData>(
            //       valueListenable: controller.selectedCountry,
            //       items: controller.countries,
            //       label: (c) => c.name,
            //       hint: controller.isLoading.value ? 'Loading...' : 'Select Country',
            //       onChanged: (v) {
            //         controller.selectedCountry.value = v;
            //         controller.countryError.value = '';
            //       },
            //       showBorder: false,
            //     ),
            //     borderColor: controller.countryError.isNotEmpty ? AppColors.error : AppColors.lightDivider,
            //     borderWidth: 1.5,
            //     height: 44,
            //   )),
            //   _buildError(controller.countryError),
            //   const SizedBox(height: 16),

              // Hired Expert / Writer Info Card
              Obx(() {
                final expert = controller.selectedExpert.value;
                if (expert == null) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryPurple.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.15),
                        backgroundImage: expert.image != null && expert.image!.isNotEmpty
                            ? NetworkImage(expert.image!)
                            : null,
                        child: expert.image == null || expert.image!.isEmpty
                            ? Icon(Icons.person, color: AppColors.primaryPurple, size: 28)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPurple,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'HIRED EXPERT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                if (expert.id != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    'ID: #${expert.id}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              expert.name ?? 'Expert Writer',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (expert.subject != null && expert.subject!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                expert.subject!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                );
              }),

              // Enter Topic Input
              Obx(() {
                final hasError = controller.topicError.isNotEmpty;
                return TextFormFieldCustom(
                  title: 'ENTER TOPIC',
                  isRequired: true,
                  method: TextFieldCustom(
                    controller: controller.topicController,
                    hintText: 'e.g. Marketing Strategy Analysis',
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    borderColor: hasError ? AppColors.error : AppColors.lightDivider,
                    borderWidth: 0,
                    backgroundColor: AppColors.bgLight,
                    onChanged: (value) {
                      controller.validateTopic(value ?? "");
                      return null;
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                );
              }),
              _buildError(controller.topicError),
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 2: Academic Requirements ---
          _buildSectionCard(
            title: "Academic Requirements",
            icon: Icons.school_outlined,
            children: [
              // Subject Dropdown
              Obx(() => TextFormFieldCustom(
                title: 'SUBJECT',
                isRequired: true,
                showTitle: true,
                method: CustomDropdown<SubjectData>(
                  valueListenable: controller.selectedSubject,
                  items: controller.subjects,
                  label: (s) => s.name,
                  hint: controller.isLoading.value ? 'Loading...' : 'Select Subject',
                  onChanged: (v) {
                    controller.selectedSubject.value = v;
                    controller.subjectError.value = '';
                  },
                  showBorder: false,
                ),
                borderColor: controller.subjectError.isNotEmpty ? AppColors.error : AppColors.lightDivider,
                borderWidth: 1.5,
                height: 44,
              )),
              _buildError(controller.subjectError),
              const SizedBox(height: 16),

              // Services Dropdown
              Obx(() => TextFormFieldCustom(
                title: 'SERVICES',
                isRequired: true,
                method: CustomDropdown<GetServiceModel>(
                  valueListenable: controller.selectedService,
                  items: controller.services,
                  label: (s) => s.name,
                  hint: controller.isLoading.value ? 'Loading...' : 'Select Service',
                  onChanged: (v) {
                    controller.selectedService.value = v;
                    controller.serviceError.value = '';
                  },
                  showBorder: false,
                ),
                borderColor: controller.serviceError.isNotEmpty ? AppColors.error : AppColors.lightDivider,
                borderWidth: 1.5,
                height: 44,
              )),
              _buildError(controller.serviceError),
              const SizedBox(height: 16),

              // Work Type Dropdown
              Obx(() => TextFormFieldCustom(
                title: 'WORK TYPE',
                isRequired: true,
                method: CustomDropdown<String>(
                  valueListenable: controller.selectedWorkType,
                  items: controller.workTypes,
                  label: (s) => s,
                  hint: controller.isLoading.value ? 'Loading...' : 'Select Work Type',
                  onChanged: (v) {
                    controller.selectedWorkType.value = v;
                    controller.workTypeError.value = '';
                  },
                  showBorder: false,
                ),
                borderColor: controller.workTypeError.isNotEmpty ? AppColors.error : AppColors.lightDivider,
                borderWidth: 1.5,
                height: 44,
              )),
              _buildError(controller.workTypeError),
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 3: Scope & Timeline ---
          _buildSectionCard(
            title: "Scope & Timeline",
            icon: Icons.timer_outlined,
            children: [
              // Urgency Dropdown
              Obx(() => TextFormFieldCustom(
                title: 'SELECT URGENCY',
                isRequired: true,
                method: CustomDropdown<UrgencyData>(
                  valueListenable: controller.selectedUrgency,
                  items: controller.urgencies,
                  label: (u) => u.name,
                  hint: controller.isLoading.value ? 'Loading...' : 'Select Delivery Time',
                  onChanged: (v) {
                    controller.selectedUrgency.value = v;
                    controller.urgencyError.value = '';
                  },
                  showBorder: false,
                ),
                borderColor: controller.urgencyError.isNotEmpty ? AppColors.error : AppColors.lightDivider,
                borderWidth: 1.5,
                height: 44,
              )),
              _buildError(controller.urgencyError),
              const SizedBox(height: 16),

              // Word Count / Pages Counter Widget
              Obx(() {
                final count = controller.currentWordCount.value;
                final pages = count ~/ 250;
                final hasError = controller.wordCountError.isNotEmpty;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: 0.5,
                            ),
                            children: const [
                              TextSpan(text: 'WORD COUNT / PAGES '),
                              TextSpan(
                                text: '*',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$pages ${pages == 1 ? 'Page' : 'Pages'} approx.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // --- TextField with Prefix (-) and Suffix (+) ---
                    TextFieldCustom(
                      controller: controller.wordCountTextController,
                      textInputType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      borderColor: hasError ? AppColors.error : AppColors.lightDivider,
                      borderWidth: 1.5,
                      hintTextSize: 18,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      textAlign: TextAlign.center,
                      // DECREMENT (-) BUTTON
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                        child: Material(
                          color: count <= 250
                              ? AppColors.lightDivider.withValues(alpha: 0.4)
                              : AppColors.primaryPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: count <= 250 ? null : () => controller.decrementWordCount(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                Icons.remove,
                                size: 22,
                                color: count <= 250
                                    ? AppColors.lightTextDisabled
                                    : AppColors.primaryPurple,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // INCREMENT (+) BUTTON
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                        child: Material(
                          color: AppColors.primaryPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => controller.incrementWordCount(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                Icons.add,
                                size: 22,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Update GetX state when typing
                      onChanged: (val) {
                        final parsedCount = int.tryParse(val ?? '') ?? 0;
                        controller.currentWordCount.value = parsedCount;
                        controller.updateWordCountConfig();
                        return null;
                      },
                    ),

                    // --- Quick Preset Chips ---
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [250, 500, 1000, 1500, 2500, 5000].map((preset) {
                          final isSelected = count == preset;
                          final presetPages = preset ~/ 250;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text('$preset W ($presetPages pgs)'),
                              selected: isSelected,
                              onSelected: (_) => controller.setWordCount(preset),
                              selectedColor: AppColors.primaryPurple,
                              backgroundColor: AppColors.bgLight,
                              showCheckmark: false,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primaryPurple
                                      : AppColors.lightDivider,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }),
              _buildError(controller.wordCountError),
            ],
          ),
          const SizedBox(height: 32),

          // --- Bottom Action ---
          AppButton(
            title: 'Continue to Next Step', // Slightly more descriptive button text
            onTap: controller.onContinue,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS FOR A PREMIUM UI
  // ==========================================

  /// Reusable Card Wrapper for grouping sections beautifully
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
          // Section Title Row
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
          // Section Form Fields
          ...children,
        ],
      ),
    );
  }

  /// Reusable Animated Error Widget
  Widget _buildError(RxString errorMsg) {
    return Obx(() => AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: errorMsg.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.only(top: 6, left: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, size: 16, color: AppColors.error),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                errorMsg.value,
                style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      )
          : const SizedBox.shrink(),
    ));
  }
}

class _StepBadge extends StatelessWidget {
  final String label;
  const _StepBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha:0.1), // Adjusted to match theme better
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
              color: AppColors.primaryPurple, // Pop of color
            ),
          ),
        ],
      ),
    );
  }
}