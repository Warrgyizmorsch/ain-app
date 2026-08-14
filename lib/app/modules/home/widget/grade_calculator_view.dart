import 'dart:ui';

import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class GradeCalculatorView extends GetView<HomeController> {
  const GradeCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: 'Grade Calculator',
        showBackButton: true,

      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Header Card
                _buildTopHeaderCard(),
                const SizedBox(height: 24),

                // 2. Table Headers (RapidTables Style)
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Assignment (opt)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Text('Grade (%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Text('Weight (%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 40), // Spacing for delete icon
                  ],
                ),
                const SizedBox(height: 12),

                // 3. Dynamic Assessment Input Rows
                Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.gradeRows.length,
                  itemBuilder: (context, index) {
                    final row = controller.gradeRows[index];
                    return _buildInputRow(row, index);
                  },
                )),
                const SizedBox(height: 8),

                // 4. Add Row Button
                _buildAddRowButton(),
                const SizedBox(height: 24),

                // 5. Action Buttons (Calculate & Clear)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus(); // Close keyboard
                          controller.showGradeResults.value = true;
                          controller.gradeRows.refresh(); // Force math update
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Calculate', style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          controller.clearGrades();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryPurple, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Clear', style: TextStyle(color: AppColors.primaryPurple, fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 6. Results & What-If Sections (Visible only after Calculate)
                Obx(() {
                  if (!controller.showGradeResults.value) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Results', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 16),
                      _buildResultsGrid(),
                      const SizedBox(height: 24),
                      // _buildWhatIfCard(),
                    ],
                  );
                }),

                const SizedBox(height: 100),
              ],
            ),
          ),
          const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
        ],
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================

  Widget _buildTopHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.calculate, color: AppColors.primaryPurple, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Track Your Course Grade',
                  style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Add marks and instantly see your result',
                  style: TextStyle(color: AppColors.white70, fontSize: 12, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                  child: Obx(() => Text(
                    'Current Grade: ${controller.estimatedGrade} (${controller.currentPercentage.toStringAsFixed(1)}%)',
                    style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(AssessmentRowData row, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Assignment Name
          Expanded(
            flex: 3,
            child: _buildTextField(row.nameCtrl, 'Assignment ${index + 1}'),
          ),
          const SizedBox(width: 8),
          // Grade
          Expanded(
            flex: 2,
            child: _buildTextField(row.gradeCtrl, '100', isNumber: true, onChanged: (_) {
              if (controller.showGradeResults.value) controller.gradeRows.refresh();
            }),
          ),
          const SizedBox(width: 8),
          // Weight
          Expanded(
            flex: 2,
            child: _buildTextField(row.weightCtrl, '20', isNumber: true, onChanged: (_) {
              if (controller.showGradeResults.value) controller.gradeRows.refresh();
            }),
          ),
          // Delete Button
          SizedBox(
            width: 40,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.remove_circle_outline, color: AppColors.error, size: 22),
              onPressed: () {
                controller.removeGradeRow(row.id);
                if (controller.showGradeResults.value) controller.gradeRows.refresh();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, {bool isNumber = false, Function(String)? onChanged}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightDivider),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        onChanged: onChanged,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.lightTextHint, fontSize: 12),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildAddRowButton() {
    return InkWell(
      onTap: controller.addGradeRow,
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: DashedRectPainter(
          color: AppColors.primaryPurple,
          strokeWidth: 1.5,
          gap: 5.0,
          radius: 12.0,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.primaryPurple, size: 18),
              const SizedBox(width: 8),
              Text(
                'Add Row',
                style: TextStyle(color: AppColors.primaryPurple, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildResultItem(
          icon: Icons.pie_chart_outline, iconColor: AppColors.primaryPurple, bgColor: AppColors.primaryPurple.withValues(alpha: 0.15),
          label: 'Current %', value: '${controller.currentPercentage.toStringAsFixed(1)}%',
        ),
        _buildResultItem(
          icon: null, gradeText: controller.estimatedGrade, iconColor: AppColors.statusGreen, bgColor: AppColors.statusGreen.withValues(alpha: 0.15),
          label: 'Est. Grade', value: controller.estimatedGrade,
        ),
        _buildResultItem(
          icon: Icons.bar_chart_rounded, iconColor: AppColors.secondary, bgColor: AppColors.secondary.withValues(alpha: 0.15),
          label: 'Weighted Score', value: '${controller.currentWeightedScore.toStringAsFixed(1)} pts',
        ),
        _buildResultItem(
          icon: Icons.trending_up, iconColor: AppColors.primaryPurple, bgColor: AppColors.primaryPurple.withValues(alpha: 0.15),
          label: 'Total Weight',
          value: '${controller.totalWeight.toStringAsFixed(0)}%',
        ),
      ],
    );
  }

  Widget _buildResultItem({IconData? icon, String? gradeText, required Color iconColor, required Color bgColor, required String label, required String value}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 42, width: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: icon != null
                ? Icon(icon, color: iconColor, size: 20)
                : Text(gradeText ?? '', style: TextStyle(color: iconColor, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.2, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildWhatIfCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.track_changes, color: AppColors.primaryPurple, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('What-if Target', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('Target grade to achieve.', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.3, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                // RapidTables style editable Target Grade input
                SizedBox(
                  width: 65,
                  height: 36,
                  child: TextField(
                    controller: controller.targetGradeCtrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    onChanged: (_) => controller.gradeRows.refresh(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.lightDivider)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.primaryPurple)),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text('%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primaryPurple, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    if (controller.totalWeight >= 100) {
                      return Text("100% of weight is used. Target cannot be changed.", style: TextStyle(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.w500));
                    }
                    if (controller.neededInRemaining > 100) {
                      return Text("Target is mathematically impossible to reach.", style: TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w500));
                    }
                    return RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.w500),
                        children: [
                          const TextSpan(text: 'You need '),
                          TextSpan(text: '${controller.neededInRemaining.toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(text: ' in the remaining assessment to reach your target.'),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Custom Painter (Unchanged)
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedRectPainter({required this.color, required this.strokeWidth, required this.gap, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()..color = color..strokeWidth = strokeWidth..style = PaintingStyle.stroke;
    double x = size.width;
    double y = size.height;
    Path path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, x, y), Radius.circular(radius)));
    Path dashPath = Path();
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(pathMetric.extractPath(distance, distance + gap), Offset.zero);
        distance += gap * 2;
      }
      distance = 0.0;
    }
    canvas.drawPath(dashPath, dashedPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}