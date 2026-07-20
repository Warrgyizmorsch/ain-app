import 'package:ain/app/common/constant/app_imports.dart';

class CustomNoDataWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final double? imageHeight;
  final VoidCallback? onRetry;

  const CustomNoDataWidget({
    super.key,
    this.title,
    this.subtitle,
    this.imageHeight = 200.0,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── No Data Image ──────────────────────────────────────────
            Image.asset(
              ImageConstant.noData,
              height: imageHeight,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>  Icon(
                Icons.hourglass_empty_rounded,
                size: 80,
                color: AppColors.lightDisabled,
              ),
            ),
            const SizedBox(height: 24),

            // ── Title ──────────────────────────────────────────────────
            Text(
              title ?? 'No Data Found',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // ── Subtitle ───────────────────────────────────────────────
            Text(
              subtitle ?? 'There is nothing to display at the moment.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // ── Custom Retry Button ────────────────────────────────────
            if (onRetry != null) ...[
              const SizedBox(height: 32),

              // Wraps your AppButton to prevent it from stretching full width
              // if you only want it to be button-sized
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: AppButton(
                  title: AppStrings.retry,
                  onTap: onRetry!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}