
import '../../../common/constant/app_imports.dart';
import '../../../core/models/notifications_model/get_notifications_model.dart';
import '../controllers/home_controller.dart';

class NotificationsView extends GetView<HomeController> {
    NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: 'Notifications',
        showBackButton: true,
      ),
      body: Column(
        children: [
            SizedBox(height: 16),
          _buildFilterTabs(),
            SizedBox(height: 16),

          Expanded(
            child: Obx(() {
              final list = controller.filteredNotifications;

              if (list.isEmpty) {
                return Center(
                  child: Text(
                    "No notifications found.",
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                  ),
                );
              }

              return ListView.separated(
                physics:   BouncingScrollPhysics(),
                padding:   EdgeInsets.symmetric(horizontal: 20),
                itemCount: list.length,
                separatorBuilder: (context, index) => Padding(
                  padding:   EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Colors.grey.shade200, height: 1, thickness: 1),
                ),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return _buildNotificationTile(item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding:   EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(
          controller.filters.length,
              (index) => Obx(() {
            final isSelected = controller.selectedFilterIndex.value == index;
            return Padding(
              padding:   EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => controller.setFilter(index),
                child: AnimatedContainer(
                  duration:   Duration(milliseconds: 200),
                  padding:   EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.filters[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem item) {
    return Padding(
      padding:   EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
            SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 15,
                        // Unread messages ka title thoda bold dikhega
                        fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    if (!item.isRead) ...[
                        SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration:   BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ]
                  ],
                ),
                  SizedBox(height: 4),
                Text(
                  item.message,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: item.isRead ? FontWeight.w400 : FontWeight.w500,
                    color: item.isRead ? Colors.grey.shade600 : Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
            SizedBox(width: 12),


          Text(
            item.time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}