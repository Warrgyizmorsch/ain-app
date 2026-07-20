import '../../../common/constant/app_imports.dart';
import '../controllers/experts_controller.dart';
import '../widget/experts_profile_view.dart';

class ExpertsView extends GetView<ExpertsController> {
  const ExpertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const CustomAppBar(title: 'Our Experts', showBackButton: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightShadow,
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search experts...',
                  hintStyle: AppTextStyles.hintText.copyWith(
                    color: AppColors.lightTextHint,
                    fontSize: 15,
                  ),
                  prefixIcon:  Icon(
                    Icons.search,
                    color: AppColors.lightTextHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 40,
            child: Obx(() {
              final currentSelected = controller.selectedCategory.value;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];

                  final isSelected = currentSelected == category;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(
                        category,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        controller.changeCategory(category);
                      },
                      backgroundColor: AppColors.white,
                      selectedColor: AppColors.secondary,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.transparent
                              : AppColors.lightDivider,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      elevation: isSelected ? 2 : 0,
                      shadowColor: AppColors.secondary.withValues(alpha:0.4),
                    ),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: Obx(() {
              // LOADING CHECK
              if (controller.isLoading.value) {
                return  Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryPurple,
                  ),
                );
              }

              final experts = controller.filteredExperts;

              if (experts.isEmpty) {
                return Center(
                  child: Text(
                    'No experts found in this category.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: experts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final expert = experts[index];
                  return _ExpertCard(
                    name: expert.name ?? "Unknown",
                    expertise: expert.subject ?? "N/A",
                    rating: expert.successRate?.toString() ?? "0",
                    orders: expert.finishOrder?.toString() ?? "0",
                    imageUrl: expert.image ?? "",
                    onViewProfile: () {
                      Get.to(
                        () => const ExpertsProfileView(),
                        arguments: expert,
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ExpertCard extends StatelessWidget {
  final String name;
  final String expertise;
  final String rating;
  final String orders;
  final String imageUrl;
  final VoidCallback onViewProfile;

  const _ExpertCard({
    required this.name,
    required this.expertise,
    required this.rating,
    required this.orders,
    required this.imageUrl,
    required this.onViewProfile,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.appBackground,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null,
            child: imageUrl.isEmpty
                ?  Icon(Icons.person, color: AppColors.lightTextDisabled)
                : null,
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    fontSize: AppFontSize.s14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  expertise,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.warning, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "($orders Orders)",
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.lightTextDisabled,
                        fontSize: AppFontSize.s10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // View Profile Button
          OutlinedButton(
            onPressed: onViewProfile,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryPurple,
              side: BorderSide(color: AppColors.primaryPurple.withValues(alpha:0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'View Profile',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}