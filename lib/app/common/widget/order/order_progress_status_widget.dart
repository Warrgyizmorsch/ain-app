import 'package:flutter/material.dart';
import '../../constant/app_colors.dart';

/// Checks if an order is overdue based on its delivery date and status.
///
/// Rules:
/// 1. If dateString is null or empty, returns false.
/// 2. If status is "completed", "delivered", or "cancelled", returns false.
/// 3. Sets deadline to the end of the day (23:59:59.999) to avoid false flags.
/// 4. Checks if deadline < current date/time.
bool isOrderOverdue(String? dateString, String? status) {
  if (dateString == null || dateString.trim().isEmpty) return false;

  final String s = (status ?? '').toLowerCase().trim();

  // If the order is already finished or cancelled, it cannot be overdue
  if (s == 'completed' || s == 'delivered' || s == 'cancelled') return false;

  DateTime? deliveryDate = DateTime.tryParse(dateString.trim());

  if (deliveryDate == null) {
    try {
      final clean = dateString.trim();
      if (clean.contains('/')) {
        final parts = clean.split('/');
        if (parts.length == 3) {
          if (parts[0].length == 4) {
            // yyyy/MM/dd
            deliveryDate = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
          } else {
            // dd/MM/yyyy
            deliveryDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          }
        }
      } else if (clean.contains('-')) {
        final parts = clean.split('-');
        if (parts.length == 3) {
          if (parts[0].length == 4) {
            // yyyy-MM-dd
            deliveryDate = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
          } else {
            // dd-MM-yyyy
            deliveryDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          }
        }
      }
    } catch (_) {
      return false;
    }
  }

  if (deliveryDate == null) return false;

  // Set the delivery date time to the end of the day to avoid false flags
  final DateTime endOfDayDeadline = DateTime(
    deliveryDate.year,
    deliveryDate.month,
    deliveryDate.day,
    23,
    59,
    59,
    999,
  );

  // Check if that deadline has passed compared to the current date/time
  return endOfDayDeadline.isBefore(DateTime.now());
}

/// Circular Progress component for Order list and Order details.
class CircularProgress extends StatelessWidget {
  final int progress;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;

  const CircularProgress({
    super.key,
    required this.progress,
    this.size = 38.0,
    this.strokeWidth = 3.5,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final int clampedProgress = progress.clamp(0, 100);
    final double value = clampedProgress / 100.0;
    final bool isCompleted = clampedProgress >= 100;

    final Color effectiveColor = progressColor ??
        (isCompleted ? AppColors.statusGreen : AppColors.primaryPurple);
    final Color effectiveTrack = backgroundColor ?? AppColors.lightDivider;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: strokeWidth,
              backgroundColor: effectiveTrack,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            '$clampedProgress%',
            style: TextStyle(
              fontSize: size * 0.26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget matching the Web table cell order status & progress indicator logic:
///
/// FLAG 1: Cancelled -> Blank dash (—)
/// FLAG 2: Completed / Delivered -> Force progress to 100%
/// FLAG 3: Active but Past Deadline -> Red Overdue Badge with alert icon
/// FLAG 4: Normal Active Order -> Circular progress with actual percentage
class OrderProgressStatusWidget extends StatelessWidget {
  final String? status;
  final String? deliveryDate;
  final int? progressPercentage;
  final double size;

  const OrderProgressStatusWidget({
    super.key,
    required this.status,
    required this.deliveryDate,
    required this.progressPercentage,
    this.size = 46.0,
  });

  @override
  Widget build(BuildContext context) {
    final String s = (status ?? '').toLowerCase().trim();

    // FLAG 1: If Cancelled -> Show a blank dash
    if (s == 'cancelled' || s == 'canceled') {
      return const Text(
        '—',
        style: TextStyle(
          color: Color(0xFF9CA3AF), // text-gray-400
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      );
    }

    // FLAG 2: If Completed/Delivered -> Force progress to 100%
    if (s == 'completed' || s == 'delivered') {
      return CircularProgress(
        progress: 100,
        size: size,
      );
    }

    // FLAG 3: If Active but Past Deadline -> Show Red Overdue Badge
    if (isOrderOverdue(deliveryDate, status)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2), // bg-red-50
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFFEE2E2), width: 1), // border-red-100
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 13,
              color: Color(0xFFDC2626), // text-red-600
            ),
            SizedBox(width: 4),
            Text(
              'OVERDUE',
              style: TextStyle(
                color: Color(0xFFDC2626), // text-red-600
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      );
    }

    // FLAG 4: Normal Active Order -> Show actual API progress percentage (fallback to 0)
    return CircularProgress(
      progress: progressPercentage ?? 0,
      size: size,
    );
  }
}

/// Web-matching Status Badges (Pending, Processing, Completed, Cancelled)
class OrderStatusBadgeWidget extends StatelessWidget {
  final String? status;
  final double fontSize;

  const OrderStatusBadgeWidget({
    super.key,
    required this.status,
    this.fontSize = 11.0,
  });

  @override
  Widget build(BuildContext context) {
    final String s = (status ?? '').toLowerCase().trim();

    Color bgColor;
    Color borderColor;
    Color textColor;
    String label;
    Widget icon;

    if (s == 'completed' || s == 'delivered' || s == 'done' || s == 'finish' || s == 'finished') {
      // Completed Badge (Green)
      bgColor = const Color(0xFFECFDF5);
      borderColor = const Color(0xFFA7F3D0);
      textColor = const Color(0xFF047857);
      label = "Completed";
      icon = const Icon(Icons.check_rounded, size: 13, color: Color(0xFF047857));
    } else if (s == 'cancelled' || s == 'canceled' || s == 'rejected') {
      // Cancelled Badge (Red)
      bgColor = const Color(0xFFFEF2F2);
      borderColor = const Color(0xFFFECACA);
      textColor = const Color(0xFFB91C1C);
      label = "Cancelled";
      icon = const Icon(Icons.close_rounded, size: 12, color: Color(0xFFB91C1C));
    } else if (s == 'pending' || s == 'unconfirmed' || s == 'draft') {
      // Pending Badge (Amber/Yellow with hourglass icon)
      bgColor = const Color(0xFFFFFBEB);
      borderColor = const Color(0xFFFDE68A);
      textColor = const Color(0xFFB45309);
      label = "Pending";
      icon = const Icon(Icons.hourglass_top_rounded, size: 12, color: Color(0xFFB45309));
    } else {
      // Processing Badge (Blue with dot)
      bgColor = const Color(0xFFEFF6FF);
      borderColor = const Color(0xFFBFDBFE);
      textColor = const Color(0xFF1D4ED8);
      label = "Processing";
      icon = Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: const BoxDecoration(
          color: Color(0xFF2563EB),
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
