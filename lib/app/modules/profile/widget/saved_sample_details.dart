import 'package:ain/app/common/constant/app_imports.dart';
import '../controllers/profile_controller.dart';

class SampleDetailsView extends GetView<ProfileController> {
  final dynamic sample;

  const SampleDetailsView({super.key, required this.sample});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar:   CustomAppBar(title: 'Sample Details'),
      body: SingleChildScrollView(
        padding:   EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding:   EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.circular(20),
                boxShadow:   [
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
                  Container(
                    padding:   EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      sample.categoryName ?? 'Category',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),

                    SizedBox(height: 16),

                  Text(
                    sample.title ?? 'No Title',
                    style: AppTextStyles.h2.copyWith(
                      fontSize: AppFontSize.s15,
                      height: 1.3,
                    ),
                  ),

                    SizedBox(height: 4),

                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding:   EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.bgLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:   Icon(
                              Icons.description_outlined,
                              color: AppColors.primaryPurple,
                              size: 16,
                            ),
                          ),
                            SizedBox(width: 8),
                          Text(
                            sample.typeName ?? 'Document',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                        Spacer(),

                      Row(
                        children: [
                            Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: AppColors.lightTextDisabled,
                          ),
                            SizedBox(width: 6),
                          Text(
                            _formatDate(sample.createdAt ?? ''),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.lightTextDisabled,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

              SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding:   EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.circular(20),
                boxShadow:   [
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
                    Text(
                    'About this Sample',
                    style: AppTextStyles.titleLarge,
                  ),
                    SizedBox(height: 16),

                  if (sample.metaTitle != null &&
                      sample.metaTitle.isNotEmpty) ...[
                    Text(
                      sample.metaTitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                      SizedBox(height: 8),
                  ],

                  Text(
                    (sample.metaDescription != null &&
                            sample.metaDescription.isNotEmpty)
                        ? sample.metaDescription
                        : 'No description available for this sample.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

              SizedBox(height: 24),

            Obx(() {
              if (controller.isLoadingDetails.value) {
                return   Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryPurple,
                    ),
                  ),
                );
              }

              final detail = controller.sampleDetail.value;

              if (detail == null) {
                return Center(
                  child: Column(
                    children: [
                        Text(
                        'Sample Content',
                        style: AppTextStyles.titleLarge,
                      ),
                        SizedBox(height: 8),
                      Text(
                        'Could not load full sample details.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                width: double.infinity,
                padding:   EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:   [
                    BoxShadow(
                      color: AppColors.lightShadow,
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                      'Sample Content',
                      style: AppTextStyles.titleLarge,
                    ),
                      SizedBox(height: 8),
                    _buildFormattedDescription(detail.description ),
                  ],
                ),
              );
            }),

              SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding:   EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration:   BoxDecoration(
            color: AppColors.bgLight,
            boxShadow: [
              BoxShadow(
                color: AppColors.lightShadow,
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon:   Icon(Icons.download_outlined, color: AppColors.white),
            label:   Text('Download Sample', style: AppTextStyles.button),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              padding:   EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildFormattedDescription(String text) {
    final List<String> lines = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.trim().isEmpty) {
          return   SizedBox(height: 12);
        }

        final bool isHeading =
            line.trim().endsWith('?') ||
            (!line.trim().endsWith('.') && line.length < 65);

        return Padding(
          padding:   EdgeInsets.only(bottom: 6.0),
          child: Text(
            line.trim(),
            style: isHeading
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                : AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateStr;
    }
  }
}
