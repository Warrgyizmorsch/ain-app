import '../../../common/constant/app_imports.dart';
import '../../home/widget/apa_generator_view.dart';
import '../../home/widget/dissertation_planner_view.dart';
import '../../home/widget/grade_calculator_view.dart';
import '../../home/widget/notifications_view.dart';
import '../../home/widget/plagiarism_checker_view.dart';
import '../../home/widget/reference_generator_view.dart';
import '../../home/widget/word_counter_view.dart';

class ResourcesView extends StatelessWidget {
  const ResourcesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: 'Resources & Tools',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: AppColors.textPrimary, size: 26),
            onPressed: () {
              Get.to(() => NotificationsView());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Search Bar ---
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(30), // Pill-shaped
                  border: Border.all(color: AppColors.lightDivider),
                ),
                child: TextField(
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search resources or tools...',
                    hintStyle: TextStyle(color: AppColors.lightTextHint, fontSize: 15),
                    prefixIcon: Icon(Icons.search, color: AppColors.lightTextHint),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Quick Tools Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Tools',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- Quick Tools Grid ---
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  _ToolCard(
                    icon: Icons.calculate_outlined,
                    label: 'Grade\nCalculator',
                    iconColor: AppColors.primaryPurple,
                    iconBgColor: AppColors.primaryPurple.withValues(alpha: 0.15),
                    onTap: () => Get.to(() => const GradeCalculatorView()),
                  ),
                  _ToolCard(
                    icon: Icons.assignment_outlined,
                    label: 'APA\nGenerator',
                    iconColor: AppColors.primaryPurple,
                    iconBgColor: AppColors.primaryPurple.withValues(alpha: 0.15),
                    onTap: () => Get.to(() => const ApaGeneratorView()),
                  ),
                  _ToolCard(
                    icon: Icons.plagiarism_outlined,
                    label: 'Plagiarism\nChecker',
                    iconColor: AppColors.statusGreen,
                    iconBgColor: AppColors.statusGreen.withValues(alpha: 0.15),
                    onTap: () => Get.to(() => const PlagiarismCheckerView()),
                  ),
                  _ToolCard(
                    icon: Icons.text_snippet_outlined,
                    label: 'Word\nCounter',
                    iconColor: AppColors.primaryPurple,
                    iconBgColor: AppColors.primaryPurple.withValues(alpha: 0.15),
                    onTap: () => Get.to(() => const WordCounterView()),
                  ),
                  _ToolCard(
                    icon: Icons.format_quote_outlined,
                    label: 'Reference\nGenerator',
                    iconColor: AppColors.secondary,
                    iconBgColor: AppColors.secondary.withValues(alpha: 0.15),
                    onTap: () => Get.to(() => const ReferenceGeneratorView()),
                  ),
                  _ToolCard(
                    icon: Icons.event_note_outlined,
                    label: 'Dissertation\nPlanner',
                    iconColor: AppColors.statusGreen,
                    iconBgColor: AppColors.statusGreen.withValues(alpha: 0.15),
                    onTap: () => Get.to(() => const DissertationPlannerView()),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Bottom Upgrade Banner ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upgrade Your Academic\nPerformance',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              height: 1.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Explore our expert tools',
                            style: TextStyle(
                              color: AppColors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.primaryPurple,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Explore Now',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.rocket_launch,
                          color: AppColors.secondary,
                          size: 80,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
    ],
  )));
  }
}

// ── Custom Widget for the Quick Tool Grid Cards ─────────────────────────
class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightDivider),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon inside tinted container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const Spacer(),
                // Label text
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}