import '../../../common/constant/app_imports.dart';
import '../../../core/models/experts_model/experts_list_response_model.dart';

class ExpertsProfileView extends StatelessWidget {
  const ExpertsProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpertData expert = Get.arguments as ExpertData;
    final int reviewCount = expert.customerReview?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const CustomAppBar(
        title: "Expert Profile",
        showBackButton: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Hire ${expert.name?.split(' ').first ?? 'Expert'} Now",
              style: AppTextStyles.button,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryPurple.withValues(alpha:0.2), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.appBackground,
                        backgroundImage: expert.image != null && expert.image!.isNotEmpty
                            ? NetworkImage(expert.image!)
                            : null,
                        child: expert.image == null || expert.image!.isEmpty
                            ?  Icon(Icons.person, size: 40, color: AppColors.lightTextDisabled)
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: AppColors.success,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expert.name ?? "Unknown Expert",
                        style: AppTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: AppFontSize.s18,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          (expert.subject ?? "Expert").toUpperCase(),
                          style: AppTextStyles.overline.copyWith(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.warning, size: 16),
                          const Icon(Icons.star, color: AppColors.warning, size: 16),
                          const Icon(Icons.star, color: AppColors.warning, size: 16),
                          const Icon(Icons.star, color: AppColors.warning, size: 16),
                          const Icon(Icons.star_half, color: AppColors.warning, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "${expert.successRate ?? 0.0}",
                            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "($reviewCount Reviews)",
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _buildStatBox("${expert.finishOrder ?? 0}+", "ORDERS", Colors.purple.shade100, Colors.purple.shade700)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatBox("${expert.inprogressOrder ?? 0}", "IN PROGRESS", Colors.blue.shade100, Colors.blue.shade700)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatBox("$reviewCount", "REVIEWS", Colors.green.shade100, Colors.green.shade700)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                      expert.location ?? "N/A",
                      "LOCATION",
                      Colors.orange.shade100,
                      Colors.orange.shade800,
                      icon: Icons.location_on_outlined
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: _buildStatBox("${expert.successRate ?? 0}%", "SUCCESS RATE", Colors.purple.shade100, AppColors.primaryPurple)),
              ],
            ),

            const SizedBox(height: 16),

            if (expert.skills != null && expert.skills!.isNotEmpty) ...[
              _buildSectionTitle(Icons.workspace_premium_outlined, "Skills & Expertise"),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: expert.skills!.map((e) => _buildDarkPill(e)).toList(),
              ),
              const SizedBox(height: 16),
            ],

            if (expert.helpus != null && expert.helpus!.isNotEmpty) ...[
              _buildSectionTitle(Icons.menu_book_outlined, "Helps With"),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: expert.helpus!.map((e) => _buildDarkPill(e,)).toList(),
              ),
              const SizedBox(height: 16),
            ],

            _buildSectionTitle(Icons.person_outline, "About ${expert.name?.split(' ').first ?? 'Expert'}"),
            _buildFormattedDescription(expert.description ?? "No description available for this expert."),

            const SizedBox(height: 16),

            Text(
              "Credentials & Background",
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCredentialBox(Icons.school_outlined, "EXPERTISE", expert.subject ?? "N/A"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCredentialBox(Icons.design_services_outlined, "SERVICE", expert.service ?? "N/A"),
                ),
              ],
            ),

            const SizedBox(height: 32),

            if (expert.customerReview != null && expert.customerReview!.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.warning, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Student Reviews",
                        style: AppTextStyles.titleLarge,
                      ),
                    ],
                  ),
                  Text(
                    "${expert.successRate ?? 0.0} ($reviewCount Reviews)",
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...expert.customerReview!.map((review) => _buildReviewCard(review)),
            ],

            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }


  Widget _buildStatBox(String value, String label, Color borderColor, Color valueColor, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: valueColor),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.overline.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primaryPurple),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyles.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDarkPill(String label, {bool isDarker = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarker ? AppColors.primary : AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCredentialBox(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightDivider),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange.shade300, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.overline.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(CustomerReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${review.review ?? ""}"',
            style: AppTextStyles.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.background,
                child: Text(
                  review.name?.substring(0, 1).toUpperCase() ?? "U",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name ?? "Anonymous",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.warning, size: 12),
                        const Icon(Icons.star, color: AppColors.warning, size: 12),
                        const Icon(Icons.star, color: AppColors.warning, size: 12),
                        const Icon(Icons.star, color: AppColors.warning, size: 12),
                        const Icon(Icons.star, color: AppColors.warning, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          "${review.rating ?? 5.0}",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFormattedDescription(String text) {
    final List<String> lines = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {

        if (line.trim().isEmpty) {
          return const SizedBox(height: 12);
        }

        final bool isHeading = line.trim().endsWith('?') ||
            (!line.trim().endsWith('.') && line.length < 65);

        return Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            line.trim(),
            style: isHeading
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                : AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontSize: AppFontSize.s13),
          ),
        );
      }).toList(),
    );
  }
}