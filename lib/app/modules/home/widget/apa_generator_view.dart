import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class ApaGeneratorView extends GetView<HomeController> {
  const ApaGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: 'APA Generator',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Mobile-Optimized Horizontal Scrollable Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                children: controller.apaCategories.map((category) {
                  final isMore = category == 'More';
                  final mainCategories = ['Website', 'Journal Article', 'Book'];

                  // Check if a category outside the main 3 is selected (for highlighting 'More' tab)
                  final isSelected = isMore
                      ? !mainCategories.contains(controller.apaSelectedCategory.value)
                      : controller.apaSelectedCategory.value == category;

                  // Change the 'More' text dynamically if something else is selected
                  final displayText = (isMore && isSelected) ? controller.apaSelectedCategory.value : category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        if (isMore) {
                          _showMoreOptionsBottomSheet();
                        } else {
                          controller.apaSelectedCategory.value = category;
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryPurple : AppColors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              displayText,
                              style: TextStyle(
                                color: isSelected ? AppColors.white : AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isMore) ...[
                              const SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down, size: 16, color: isSelected ? AppColors.white : AppColors.textPrimary),
                            ]
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
            ),
            const SizedBox(height: 24),

            // 2. Section: Enter Source Details
            Row(
              children: [
                 Icon(Icons.article_outlined, color: AppColors.textDark, size: 20),
                const SizedBox(width: 8),
                 Text(
                  'Enter Source Details',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // DYNAMIC FORM ZONE BASED ON SELECTED TAB
            Obx(() {
              final currentCategory = controller.apaSelectedCategory.value;
              if (currentCategory == 'Journal Article') {
                return _buildJournalArticleForm();
              } else if (currentCategory == 'Book') {
                return _buildBookForm();
              } else if (currentCategory == 'Website') {
                return _buildWebsiteForm();
              } else {
                // Return dynamic generic form for Podcast, Video, Newspaper, etc.
                return _buildGenericForm(currentCategory);
              }
            }),
            const SizedBox(height: 24),

            // 3. Section: Additional Options
            Row(
              children: [
                Icon(Icons.settings_outlined, color: AppColors.textPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Additional Options',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Mobile-Optimized Wrap for toggles
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildToggleOption(
                    'Include DOI',
                    controller.apaIncludeDoi.value,
                        () => controller.apaIncludeDoi.value = !controller.apaIncludeDoi.value
                ),
                _buildToggleOption(
                    'Include Access Date',
                    controller.apaIncludeAccessDate.value,
                        () => controller.apaIncludeAccessDate.value = !controller.apaIncludeAccessDate.value
                ),
                _buildToggleOption(
                    'Page / Paragraph',
                    controller.apaIncludePage.value,
                        () => controller.apaIncludePage.value = !controller.apaIncludePage.value
                ),
              ],
            )),
            const SizedBox(height: 24),

            // 4. Generate Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: controller.generateApaCitation,
                icon: const Icon(Icons.auto_awesome, color: AppColors.white, size: 20),
                label: const Text(
                  'Generate APA Citation',
                  style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // 5. Result Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.description_outlined, color: AppColors.textPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Your APA Citation',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                 Text(
                  'APA 7th Edition',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dynamic Result Card listening to Controller
            Obx(() => _buildResultCard(controller.apaCitationParts)),

            const SizedBox(height: 40),
            const SizedBox(height: 80),
          ],
        ),
      ),
      const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
    ],
  )));
  }

  // ==========================================
  // BOTTOM SHEET FOR 'MORE' OPTIONS
  // ==========================================
  void _showMoreOptionsBottomSheet() {
    final moreOptions = [
      {'title': 'Newspaper', 'icon': Icons.newspaper_outlined},
      {'title': 'Online Video', 'icon': Icons.ondemand_video_outlined},
      {'title': 'Podcast', 'icon': Icons.podcasts_outlined},
      {'title': 'Report', 'icon': Icons.analytics_outlined},
      {'title': 'Image / Art', 'icon': Icons.image_outlined},
      {'title': 'Social Media', 'icon': Icons.share_outlined},
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.bgLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.lightDivider, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Text('More Source Types', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: moreOptions.map((option) => InkWell(
                onTap: () {
                  controller.apaSelectedCategory.value = option['title'] as String;
                  Get.back(); // Close bottom sheet
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: (Get.width - 52) / 2, // Perfect 2-column grid
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(option['icon'] as IconData, size: 20, color: AppColors.primaryPurple),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          option['title'] as String,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


  // ==========================================
  // DYNAMIC TABS FORM GENERATORS
  // ==========================================

  // --- GENERIC FORM FOR 'MORE' OPTIONS ---
  Widget _buildGenericForm(String categoryName) {
    return Column(
      children: [
        _buildInputField(
            controller: controller.apaTitleCtrl,
            label: '$categoryName Title',
            hint: 'e.g., Title of the $categoryName',
            isRequired: true
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaAuthorCtrl,
            label: 'Creator / Author',
            hint: 'e.g., John Doe',
            suffixIcon: Icons.person_outline
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                  controller: controller.apaDateCtrl,
                  label: 'Date Published',
                  hint: 'e.g., 2024',
                  suffixIcon: Icons.calendar_today_outlined
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInputField(
                  controller: controller.apaSiteNameCtrl,
                  label: 'Publisher/Platform',
                  hint: 'e.g., YouTube'
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaUrlCtrl,
            label: 'URL or Link (Optional)',
            hint: 'https://...',
            suffixIcon: Icons.link
        ),
      ],
    );
  }

  // --- WEBSITE TAB FORM ---
  Widget _buildWebsiteForm() {
    return Column(
      children: [
        _buildInputField(
            controller: controller.apaTitleCtrl,
            label: 'Website Title',
            hint: 'e.g., The Impact of Artificial Intelligence',
            isRequired: true
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaUrlCtrl,
            label: 'Website URL',
            hint: 'https://www.example.com/article',
            isRequired: true
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaAuthorCtrl,
            label: 'Author / Organization',
            hint: 'e.g., OpenAI',
            suffixIcon: Icons.person_outline
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaDateCtrl,
            label: 'Publication Date',
            hint: 'e.g., 2024, May 10',
            suffixIcon: Icons.calendar_today_outlined
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaSiteNameCtrl,
            label: 'Website Name',
            hint: 'e.g., OpenAI Blog',
            suffixIcon: Icons.language
        ),
      ],
    );
  }

  // --- JOURNAL ARTICLE TAB FORM ---
  Widget _buildJournalArticleForm() {
    return Column(
      children: [
        _buildInputField(
            controller: controller.apaTitleCtrl,
            label: 'Article Title',
            hint: 'e.g., Deep Learning Frameworks in Mobile Systems',
            isRequired: true
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaAuthorCtrl,
            label: 'Author(s)',
            hint: 'e.g., Kumar, R., & Smith, J.',
            isRequired: true,
            suffixIcon: Icons.people_outline
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaSiteNameCtrl,
            label: 'Journal Name',
            hint: 'e.g., International Journal of Mobile Engineering',
            suffixIcon: Icons.menu_book_outlined
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                  controller: controller.apaDateCtrl,
                  label: 'Year',
                  hint: 'e.g., 2026',
                  suffixIcon: Icons.calendar_today_outlined
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInputField(
                  controller: controller.refVolCtrl,
                  label: 'Volume',
                  hint: 'e.g., 14'
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                  controller: controller.refIssueCtrl,
                  label: 'Issue',
                  hint: 'e.g., 2'
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInputField(
                  controller: controller.refPagesCtrl,
                  label: 'Pages',
                  hint: 'e.g., 45-52'
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaUrlCtrl,
            label: 'DOI / URL',
            hint: 'https://doi.org/10.1145/123456'
        ),
      ],
    );
  }

  // --- BOOK TAB FORM ---
  Widget _buildBookForm() {
    return Column(
      children: [
        _buildInputField(
            controller: controller.apaTitleCtrl,
            label: 'Book Title',
            hint: 'e.g., Mobile Application Architecture',
            isRequired: true
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaAuthorCtrl,
            label: 'Author(s)',
            hint: 'e.g., Doe, J.',
            isRequired: true,
            suffixIcon: Icons.person_outline
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                  controller: controller.apaDateCtrl,
                  label: 'Year',
                  hint: 'e.g., 2024',
                  suffixIcon: Icons.calendar_today_outlined
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInputField(
                  controller: controller.apaSiteNameCtrl,
                  label: 'Publisher',
                  hint: 'e.g., Academic Press'
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField(
            controller: controller.apaUrlCtrl,
            label: 'DOI or URL (Optional)',
            hint: 'https://doi.org/...'
        ),
      ],
    );
  }

  // ==========================================
  // REUSABLE INPUT FIELD BUILDER
  // ==========================================

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = false,
    IconData? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.bgLight,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            children: [
              if (isRequired)
                const TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: AppColors.lightTextHint, fontWeight: FontWeight.w400),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.textSecondary, size: 18) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryPurple, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildToggleOption(String text, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPurple.withValues(alpha: 0.15) : AppColors.bgLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.primaryPurple : AppColors.lightDivider,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.primaryPurple : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryPurple : AppColors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isActive ? AppColors.primaryPurple : AppColors.lightDisabled,
                  width: 1.5,
                ),
              ),
              child: isActive
                  ? const Icon(Icons.check, size: 14, color: AppColors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, String> parts) {
    if (parts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Text(
            'Fill out the details above to generate your APA citation.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5, fontWeight: FontWeight.w500),
                      children: [
                        if (parts['author']!.isNotEmpty) TextSpan(text: '${parts['author']}. '),
                        if (parts['date']!.isNotEmpty) TextSpan(text: '(${parts['date']}). '),
                        if (parts['title']!.isNotEmpty) TextSpan(
                          text: '${parts['title']}. ',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        if (parts['siteName']!.isNotEmpty) TextSpan(text: '${parts['siteName']}.\n'),
                        if (parts['url']!.isNotEmpty) TextSpan(
                          text: parts['url'],
                          style: TextStyle(color: AppColors.primaryPurple),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.star_border, color: AppColors.primaryPurple, size: 22),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.primaryPurple.withValues(alpha: 0.2)),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionItem(Icons.copy_outlined, 'Copy'),
                Container(width: 1, height: 18, color: AppColors.primaryPurple.withValues(alpha: 0.15)),
                _buildActionItem(Icons.download_outlined, 'Download'),
                Container(width: 1, height: 18, color: AppColors.primaryPurple.withValues(alpha: 0.15)),
                _buildActionItem(Icons.share_outlined, 'Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return InkWell(
      onTap: () {
        Get.snackbar("Action", "$label tapped", snackPosition: SnackPosition.BOTTOM);
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primaryPurple),
            const SizedBox(width: 6),
            Text(
              label,
              style:  TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}