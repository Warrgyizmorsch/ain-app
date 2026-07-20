import 'package:ain/app/common/constant/app_imports.dart';

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final Color bgColor;
  final IconData icon;
  final bool isRead;
  final bool isImportant;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.bgColor,
    required this.icon,
    this.isRead = true, // Default read
    this.isImportant = false, // Default not important
  });
}