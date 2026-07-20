import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/services_master_model.dart';
import '../../../core/models/order_now_model/subjects_master_model.dart';
import '../../../core/models/order_now_model/urgencies_master_model.dart';
import '../../../core/models/order_now_model/word_count_master_model.dart';
import '../controllers/add_order_controller.dart';

class AssignmentDetailsStep extends GetView<AddOrderController> {
  const AssignmentDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(), // Smoother scrolling
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
                        color: Colors.grey.shade600,
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
                    borderWidth: 1.5,
                    backgroundColor: Colors.white,
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

              // Word Count Dropdown
              Obx(() => TextFormFieldCustom(
                title: 'WORD COUNT / PAGES',
                isRequired: true,
                method: CustomDropdown<WordCountData>(
                  valueListenable: controller.selectedPageConfig,
                  items: controller.wordCount,
                  label: (s) => s.name,
                  hint: controller.isLoading.value ? 'Loading...' : 'Select Pages',
                  onChanged: (v) {
                    controller.selectedPageConfig.value = v;
                    controller.wordCountError.value = '';
                  },
                  showBorder: false,
                ),
                borderColor: controller.wordCountError.isNotEmpty ? AppColors.error : AppColors.lightDivider,
                borderWidth: 1.5,
                height: 44,
              )),
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
          // Section Title Row
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
              color: AppColors.primary, // Pop of color
            ),
          ),
        ],
      ),
    );
  }
}