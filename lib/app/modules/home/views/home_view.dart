import 'dart:async';
import 'dart:math';

import 'package:ain/app/modules/profile/widget/payment_history_view.dart';
import '../../../common/constant/app_imports.dart';
import '../../../core/models/order_now_model/order_list_model.dart';
import '../../assignments/controllers/assignments_controller.dart';
import '../../bottom_nav_bar/controllers/bottom_nav_bar_controller.dart';
import '../../profile/widget/saved_sample_widget.dart';
import '../controllers/home_controller.dart';
import '../widget/apa_generator_view.dart';
import '../widget/dissertation_planner_view.dart';
import '../widget/grade_calculator_view.dart';
import '../widget/notifications_view.dart';
import '../widget/plagiarism_checker_view.dart';
import '../widget/reference_generator_view.dart';
import '../widget/word_counter_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: AppColors.appBackground,
      drawer: const AppDrawer(),
      appBar: CustomAppBar(
        title: 'Home',
        showBackButton: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon:  Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () => controller.openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon:  Icon(
              Icons.notifications_none,
              color: AppColors.textPrimary,
              size: 28,
            ),
            onPressed: () {
              Get.to( NotificationsView());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.getGreeting(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  '${controller.username.value} 👋',
                  style: AppTextStyles.h2,
                ),
              ),

              const SizedBox(height: 24),
              const PromoBannerSlider(),
              const SizedBox(height: 32),
              Text('Quick Actions', style: AppTextStyles.titleLarge),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionItem(
                      icon: Icons.upload_file,
                      color: AppColors.primary,
                      title: 'Upload\nBrief',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionItem(
                      icon: Icons.chat_bubble_outline,
                      color: AppColors.warning,
                      title: 'Chat with\nExpert',
                      onTap: () {
                        Get.toNamed(Routes.CHAT);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionItem(
                      icon: Icons.screen_search_desktop_outlined,
                      color: AppColors.secondary,
                      title: 'View\nSamples',
                      onTap: () {
                        Get.to(const SavedSamplesView());
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionItem(
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppColors.success,
                      title: 'Make\nPayment',
                      onTap: () {
                        Get.to(PaymentHistoryView());
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Academic Tools', style: AppTextStyles.titleLarge),
                ],
              ),
              const SizedBox(height: 16),

              GridView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                children: [
                  _buildAcademicToolItem(
                    icon: Icons.calculate_outlined,
                    color: AppColors.warning,
                    title: 'Grade\nCalculator',
                    onTap: () {
                      Get.to(() => GradeCalculatorView());
                    },
                  ),
                  _buildAcademicToolItem(
                    icon: Icons.text_fields,
                    color: AppColors.primary,
                    title: 'APA\nGenerator',
                    onTap: () {
                      Get.to(() => const ApaGeneratorView());
                    },
                  ),
                  _buildAcademicToolItem(
                    icon: Icons.plagiarism_outlined,
                    color: AppColors.primary,
                    title: 'Plagiarism\nChecker',
                    onTap: () {
                      Get.to(() => PlagiarismCheckerView());
                    },
                  ),
                  _buildAcademicToolItem(
                    icon: Icons.format_list_numbered,
                    color: AppColors.primary,
                    title: 'Word\nCounter',
                    onTap: () {
                      Get.to(() =>  WordCounterView());
                    },
                  ),
                  _buildAcademicToolItem(
                    icon: Icons.library_books_outlined,
                    color: AppColors.success,
                    title: 'Reference\nGenerator',
                    onTap: () {
                      Get.to(() =>  ReferenceGeneratorView());
                    },
                  ),
                  _buildAcademicToolItem(
                    icon: Icons.edit_calendar_outlined,
                    color: AppColors.success,
                    title: 'Dissertation\nPlanner',
                    onTap: () {
                      Get.to(()=>DissertationPlannerView());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Progress',
                          style: AppTextStyles.subtitle.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'All Assignments',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'View Details',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.primary,
                              fontSize: AppFontSize.s13,
                              fontWeight: FontWeight.w600, // Capped at w600
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: 0.78,
                            strokeWidth: 8,
                            backgroundColor: AppColors.white.withValues(
                              alpha: 0.2,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.warning,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                          Center(
                            child: Text(
                              '78%',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Assignments', style: AppTextStyles.titleLarge),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to Assignments Tab/Page
                      // Example: Get.toNamed(Routes.ASSIGNMENTS);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'See All',
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.primary,
                        fontSize: AppFontSize.s12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              GetBuilder<AssignmentsController>(
                init: AssignmentsController(),
                builder: (assignController) {
                  return Obx(() {
                    if (assignController.isLoading.value) {
                      return  Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }

                    final top5Active = assignController.activeAssignments
                        .take(5)
                        .toList();

                    if (top5Active.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No active assignments for today.",
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: top5Active.length,
                      itemBuilder: (context, index) {
                        final item = top5Active[index];

                        if (item is Lead) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildLeadCard(item),
                          );
                        } else if (item is ConfirmedOrder) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildConfirmedCard(item),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  });
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadCard(Lead lead) {
    return _AssignmentCard(
      title: lead.service ?? "Assignment",
      subject: lead.subject ?? "General",
      dueDate: lead.deadline ?? "-",
      iconColor: AppColors.warning,
      iconBgColor: AppColors.warning.withValues(alpha: 0.1),
      statusType: AssignmentStatus.pending,
      daysLeft: 'Action Required',
    );
  }

  Widget _buildConfirmedCard(ConfirmedOrder order) {
    final bool isDelivered =
        order.deliveryDate != null &&
        order.deliveryDate!.toString().trim().isNotEmpty;

    return _AssignmentCard(
      title: order.title ?? order.subject ?? "Assignment",
      subject:
          order.moduleCode ??
          (isDelivered ? "Module Complete" : "Expert Working"),
      dueDate: order.deliveryDate ?? order.createdAt ?? "-",
      iconColor: isDelivered ? AppColors.success : AppColors.primary,
      iconBgColor: isDelivered
          ? AppColors.success.withValues(alpha: 0.1)
          : AppColors.tagBg,
      statusType: isDelivered
          ? AssignmentStatus.completed
          : AssignmentStatus.inProgress,
      progress: isDelivered ? null : 0.85,
      daysLeft: isDelivered ? null : 'In Progress',
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow:  [
          BoxShadow(
            color: AppColors.lightShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: AppFontSize.s10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcademicToolItem({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow:  [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  fontSize: AppFontSize.s11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AssignmentStatus { inProgress, completed, expertAssigned, pending }

class _AssignmentCard extends StatelessWidget {
  final String title;
  final String subject;
  final String dueDate;
  final Color iconColor;
  final Color iconBgColor;
  final AssignmentStatus statusType;
  final double? progress;
  final String? daysLeft;

  const _AssignmentCard({
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.iconColor,
    required this.iconBgColor,
    required this.statusType,
    this.progress,
    this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow:  [
          BoxShadow(
            color: AppColors.lightShadow,
            spreadRadius: 2,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subject, style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      'Due: $dueDate',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
               Icon(
                Icons.chevron_right,
                color: AppColors.lightTextHint,
                size: 20,
              ),
            ],
          ),
          if (statusType != AssignmentStatus.pending) ...[
            const SizedBox(height: 8),
            _buildStatusIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    switch (statusType) {
      case AssignmentStatus.inProgress:
        return Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress ?? 0.0,
                  minHeight: 6,
                  backgroundColor: AppColors.lightDivider,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.warning,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${((progress ?? 0) * 100).toInt()}%',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              daysLeft ?? '',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
          ],
        );

      case AssignmentStatus.completed:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Completed',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
            const Icon(Icons.check, color: AppColors.success, size: 18),
          ],
        );

      case AssignmentStatus.expertAssigned:
        return Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Expert Assigned',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.only(
                left: 8,
                top: 8,
                right: 0,
                bottom: 0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon:  Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                        size: 28,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  Image.asset(
                    ImageConstant.appLogo,
                    width: Get.width * 0.55,
                    height: 80,
                    fit: BoxFit
                        .contain, // Ensures the logo scales nicely without getting cropped
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _DrawerItem(
                      icon: Icons.home_outlined,
                      label: 'Home',
                      onTap: () => Get.back(),
                    ),
                    _DrawerItem(
                      icon: Icons.assignment_outlined,
                      label: 'My Assignments',
                      onTap: () {
                        Get.until(
                          (route) =>
                              route.settings.name == Routes.BOTTOM_NAV_BAR,
                        );
                        Get.find<BottomNavController>().changeTab(2);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.wallet,
                      label: 'Wallet',
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.WALLET);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.chat_bubble_outline,
                      label: 'Messages',
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.CHAT);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.radar,
                      label: 'Resources & Tools',
                      onTap: () => Get.toNamed(Routes.RESOURCES),
                    ),
                    _DrawerItem(
                      icon: Icons.person_outline,
                      label: 'Our Experts',
                      onTap: () => Get.toNamed(Routes.EXPERTS),
                    ),
                    _DrawerItem(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Payments',
                      onTap: () {
                        Get.back();
                        Get.to(() => PaymentHistoryView());
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.notifications_none,
                      label: 'Notifications',
                      onTap: () {
                        Get.to( NotificationsView());

                      },
                    ),
                    _DrawerItem(
                      icon: Icons.person_outline,
                      label: 'Profile',
                      onTap: () => Get.back(),
                    ),
                    _DrawerItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      onTap: () => Get.back(),
                    ),
                    _DrawerItem(
                      icon: Icons.help_outline,
                      label: 'Support Center',
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Help?',
                            style: AppTextStyles.subtitle.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'We are here for you!',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white70,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warning,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Contact Support',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Icon(
                        Icons.headset_mic,
                        color: AppColors.white,
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoBannerSlider extends StatefulWidget {
  const PromoBannerSlider({super.key});

  @override
  State<PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends State<PromoBannerSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.90);
  int _currentPage = 0;
  Timer? _timer;
  bool _isGoingForward = true;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_isGoingForward) {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _isGoingForward = false;
          _currentPage--;
        }
      } else {
        if (_currentPage > 0) {
          _currentPage--;
        } else {
          _isGoingForward = true;
          _currentPage++;
        }
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> slides = [
      _buildBannerCard(
        title: 'Get Up to ',
        highlight: '40% OFF\n',
        subtitle: 'On your first order',
        code: 'AIN40',
        icon: Icons.card_giftcard,
        iconColor: const Color(0xFFFFD54F),
        gradient: AppColors.primaryGradient,
      ),
      _buildBannerCard(
        title: 'Homework Help ',
        highlight: 'Flat 10% OFF\n',
        subtitle: 'Instant expert assistance',
        code: 'HW10',
        icon: Icons.menu_book_rounded,
        iconColor: AppColors.white,
        gradient: AppColors.discountGradient,
      ),
      _buildBannerCard(
        title: 'Connect & Save ',
        highlight: 'Extra 10% OFF\n',
        subtitle: 'Order via WhatsApp',
        code: 'WA10',
        icon: Icons.chat_bubble_rounded,
        iconColor: const Color(0xFFA5D6A7),
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                if (index == 2) _isGoingForward = false;
                if (index == 0) _isGoingForward = true;
              });
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = index - _pageController.page!;
                  } else {
                    value = (index - _currentPage).toDouble();
                  }
                  value = value.clamp(-1.0, 1.0);
                  final double depth = (1 - value.abs()) * 0.15;
                  final double scale = 0.85 + depth;
                  final double rotationY = value * (pi / 4);

                  return Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateY(rotationY)
                      ..scaleByDouble(scale, scale, scale, 1.0),
                    child: Opacity(
                      opacity: (1 - value.abs() * 0.4).clamp(0.4, 1.0),
                      child: child,
                    ),
                  );
                },
                child: slides[index],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCirc,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 6,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.lightDivider,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard({
    required String title,
    required String highlight,
    required String subtitle,
    required String code,
    required IconData icon,
    required Color iconColor,
    required Gradient gradient,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gradient.colors.first).withValues(alpha: 0.4),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: title),
                      TextSpan(
                        text: highlight,
                        // CAPPED AT w600
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: subtitle,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Use Code: $code',
                    style: AppTextStyles.caption.copyWith(
                      color: gradient.colors.last,
                      fontWeight: FontWeight.w600, // Capped at w600
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, size: 70, color: iconColor),
        ],
      ),
    );
  }
}
