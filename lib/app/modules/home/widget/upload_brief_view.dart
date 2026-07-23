import 'dart:ui';
import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class UploadBriefView extends GetView<HomeController> {
  const UploadBriefView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = ThemeService.to.themeModeRx.value;

      return Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: CustomAppBar(
          title: 'Upload Brief',
          showBackButton: true,
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Banner ──────────────────────────────────────────────
              _buildBanner(),
              const SizedBox(height: 20),

              // ── Upload Section ──────────────────────────────────────────

                   _buildUploadBox(),
              const SizedBox(height: 16),
            Obx(() => controller.uploadedFileName.value.isEmpty?SizedBox.shrink()
                  : _buildUploadedFileCard()),
              const SizedBox(height: 24),

              // ── Project Details ─────────────────────────────────────────
              Text('Project Details', style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormFieldCustom(
                      title: 'Subject / Module',
                      hintTextSize: 13,
                      hintTextColor: AppColors.textPrimary,
                      method: _buildInput(
                        icon: Icons.menu_book_rounded,
                        hint: 'e.g., Marketing...',
                        controller: controller.subjectController,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormFieldCustom(
                      title: 'Assignment Title',
                      hintTextSize: 13,
                      hintTextColor: AppColors.textPrimary,
                      method: _buildInput(
                        icon: Icons.assignment_outlined,
                        hint: 'e.g., Market...',
                        controller: controller.titleController,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormFieldCustom(
                      title: 'Deadline',
                      hintTextSize: 13,
                      hintTextColor: AppColors.textPrimary,
                      method: _buildInput(
                        icon: Icons.calendar_today_outlined,
                        hint: 'Select date',
                        controller: controller.deadlineController,
                        isReadOnly: true,
                        onTap: () => controller.selectDeadline(context),
                        trailingIcon: Icons.calendar_today_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormFieldCustom(
                      title: 'Word Count',
                      hintTextSize: 13,
                      hintTextColor: AppColors.textPrimary,
                      method: _buildInput(
                        icon: Icons.looks_one_rounded,
                        hint: 'e.g., 2000',
                        controller: controller.wordCountController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormFieldCustom(
                title: 'Service Needed',
                hintTextSize: 13,
                hintTextColor: AppColors.textPrimary,
                method: _buildInput(
                  icon: Icons.work_outline,
                  hint: 'Select service type',
                  controller: controller.serviceController,
                  isReadOnly: true,
                  trailingIcon: Icons.keyboard_arrow_down,
                ),
              ),
              const SizedBox(height: 16),

              TextFormFieldCustom(
                title: 'Additional Instructions (Optional)',
                hintTextSize: 13,
                hintTextColor: AppColors.textPrimary,
                method: _buildInput(
                  icon: Icons.edit_note_outlined,
                  hint: 'Any specific requirements or notes for the expert...',
                  controller: controller.instructionsController,
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 24),

              // ── Urgency Level ───────────────────────────────────────────
              Text('Urgency Level', style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectableCard(
                      groupValue: controller.selectedUrgency,
                      value: 'Standard',
                      title: 'Standard',
                      subtitle: '3-5 days',
                      icon: Icons.access_time,
                      activeColor: AppColors.primary,
                      isColumnLayout: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSelectableCard(
                      groupValue: controller.selectedUrgency,
                      value: 'Priority',
                      title: 'Priority',
                      subtitle: '1-2 days',
                      icon: Icons.bolt,
                      activeColor: AppColors.warning,
                      isColumnLayout: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSelectableCard(
                      groupValue: controller.selectedUrgency,
                      value: 'Urgent',
                      title: 'Urgent',
                      subtitle: '< 24 hrs',
                      icon: Icons.local_fire_department_outlined,
                      activeColor: AppColors.error,
                      isColumnLayout: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Preferred Contact ───────────────────────────────────────
              Text('Preferred Contact', style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectableCard(
                      groupValue: controller.selectedContact,
                      value: 'Chat',
                      title: 'Chat',
                      icon: Icons.chat_bubble_outline,
                      activeColor: AppColors.primary,
                      isCompact: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSelectableCard(
                      groupValue: controller.selectedContact,
                      value: 'Email',
                      title: 'Email',
                      icon: Icons.mail_outline,
                      activeColor: AppColors.primary,
                      isCompact: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Security Notice ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.primary, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your files are secure',
                              style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600)), // Capped at w600
                          const SizedBox(height: 2),
                          Text('and only used for project review.',
                              style: AppTextStyles.caption.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Submit Button ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.submitBrief,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text('Submit Brief', style: AppTextStyles.button.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    });
  }

  // =========================================================================
  // UI COMPONENTS
  // =========================================================================

  // Helper method to provide TextFieldCustom to TextFormFieldCustom
  Widget _buildInput({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool isReadOnly = false,
    VoidCallback? onTap,
    IconData? trailingIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFieldCustom(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      textInputType: keyboardType,
      maxLines: maxLines,
      hintText: hint,
      hintTextSize: 13,
      hintTextColor: AppColors.lightTextHint,
      borderColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      borderWidth: 0,
      contentPadding: EdgeInsets.only(
        top: maxLines > 1 ? 16 : 14,
        bottom: 14,
        right: 12,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
      ),
      suffixIcon: trailingIcon != null
          ? Icon(trailingIcon, color: AppColors.textSecondary, size: 20)
          : null,
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF6A1B9A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload your\nassignment\nbrief',
                  style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 22, height: 1.2, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  'Share your file and\nproject details so our\nexpert can review it\nquickly.',
                  style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.85), height: 1.4, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Positioned(
                    right: 0,
                    top: 10,
                    child: Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 45, height: 4, color: Colors.grey.shade300, margin: const EdgeInsets.only(bottom: 8)),
                          Container(width: 45, height: 4, color: Colors.grey.shade300, margin: const EdgeInsets.only(bottom: 8)),
                          Container(width: 45, height: 4, color: Colors.grey.shade300),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFCA28),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox() {
    return InkWell(
      onTap: controller.pickFile,
      borderRadius: BorderRadius.circular(16),
      child: CustomPaint(
        painter: DashedRectPainter(color: AppColors.primaryPurple.withValues(alpha: 0.5), strokeWidth: 1.5, gap: 6.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.bgLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_upward, color: AppColors.primary, size: 28),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                  children: [
                    const TextSpan(text: 'Drag & drop or '),
                    TextSpan(
                      text: 'browse files',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: controller.pickFile,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: Text('Choose File', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              // Moved strictly BELOW the button
              Text('Supported: PDF, DOC, DOCX, JPG, PNG', style: AppTextStyles.caption.copyWith(fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadedFileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider, width: 1.0),
        boxShadow: [BoxShadow(color: AppColors.lightShadow.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.picture_as_pdf, color: Color(0xFFD32F2F), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.uploadedFileName.value,
                    style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(controller.uploadedFileSize.value, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.appBackground,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.close, color: AppColors.textPrimary, size: 20),
              onPressed: controller.removeFile,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableCard({
    required RxString groupValue,
    required String value,
    required String title,
    String? subtitle,
    required IconData icon,
    required Color activeColor,
    bool isCompact = false,
    bool isColumnLayout = false,
  }) {
    return Obx(() {
      final isSelected = groupValue.value == value;
      final Color currentColor = isSelected ? activeColor : AppColors.textSecondary;
      final Color bgColor = isSelected ? activeColor.withValues(alpha: 0.08) : AppColors.bgLight;
      final Color borderColor = isSelected ? activeColor : AppColors.lightDivider;

      return GestureDetector(
        onTap: () => groupValue.value = value,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: isCompact ? 14 : 16, horizontal: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
          ),
          child: isColumnLayout
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: currentColor, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: currentColor),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isSelected ? activeColor.withValues(alpha: 0.8) : AppColors.lightTextHint),
                ),
              ]
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, color: currentColor, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: currentColor),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// =========================================================================
// CUSTOM PAINTER FOR DASHED BORDER
// =========================================================================
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({this.color = Colors.black, this.strokeWidth = 1.0, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path();
    double radius = 16.0;

    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));

    Path dashPath = Path();
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(pathMetric.extractPath(distance, distance + gap), Offset.zero);
        distance += gap * 2;
      }
      distance = 0.0;
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}