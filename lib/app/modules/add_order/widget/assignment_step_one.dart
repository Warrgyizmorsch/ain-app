import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/countries_master_model.dart';
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step badge
          Obx(() => _StepBadge(label: 'Step ${controller.currentStep.value}/2')),
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

          // // 1. Name Input
          // Obx(() {
          //   final hasError = controller.fullNameError.isNotEmpty;
          //   return TextFormFieldCustom(
          //     title: 'NAME',
          //     isRequired: true,
          //     method: TextFieldCustom(
          //       controller: controller.nameController,
          //       hintText: 'Enter your full name',
          //       textInputType: TextInputType.name,
          //       textInputAction: TextInputAction.next,
          //       borderColor: hasError ? AppColors.error : AppColors.lightDivider,
          //       borderWidth: 1.5,
          //       backgroundColor: Colors.white,
          //       onChanged: (value) {
          //         controller.validateFullName(value ?? "");
          //         return null;
          //       },
          //       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          //     ),
          //   );
          // }),
          // Obx(() => controller.fullNameError.isNotEmpty
          //     ? Padding(
          //   padding: const EdgeInsets.only(top: 4, left: 5),
          //   child: Text(
          //     controller.fullNameError.value,
          //     style: const TextStyle(fontSize: 12, color: AppColors.error),
          //   ),
          // )
          //     : const SizedBox.shrink()),
          // const SizedBox(height: 12),
          //
          // // 2. Email Address Input
          // Obx(() {
          //   final hasError = controller.emailError.isNotEmpty;
          //   return TextFormFieldCustom(
          //     title: 'EMAIL ADDRESS',
          //     isRequired: true,
          //     method: TextFieldCustom(
          //       controller: controller.emailController,
          //       hintText: 'Enter email address',
          //       textInputType: TextInputType.emailAddress,
          //       textInputAction: TextInputAction.next,
          //       borderColor: hasError ? AppColors.error : AppColors.lightDivider,
          //       borderWidth: 1.5,
          //       backgroundColor: Colors.white,
          //       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          //       onChanged: (value) {
          //         controller.validateEmail(value ?? "");
          //         return null;
          //       },
          //     ),
          //   );
          // }),
          // Obx(() => controller.emailError.isNotEmpty
          //     ? Padding(
          //   padding: const EdgeInsets.only(top: 4, left: 5),
          //   child: Text(
          //     controller.emailError.value,
          //     style: const TextStyle(fontSize: 12, color: AppColors.error),
          //   ),
          // )
          //     : const SizedBox.shrink()),
          const SizedBox(height: 12),

          // 3. Country Dropdown
          Obx(() => TextFormFieldCustom(
            title: 'COUNTRY',
            isRequired: true,
            method: CustomDropdown<CountryData>(
              valueListenable: controller.selectedCountry,
              items: controller.countries,
              label: (c) => c.name,
              hint: controller.isLoading.value ? 'Loading...' : 'Select Country',
              onChanged: (v) {
                controller.selectedCountry.value = v;
                controller.countryError.value = '';
              },
              showBorder: false,
            ),
            borderColor: controller.countryError.isNotEmpty ? AppColors.error : AppColors.lightDivider,
            borderWidth: 1.5,
            height: 44,
          )),
          Obx(() => controller.countryError.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 5),
            child: Text(
              controller.countryError.value,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          )
              : const SizedBox.shrink()),
          const SizedBox(height: 12),

          // 4. Contact Details Input
          // Obx(() {
          //   final hasError = controller.mobileError.isNotEmpty;
          //   return TextFormFieldCustom(
          //     title: "CONTACT DETAILS",
          //     isRequired: true,
          //     method: TextFieldCustom(
          //       controller: controller.mobileController,
          //       hintText: "Enter Mobile Number",
          //       textInputType: TextInputType.number,
          //       textInputAction: TextInputAction.next,
          //       borderColor: hasError ? AppColors.error : AppColors.lightDivider,
          //       borderWidth: 1.5,
          //       backgroundColor: Colors.white,
          //       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          //       inputFormatters: [
          //         FilteringTextInputFormatter.digitsOnly,
          //         UsNumberTextInputFormatter(),
          //       ],
          //       onChanged: (value) {
          //         controller.validateMobileNumber(value ?? "");
          //         return null;
          //       },
          //       prefixIcon: CountryCodePicker(
          //         onChanged: (country) {
          //           if (country.dialCode != null) {
          //             controller.selectedDialCode.value = country.dialCode!;
          //           }
          //         },
          //         initialSelection: 'US',
          //         favorite: const ['+1', 'US'],
          //         showDropDownButton: true,
          //         showCountryOnly: false,
          //         padding: EdgeInsets.zero,
          //         alignLeft: false,
          //         textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          //         flagWidth: 24,
          //       ),
          //     ),
          //   );
          // }),
          // Obx(() => controller.mobileError.isNotEmpty
          //     ? Padding(
          //   padding: const EdgeInsets.only(top: 4, left: 5),
          //   child: Text(
          //     controller.mobileError.value,
          //     style: const TextStyle(fontSize: 12, color: AppColors.error),
          //   ),
          // )
          //     : const SizedBox.shrink()),
          const SizedBox(height: 12),

          // 5. Enter Topic Input
          Obx(() {
            final hasError = controller.topicError.isNotEmpty;
            return TextFormFieldCustom(
              title: 'ENTER TOPIC',
              isRequired: true,
              method: TextFieldCustom(
                controller: controller.topicController,
                hintText: 'Assignment topic',
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
          Obx(() => controller.topicError.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 5),
            child: Text(
              controller.topicError.value,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          )
              : const SizedBox.shrink()),
          const SizedBox(height: 12),

          // 6. Subject Dropdown
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
          Obx(() => controller.subjectError.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 5),
            child: Text(
              controller.subjectError.value,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          )
              : const SizedBox.shrink()),
          const SizedBox(height: 12),

          // 7. Services Dropdown
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
          Obx(() => controller.serviceError.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 5),
            child: Text(
              controller.serviceError.value,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          )
              : const SizedBox.shrink()),
          const SizedBox(height: 12),

          // 8. Work Type Dropdown
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
          Obx(() => controller.workTypeError.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 5),
            child: Text(
              controller.workTypeError.value,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          )
              : const SizedBox.shrink()),
          const SizedBox(height: 12),

          // 9. Select Urgency Dropdown
          Obx(() => TextFormFieldCustom(
            title: 'SELECT URGENCY',
            isRequired: true,
            method: CustomDropdown<UrgencyData>(
              valueListenable: controller.selectedUrgency,
              items: controller.urgencies,
              label: (u) => u.name,
              hint: controller.isLoading.value ? 'Loading...' : 'Select Urgency',
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
          Obx(() => controller.urgencyError.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 5),
            child: Text(
              controller.urgencyError.value,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          )
              : const SizedBox.shrink()),
          const SizedBox(height: 12),

          // 10. Word Count Dropdown
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
          Obx(() => controller.wordCountError.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 5),
            child: Text(
              controller.wordCountError.value,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          )
              : const SizedBox.shrink()),
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
}

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