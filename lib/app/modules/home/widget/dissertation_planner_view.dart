import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class DissertationPlannerView extends GetView<HomeController> {
     DissertationPlannerView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(
          icon:    Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
        title:    Text(
          'Dissertation Planner',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600, // Capped at 600
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:    Icon(Icons.notifications_none, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics:    BouncingScrollPhysics(),
        padding:    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Navigation Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTopTab('Overview', Icons.grid_view),
                  _buildTopTab('Chapters', Icons.menu_book_outlined),
                  _buildTopTab('Tasks', Icons.check_box_outlined),
                  _buildTopTab('Timeline', Icons.calendar_today_outlined),
                ],
              ),
            ),
               SizedBox(height: 24),

            // 2. DYNAMIC TAB CONTENT SWITCHER
            Obx(() {
              final String currentTab = controller.selectedPlannerTab.value;

              switch (currentTab) {
                case 'Chapters':
                  return _buildChaptersTab();
                case 'Tasks':
                  return _buildTasksTab();
                case 'Timeline':
                  return _buildTimelineTab();
                case 'Overview':
                default:
                  return _buildOverviewTab();
              }
            }),

               SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB VIEWS (DYNAMIC CONTENT)
  // ==========================================

  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroBanner(),
           SizedBox(height: 24),

        // Overall Progress
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                   Icon(Icons.track_changes, color: AppColors.primaryPurple, size: 20),
                   SizedBox(width: 8),
                   Text(
                  'Overall Progress',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                     Text('Edit Goal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple)),
                     SizedBox(width: 4),
                     Icon(Icons.edit, color: AppColors.primaryPurple, size: 14),
                ],
              ),
            ),
          ],
        ),
           SizedBox(height: 12),
        _buildOverallProgressCard(),
           SizedBox(height: 28),

        // Chapter Progress (Horizontal summary)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
               Text('Chapter Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            InkWell(
              onTap: () => controller.setPlannerTab('Chapters'), // Route to Chapters tab
              child: Row(
                children: [
                     Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple)),
                     Icon(Icons.chevron_right, color: AppColors.primaryPurple, size: 16),
                ],
              ),
            ),
          ],
        ),
           SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(() => Row(
            children: controller.chapterProgressList.map((chapter) {
              Color color = _getStatusColor(chapter['status'] as String);
              IconData icon = _getStatusIcon(chapter['status'] as String);
              return _buildChapterCard(
                chapter['chapter'] as String,
                chapter['title'] as String,
                chapter['progress'] as double,
                color,
                icon,
              );
            }).toList(),
          )),
        ),
           SizedBox(height: 28),

        // Upcoming Tasks (Summary)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                   Icon(Icons.check_box_outlined, color: AppColors.textDark, size: 20),
                   SizedBox(width: 8),
                   Text('Upcoming Tasks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              ],
            ),
            InkWell(
              onTap: () => controller.setPlannerTab('Tasks'), // Route to Tasks tab
              child: Row(
                children: [
                     Text('View All Tasks', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple)),
                     Icon(Icons.chevron_right, color: AppColors.primaryPurple, size: 16),
                ],
              ),
            ),
          ],
        ),
           SizedBox(height: 12),
        _buildUpcomingTasksList(),
           SizedBox(height: 28),

        // Planning Tools
           Text('Planning Tools', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
           SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildToolCard('Task Manager', 'Organize tasks', Icons.checklist,    Color(0xFFF3E5F5), AppColors.primaryPurple),
              _buildToolCard('Timeline', 'View schedule', Icons.calendar_month,    Color(0xFFE8F5E9), AppColors.statusGreen),
              _buildToolCard('Milestones', 'Track goals', Icons.track_changes,    Color(0xFFE3F2FD),    Color(0xFF0288D1)),
              _buildToolCard('Notes', 'Add notes', Icons.note_alt_outlined,    Color(0xFFFFEBEE),    Color(0xFFE53935)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChaptersTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
           Text(
          'All Chapters',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
           SizedBox(height: 16),
        // Wrap creates a beautiful grid-like layout for mobile
        Obx(() => Wrap(
          spacing: 12,
          runSpacing: 16,
          children: controller.chapterProgressList.map((chapter) {
            Color color = _getStatusColor(chapter['status'] as String);
            IconData icon = _getStatusIcon(chapter['status'] as String);
            // Modified width for Wrap layout (half screen width minus padding)
            return SizedBox(
              width: (Get.width - 44) / 2,
              child: _buildChapterCard(
                chapter['chapter'] as String,
                chapter['title'] as String,
                chapter['progress'] as double,
                color,
                icon,
              ),
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildTasksTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
               Text(
              'All Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            Container(
              padding:    EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child:    Row(
                children: [
                  Icon(Icons.add, size: 16, color: AppColors.primaryPurple),
                  SizedBox(width: 4),
                  Text('Add Task', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple)),
                ],
              ),
            ),
          ],
        ),
           SizedBox(height: 16),
        _buildUpcomingTasksList(), // Reusing the same list component
      ],
    );
  }

  Widget _buildTimelineTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
           Text(
          'Project Timeline',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
           SizedBox(height: 16),
        Container(
          padding:    EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightDivider),
            boxShadow:    [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 1))],
          ),
          child: Obx(() => Column(
            children: controller.upcomingTasksList.asMap().entries.map((entry) {
              int idx = entry.key;
              var task = entry.value;
              bool isLast = idx == controller.upcomingTasksList.length - 1;
              return _buildTimelineItem(task, isLast);
            }).toList(),
          )),
        ),
      ],
    );
  }

  // ==========================================
  // HELPER WIDGETS & LOGIC
  // ==========================================

  Color _getStatusColor(String status) {
    if (status == 'completed') return AppColors.statusGreen;
    if (status == 'in_progress') return AppColors.primaryPurple;
    return AppColors.statusOrange;
  }

  IconData _getStatusIcon(String status) {
    if (status == 'completed') return Icons.check;
    if (status == 'in_progress') return Icons.edit;
    return Icons.access_time;
  }

  Widget _buildTopTab(String title, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedPlannerTab.value == title;
      return Padding(
        padding:    EdgeInsets.only(right: 8.0),
        child: InkWell(
          onTap: () => controller.setPlannerTab(title),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding:    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryPurple : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primaryPurple : AppColors.lightDivider,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: isSelected ? AppColors.white : AppColors.textGrey),
                   SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTimelineItem(Map<String, String> task, bool isLast) {
    Color pColor = AppColors.primaryPurple;
    if (task['priority'] == 'Medium') pColor = AppColors.statusOrange;
    if (task['priority'] == 'Low') pColor = AppColors.statusGreen;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column (Line and dot)
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: pColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                  boxShadow: [BoxShadow(color: pColor.withValues(alpha: 0.4), blurRadius: 4)],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.lightDivider,
                  ),
                ),
            ],
          ),
             SizedBox(width: 16),
          // Right column (Task Details)
          Expanded(
            child: Padding(
              padding:    EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['date']!,
                    style:    TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                  ),
                     SizedBox(height: 4),
                  Text(
                    task['title']!,
                    style:    TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                     SizedBox(height: 2),
                  Text(
                    task['subtitle']!,
                    style:    TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- EXISTING HELPERS (Unchanged functionality) ---

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding:    EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:    LinearGradient(
          colors: [Color(0xFF2A0845), Color(0xFF5E35B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color:    Color(0xFF5E35B1).withValues(alpha: 0.3),
            blurRadius: 12,
            offset:    Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   Text(
                  'Stay organized.\nMeet deadlines.',
                  style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600, height: 1.2),
                ),
                   SizedBox(height: 8),
                Text(
                  'Plan every step of your dissertation and achieve your goals.',
                  style: TextStyle(color: AppColors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w400, height: 1.3),
                ),
                   SizedBox(height: 16),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding:    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: AppColors.primaryPurple, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'New Dissertation',
                          style: TextStyle(color: AppColors.primaryPurple, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
             SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:    Icon(Icons.library_books, color: AppColors.white, size: 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgressCard() {
    return Container(
      padding:    EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightDivider),
        boxShadow:    [BoxShadow(color: AppColors.lightShadow, blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Obx(() => CircularProgressIndicator(
                  value: controller.plannerOverallProgress.value,
                  strokeWidth: 8,
                  backgroundColor: AppColors.lightDivider.withValues(alpha: 0.5),
                  color: AppColors.primaryPurple,
                  strokeCap: StrokeCap.round,
                )),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => Text(
                        '${(controller.plannerOverallProgress.value * 100).toInt()}%',
                        style:    TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                      )),
                         Text(
                        'Completed',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
             SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => _buildProgressStat(Icons.article_outlined, AppColors.primaryPurple, 'Chapters', '${controller.plannerChaptersCompleted.value} / ${controller.plannerTotalChapters.value}', 'Completed')),
                    Obx(() => _buildProgressStat(Icons.check_box_outlined, AppColors.statusGreen, 'Tasks', '${controller.plannerTasksCompleted.value} / ${controller.plannerTotalTasks.value}', 'Completed')),
                  ],
                ),
                   SizedBox(height: 12),
                Divider(height: 1, color: AppColors.lightDivider.withValues(alpha: 0.5)),
                   SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => _buildProgressStat(Icons.calendar_today,    Color(0xFF0288D1), 'Days Left', '${controller.plannerDaysLeft.value}', 'Until Deadline')),
                    Obx(() => _buildProgressStat(Icons.flag_outlined, AppColors.statusOrange, 'Deadline', controller.plannerDeadlineDate.value, controller.plannerDeadlineDay.value)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(IconData icon, Color color, String title, String value, String subtitle) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
                 SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style:    TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
             SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
          ),
          Text(
            subtitle,
            style:    TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(String chapter, String title, double progress, Color color, IconData icon) {
    return Container(
      width: 140, // Keeps fixed width for uniform look in both Horizontal Scroll and Wrap
      margin:    EdgeInsets.only(right: 12),
      padding:    EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
        boxShadow:    [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding:    EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
             SizedBox(height: 12),
          Text(
            chapter,
            style:    TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
          ),
             SizedBox(height: 4),
          Text(
            title,
            style:    TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
             SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.lightDivider,
                    color: color,
                    minHeight: 6,
                  ),
                ),
              ),
                 SizedBox(width: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildUpcomingTasksList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
      ),
      child: Obx(() => Column(
        children: controller.upcomingTasksList.asMap().entries.map((entry) {
          int idx = entry.key;
          var task = entry.value;

          Color pColor = AppColors.primaryPurple;
          if (task['priority'] == 'High') pColor = AppColors.primaryPurple;
          if (task['priority'] == 'Medium') pColor = AppColors.statusOrange;
          if (task['priority'] == 'Low') pColor = AppColors.statusGreen;

          return Column(
            children: [
              _buildTaskItem(task['title']!, task['subtitle']!, task['date']!, task['daysLeft']!, task['priority']!, pColor),
              if (idx < controller.upcomingTasksList.length - 1)
                Divider(height: 1, color: AppColors.lightDivider.withValues(alpha: 0.5)),
            ],
          );
        }).toList(),
      )),
    );
  }

  Widget _buildTaskItem(String title, String subtitle, String date, String daysLeft, String priority, Color priorityColor) {
    return Padding(
      padding:    EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
             Icon(Icons.circle_outlined, color: AppColors.primaryPurple, size: 22),
             SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style:    TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                   SizedBox(height: 4),
                Text(subtitle, style:    TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
             SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                     Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textGrey),
                     SizedBox(width: 4),
                  Text(date, style:    TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                ],
              ),
                 SizedBox(height: 2),
              Text(daysLeft, style:    TextStyle(fontSize: 10, color: AppColors.statusOrange, fontWeight: FontWeight.w500)),
                 SizedBox(height: 6),
              Container(
                padding:    EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: priorityColor),
                ),
                child: Text(priority, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: priorityColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(String title, String subtitle, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 120,
      margin:    EdgeInsets.only(right: 12),
      padding:    EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
        boxShadow:    [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding:    EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
             SizedBox(height: 12),
          Text(title, style:    TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark), textAlign: TextAlign.center),
             SizedBox(height: 4),
          Text(subtitle, style:    TextStyle(fontSize: 10, color: AppColors.textGrey), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}