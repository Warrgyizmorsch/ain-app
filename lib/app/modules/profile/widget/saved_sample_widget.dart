import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ain/app/common/constant/app_imports.dart';
import '../../../core/models/sample_model/samples_list_model.dart';
import '../controllers/profile_controller.dart';
import 'package:ain/app/modules/profile/widget/saved_sample_details.dart';

class SavedSamplesView extends GetView<ProfileController> {
  const SavedSamplesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Light background matching UI
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Saved Samples',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Add Search Logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Top Banner ---
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF311B6B), // Deep purple from UI
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF311B6B).withValues(alpha: 0.2),
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
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Access and manage your saved\nsamples anytime.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() => Text(
                          '${controller.sampleList.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        Text(
                          'Total Samples',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
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
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.folder, color: Color(0xFF9E86FF), size: 60),
                        Positioned(
                          top: 15,
                          child: Container(
                            width: 35,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.bookmark, color: Color(0xFF311B6B), size: 16),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4527A0) : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getCategoryIcon(catName),
                                size: 16,
                                color: isSelected ? const Color(0xFF4527A0) : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                catName,
                                style: TextStyle(
                                  color: isSelected ? const Color(0xFF4527A0) : Colors.black87,
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
                    child: CircularProgressIndicator(color: AppColors.primary),
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
                color: const Color(0xFFF3E5F5), // Light purple background
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.star_border, color: Color(0xFF4527A0), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Save time and stay organized',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your saved samples are secure and\navailable across all your devices.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4527A0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Explore Tools', style: TextStyle(color: Color(0xFF4527A0), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  IconData _getCategoryIcon(String catName) {
    if (catName.toLowerCase().contains('all')) return Icons.folder_outlined;
    if (catName.toLowerCase().contains('doc')) return Icons.description_outlined;
    if (catName.toLowerCase().contains('cit')) return Icons.format_quote_outlined;
    return Icons.grid_view;
  }

  Widget _buildDropdownButton({required IconData icon, required String label, bool isSort = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isSort) ...[
            Icon(icon, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 6),
          ],
          if (isSort) ...[
            Icon(icon, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey.shade700),
        ],
      ),
    );
  }

  Widget _buildPageBtn(dynamic content, {required bool isActive}) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4527A0) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isActive ? const Color(0xFF4527A0) : Colors.grey.shade300),
      ),
      child: content is String
          ? Text(
        content,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      )
          : Icon(
        content as IconData,
        size: 18,
        color: Colors.grey.shade600,
      ),
    );
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
    // Dynamic styles based on type/category matching the image UI
    final isCitation = type.toLowerCase().contains('citation');
    final isLink = type.toLowerCase().contains('link');

    final iconColor = isLink ? const Color(0xFF1976D2) : isCitation ? const Color(0xFF388E3C) : const Color(0xFF5E35B1);
    final bgColor = isLink ? const Color(0xFFE3F2FD) : isCitation ? const Color(0xFFE8F5E9) : const Color(0xFFEDE7F6);
    final iconData = isLink ? Icons.link : isCitation ? Icons.format_quote : Icons.description_outlined;

    // Fallback UI strings for date and word count (since they aren't in SampleItem in provided code)
    const mockDate = "May 12, 2025 • 10:30 AM";
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
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
              child: Icon(iconData, color: iconColor, size: 30),
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
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mockDate, // Replace with actual sample.date if available
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Word Count Badge
                      if (!isLink) // Links typically don't have word counts in the UI
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0), // Light orange
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Word Count: $mockWordCount',
                            style: const TextStyle(color: Color(0xFFE65100), fontSize: 9, fontWeight: FontWeight.w600),
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
                          style: TextStyle(color: iconColor, fontSize: 9, fontWeight: FontWeight.w600),
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