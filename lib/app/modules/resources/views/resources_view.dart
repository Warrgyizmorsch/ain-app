import '../../../common/constant/app_imports.dart';
import '../../home/widget/grade_calculator_view.dart';
import '../../home/widget/notifications_view.dart';
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

              const SizedBox(height: 24),

              // --- Quick Tools Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Quick Tools',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
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
                    icon: Icons.text_snippet_outlined,
                    label: 'Word\nCounter',
                    iconColor: AppColors.primaryPurple,
                    iconBgColor: AppColors.primaryPurple.withValues(alpha: 0.15),
                    onTap: () => Get.to(() => const WordCounterView()),
                  ),

                ],
              ),

              const SizedBox(height: 24),



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
