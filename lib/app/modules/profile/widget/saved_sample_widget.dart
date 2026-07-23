import 'package:ain/app/common/constant/app_imports.dart';
import '../../../core/models/sample_model/samples_list_model.dart';
import '../controllers/profile_controller.dart';
import 'package:ain/app/modules/profile/widget/saved_sample_details.dart';

class SavedSamplesView extends GetView<ProfileController> {
  const SavedSamplesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: AppStrings.savedSamples,
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              // Add Search Logic
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Top Banner ---
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'All Your Saved Work',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Access and manage your saved\nsamples anytime.',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() => Text(
                          '${controller.sampleList.length}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        Text(
                          'Total Samples',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mock Illustration Box
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.folder, color: AppColors.white.withValues(alpha: 0.8), size: 60),
                        Positioned(
                          top: 15,
                          child: Container(
                            width: 35,
                            height: 25,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Divider(color: Colors.grey, thickness: 2, indent: 6, endIndent: 16, height: 6),
                                Divider(color: Colors.grey, thickness: 2, indent: 6, endIndent: 6, height: 6),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.bookmark, color: AppColors.primaryPurple, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. Category Chips (Horizontal) ---
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  final catName = category.name ?? 'Unknown';

                  return Obx(() {
                    final isSelected = controller.selectedCategory.value == catName;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () => controller.changeCategory(catName),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.bgLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryPurple : AppColors.lightDivider,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getCategoryIcon(catName),
                                size: 16,
                                color: isSelected ? AppColors.primaryPurple : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                catName,
                                style: TextStyle(
                                  color: isSelected ? AppColors.primaryPurple : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // --- 4. Main List View (Mobile Format) ---
            Obx(() {
              if (controller.isLoading.value) {
                return  Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: AppColors.primaryPurple),
                  ),
                );
              }

              final samples = controller.sampleList;

              if (samples.isEmpty) {
                return CustomNoDataWidget(
                  title: 'No Samples Found',
                  subtitle: 'Try adjusting your search or selecting a different category.',
                  onRetry: () => controller.changeCategory('All'),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Scroll handled by SingleChildScrollView
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: samples.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final sample = samples[index];
                  return _SampleCard(
                    title: sample.title,
                    type: sample.typeName,
                    category: sample.categoryName,
                    sample: sample,
                    controller: controller,
                  );
                },
              );
            }),

            const SizedBox(height: 16),
            // --- 6. Promotional Card ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tagBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.bgLight, shape: BoxShape.circle),
                    child: Icon(Icons.star_border, color: AppColors.primaryPurple, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Save time and stay organized',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your saved samples are secure and\navailable across all your devices.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text('Explore Tools', style: TextStyle(color: AppColors.primaryPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
    ],
  )));
  }

  // --- Helper Widgets ---

  IconData _getCategoryIcon(String catName) {
    if (catName.toLowerCase().contains('all')) return Icons.folder_outlined;
    if (catName.toLowerCase().contains('doc')) return Icons.description_outlined;
    if (catName.toLowerCase().contains('cit')) return Icons.format_quote_outlined;
    return Icons.grid_view;
  }
}

// ==========================================
// REDESIGNED SAMPLE CARD (MOBILE LIST VIEW)
// ==========================================

class _SampleCard extends StatelessWidget {
  final String title;
  final String type;
  final String category;
  final SampleItem sample;
  final ProfileController controller;

  const _SampleCard({
    required this.title,
    required this.type,
    required this.category,
    required this.sample,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic styles based on type/category matching theme palette
    final isCitation = type.toLowerCase().contains('citation');
    final isLink = type.toLowerCase().contains('link');

    final iconColor = isLink 
        ? AppColors.secondary 
        : isCitation 
            ? AppColors.statusGreen 
            : AppColors.primaryPurple;
            
    final bgColor = iconColor.withValues(alpha: 0.15);
    final iconData = isLink 
        ? Icons.link 
        : isCitation 
            ? Icons.format_quote 
            : Icons.description_outlined;

    final formattedDate = sample.createdAt.isNotEmpty 
        ? sample.createdAt.split('T')[0] 
        : "May 12, 2025";
    const mockWordCount = "2,450";

    return InkWell(
      onTap: () {
        controller.samplesDetails(slug: sample.slug);
        Get.to(() => SampleDetailsView(sample: sample));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightDivider),
          boxShadow:  [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Leading Icon ---
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, color: iconColor, size: 26),
            ),
            const SizedBox(width: 12),

            // --- Middle Details ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Word Count Badge
                      if (!isLink)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Word Count: $mockWordCount',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (!isLink) const SizedBox(width: 8),

                      // Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Type: $type',
                          style: TextStyle(
                            color: iconColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}