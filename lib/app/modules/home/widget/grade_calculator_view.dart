import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class GradeCalculatorView extends GetView<HomeController> {
    GradeCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(
          icon:   Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
        title:   Text(
          'Grade Calculator',
          style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18, // Slightly smaller for mobile
              fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:   Icon(Icons.history, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Mobile-optimized padding
        padding:   EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        physics:   BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Header Card
            _buildTopHeaderCard(),
              SizedBox(height: 24),

            // 2. Assessment Breakdown Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Expanded(
                  child: Text(
                    'Assessment Breakdown',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                  SizedBox(width: 8),
                Obx(() => Text(
                  'Total Weight: ${controller.totalWeight.toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPurple.withValues(alpha: 0.9)
                  ),
                )),
              ],
            ),
              SizedBox(height: 16),

            // 3. Dynamic Assessment Items (Mobile Layout)
            Obx(() {
              if (controller.assessments.isEmpty) {
                return   Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                      child: Text(
                          "No assessments added yet.",
                          style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w500)
                      )
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics:   NeverScrollableScrollPhysics(),
                itemCount: controller.assessments.length,
                separatorBuilder: (context, index) =>   SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.assessments[index];

                  Color tColor = AppColors.statusPurple;
                  Color tBgColor = AppColors.tagBg;
                  IconData icon = Icons.assignment_outlined;

                  if (item.type.toLowerCase() == 'exam') {
                    tColor = AppColors.statusOrange;
                    tBgColor = AppColors.statusOrange.withValues(alpha: 0.15);
                    icon = Icons.menu_book_outlined;
                  } else if (item.type.toLowerCase() == 'project') {
                    tColor = AppColors.statusGreen;
                    tBgColor = AppColors.statusGreen.withValues(alpha: 0.15);
                    icon = Icons.work_outline;
                  }

                  return _buildAssessmentCard(
                    title: item.title,
                    type: item.type,
                    typeColor: tColor,
                    typeBgColor: tBgColor,
                    icon: icon,
                    score: item.score.toStringAsFixed(0),
                    outOf: item.outOf.toStringAsFixed(0),
                    weight: '${item.weight.toStringAsFixed(0)}%',
                    onDelete: () => controller.removeAssessment(item.id),
                  );
                },
              );
            }),
              SizedBox(height: 16),

            // 4. Add Assessment Button (Dashed)
            _buildAddAssessmentButton(context),
              SizedBox(height: 24),

            // 5. Results Section
              Text(
              'Results',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark
              ),
            ),
              SizedBox(height: 16),
            _buildResultsGrid(),
              SizedBox(height: 24),

            // 6. What-if Target Card
            _buildWhatIfCard(),
              SizedBox(height: 24),

            // 7. Calculate Grade Button
            SizedBox(
              width: double.infinity,
              height: 52, // Mobile friendly height
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                      'Success',
                      'Grades calculated successfully!',
                      backgroundColor: AppColors.statusGreen,
                      colorText: AppColors.white
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child:   Text(
                    'Calculate Grade',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    )
                ),
              ),
            ),
              SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================

  Widget _buildTopHeaderCard() {
    return Container(
      padding:   EdgeInsets.all(16), // Adjusted for mobile
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 10,
              offset:   Offset(0, 4)
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:   EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14)),
            child:   Icon(Icons.calculate, color: AppColors.primaryPurple, size: 28),
          ),
            SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    'Track Your Course Grade',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    )
                ),
                  SizedBox(height: 4),
                Text(
                    'Add marks and instantly see your result',
                    style: TextStyle(color: AppColors.white70, fontSize: 12, fontWeight: FontWeight.w400)
                ),
                  SizedBox(height: 12),
                Container(
                  padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16)
                  ),
                  child: Obx(() => Text(
                    'Current Grade: ${controller.estimatedGrade} (${controller.currentPercentage.toStringAsFixed(1)}%)',
                    style:   TextStyle(
                        color: AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600
                    ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- MOBILE OPTIMIZED ASSESSMENT CARD ---
  Widget _buildAssessmentCard({
    required String title, required String type, required Color typeColor, required Color typeBgColor,
    required IconData icon, required String score, required String outOf, required String weight, required VoidCallback onDelete,
  }) {
    return Container(
      padding:   EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider, width: 1.0),
        boxShadow:   [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Icon Box
          Container(
            padding:   EdgeInsets.all(10),
            decoration: BoxDecoration(color: typeBgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: typeColor, size: 20),
          ),
            SizedBox(width: 12),

          // 2. Title & Badge (Flex 4 for mobile balance)
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    title,
                    style:   TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                ),
                  SizedBox(height: 4),
                Container(
                  padding:   EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: typeBgColor, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    type,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: typeColor
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 3. Stats (Flex evenly to prevent squishing)
          Expanded(flex: 2, child: _buildStatColumn('Score', score, isHighlighted: true)),
          Expanded(flex: 2, child: _buildStatColumn('Out of', outOf)),
          Expanded(flex: 2, child: _buildStatColumn('Weight', weight)),

          // 4. Menu
          SizedBox(
            width: 24, // Fixed small width for menu on mobile
            child: PopupMenuButton<String>(
              icon:   Icon(Icons.more_vert, color: AppColors.statusGrey, size: 18),
              padding: EdgeInsets.zero,
              onSelected: (value) {
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: AppColors.error))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, {bool isHighlighted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style:   TextStyle(
              fontSize: 10,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
          SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              fontSize: 13,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
              color: isHighlighted ? AppColors.textDark : AppColors.textDark
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Exact Match for dashed button in the image
  Widget _buildAddAssessmentButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Open the Add Assessment Bottom Sheet
        _showAddAssessmentBottomSheet(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: DashedRectPainter(
          color: AppColors.sectionTitleBorder,
          strokeWidth: 1.5,
          gap: 5.0,
          radius: 12.0,
        ),
        child: Container(
          width: double.infinity,
          padding:   EdgeInsets.symmetric(vertical: 14),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: AppColors.sectionTitleBorder, size: 18),
              SizedBox(width: 8),
              Text(
                  'Add Assessment',
                  style: TextStyle(
                      color: AppColors.sectionTitleBorder,
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showAddAssessmentBottomSheet(BuildContext context) {
    // Temporary controllers for the form
    final titleController = TextEditingController();
    final scoreController = TextEditingController();
    final outOfController = TextEditingController(text: '100'); // Default to 100
    final weightController = TextEditingController();
    final RxString selectedType = 'Homework'.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape:   RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Avoid keyboard overlap
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(
                    'Add Assessment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                  IconButton(
                    icon:   Icon(Icons.close, color: AppColors.textGrey),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
                SizedBox(height: 16),

              // 2. Title Field
              _buildSheetInputField(
                label: 'Assessment Title',
                hint: 'e.g., Quiz 1',
                controller: titleController,
              ),
                SizedBox(height: 16),

              // 3. Type Selector
                Text('Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textGrey)),
                SizedBox(height: 8),
              Obx(() => Row(
                children: [
                  _buildTypeChip('Homework', AppColors.statusPurple, AppColors.tagBg, selectedType),
                    SizedBox(width: 8),
                  _buildTypeChip('Exam', AppColors.statusOrange, AppColors.statusOrange.withValues(alpha: 0.15), selectedType),
                    SizedBox(width: 8),
                  _buildTypeChip('Project', AppColors.statusGreen, AppColors.statusGreen.withValues(alpha: 0.15), selectedType),
                ],
              )),
                SizedBox(height: 16),

              // 4. Score & Out Of Row
              Row(
                children: [
                  Expanded(
                    child: _buildSheetInputField(
                      label: 'Score',
                      hint: '0',
                      controller: scoreController,
                      isNumber: true,
                    ),
                  ),
                    SizedBox(width: 16),
                  Expanded(
                    child: _buildSheetInputField(
                      label: 'Out Of',
                      hint: '100',
                      controller: outOfController,
                      isNumber: true,
                    ),
                  ),
                ],
              ),
                SizedBox(height: 16),

              // 5. Weight Field
              _buildSheetInputField(
                label: 'Weight (%)',
                hint: 'e.g., 20',
                controller: weightController,
                isNumber: true,
              ),
                SizedBox(height: 24),

              // 6. Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Basic Validation
                    if (titleController.text.isEmpty || scoreController.text.isEmpty || weightController.text.isEmpty) {
                      Get.snackbar('Error', 'Please fill all required fields', backgroundColor: AppColors.error, colorText: AppColors.white);
                      return;
                    }

                    // Parse Data
                    final double score = double.tryParse(scoreController.text) ?? 0.0;
                    final double outOf = double.tryParse(outOfController.text) ?? 100.0;
                    final double weight = double.tryParse(weightController.text) ?? 0.0;

                    // Note: Update this to match the exact name of your Assessment model class!
                    // controller.addAssessment(Assessment(
                    //   id: DateTime.now().millisecondsSinceEpoch.toString(),
                    //   title: titleController.text,
                    //   type: selectedType.value,
                    //   score: score,
                    //   outOf: outOf,
                    //   weight: weight,
                    // ));

                    Get.back(); // Close Bottom Sheet
                    Get.snackbar(
                        'Added',
                        '${titleController.text} added successfully',
                        backgroundColor: AppColors.statusGreen,
                        colorText: AppColors.white
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child:   Text(
                    'Add to Calculator',
                    style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
                SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Helper for Input Fields inside the Bottom Sheet
  Widget _buildSheetInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style:   TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textGrey)),
          SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ?   TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          style:   TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:   TextStyle(fontSize: 14, color: AppColors.lightTextHint),
            filled: true,
            fillColor: AppColors.background,
            contentPadding:   EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   BorderSide(color: AppColors.primaryPurple, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // Helper for Type Selection Chips
  Widget _buildTypeChip(String title, Color activeColor, Color activeBgColor, RxString selectedType) {
    final isSelected = selectedType.value == title;
    return GestureDetector(
      onTap: () => selectedType.value = title,
      child: AnimatedContainer(
        duration:   Duration(milliseconds: 200),
        padding:   EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? activeColor : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
  Widget _buildResultsGrid() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildResultItem(
          icon: Icons.pie_chart_outline, iconColor: AppColors.statusPurple, bgColor: AppColors.tagBg,
          label: 'Current %', value: '${controller.currentPercentage.toStringAsFixed(1)}%',
        ),
        _buildResultItem(
          icon: null, gradeText: controller.estimatedGrade, iconColor: AppColors.statusGreen, bgColor: AppColors.statusGreen.withValues(alpha: 0.15),
          label: 'Est. Grade', value: controller.estimatedGrade,
        ),
        _buildResultItem(
          icon: Icons.bar_chart_rounded, iconColor: AppColors.statusOrange, bgColor: AppColors.statusOrange.withValues(alpha: 0.15),
          label: 'Weighted Score', value: '${controller.currentWeightedScore.toStringAsFixed(1)} / 100',
        ),
        _buildResultItem(
          icon: Icons.trending_up, iconColor: AppColors.primary, bgColor: AppColors.priceBg,
          label: 'Needed in\nRemaining',
          value: controller.totalWeight >= 100 ? 'N/A' : '${controller.neededInRemaining.toStringAsFixed(1)}%',
        ),
      ],
    ));
  }

  Widget _buildResultItem({
    IconData? icon, String? gradeText, required Color iconColor, required Color bgColor, required String label, required String value
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 42, width: 42, // Slightly smaller box for mobile
            alignment: Alignment.center,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: icon != null
                ? Icon(icon, color: iconColor, size: 20)
                : Text(
                gradeText ?? '',
                style: TextStyle(
                    color: iconColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                )
            ),
          ),
            SizedBox(height: 8),
          Text(
              label,
              textAlign: TextAlign.center,
              style:   TextStyle(fontSize: 10, color: AppColors.textGrey, height: 1.2, fontWeight: FontWeight.w500)
          ),
            SizedBox(height: 2),
          Text(
              value,
              textAlign: TextAlign.center,
              style:   TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark
              )
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIfCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
        boxShadow:   [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Column(
        children: [
          Padding(
            padding:   EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  padding:   EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
                  child:   Icon(Icons.track_changes, color: AppColors.primaryPurple, size: 22),
                ),
                  SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          'What-if Target',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark
                          )
                      ),
                        SizedBox(height: 4),
                      Text(
                          'Set a target grade and see\nwhat you need to achieve.',
                          style: TextStyle(fontSize: 10, color: AppColors.textGrey, height: 1.3, fontWeight: FontWeight.w500)
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.lightDivider), borderRadius: BorderRadius.circular(10)),
                  child: Obx(() => Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text('Target Grade', style: TextStyle(fontSize: 9, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                            SizedBox(height: 2),
                          Text(
                              '${controller.targetGradePercentage.toStringAsFixed(0)}%',
                              style:   TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark
                              )
                          ),
                        ],
                      ),
                        SizedBox(width: 6),
                        Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey, size: 18),
                    ],
                  )),
                )
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding:   EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration:   BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                  Icon(Icons.info_outline, color: AppColors.primaryPurple, size: 16),
                  SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    if (controller.totalWeight >= 100) {
                      return   Text(
                          "100% of weight is used. Target cannot be changed.",
                          style: TextStyle(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.w500)
                      );
                    }
                    return RichText(
                      text: TextSpan(
                        style:   TextStyle(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.w500),
                        children: [
                            TextSpan(text: 'You need '),
                          TextSpan(
                              text: '${controller.neededInRemaining.toStringAsFixed(1)}%',
                              style:   TextStyle(fontWeight: FontWeight.w600)
                          ),
                            TextSpan(text: ' in the remaining assessment to reach your target.'),
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

// Custom Painter to achieve the exact Dashed border from the image
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, x, y), Radius.circular(radius)));

    Path dashPath = Path();
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
      distance = 0.0; // Reset for next metric if any
    }
    canvas.drawPath(dashPath, dashedPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}