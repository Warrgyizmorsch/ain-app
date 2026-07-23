import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class ReferenceGeneratorView extends GetView<HomeController> {
  const ReferenceGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(HomeController());

    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: 'Reference Generator',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: AppColors.primaryPurple),
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
            // ==========================================
            // 1. TAB ROW 1: CITATION STYLE (Affects Output Format)
            // ==========================================
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStyleTab('APA 7th Edition'),
                  _buildStyleTab('MLA 9th Edition'),
                  _buildStyleTab('Chicago'),
                  _buildStyleTab('More', isMore: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 2. TAB ROW 2: SOURCE TYPE (Affects Input Form)
            // ==========================================
            Row(
              children: [
                Icon(Icons.menu_book_outlined, color: AppColors.textPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Select Source Type',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSourceCard('Journal Article', Icons.article_outlined),
                  _buildSourceCard('Book', Icons.menu_book_outlined),
                  _buildSourceCard('Website', Icons.language),
                  _buildSourceCard('E-book', Icons.tablet_mac_outlined),
                  _buildSourceCard('More', Icons.more_horiz, isMoreType: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 3. DYNAMIC INPUT FORMS ZONE
            // ==========================================
            Row(
              children: [
                Icon(Icons.edit_note, color: AppColors.textPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Enter Source Details',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // THIS CHANGES BASED ON SOURCE TYPE TAB
            Obx(() {
              final currentSource = controller.refSelectedSource.value;
              if (currentSource == 'Journal Article') {
                return _buildJournalArticleForm();
              } else if (currentSource == 'Book' || currentSource == 'E-book') {
                return _buildBookForm(currentSource);
              } else if (currentSource == 'Website') {
                return _buildWebsiteForm();
              } else {
                return _buildGenericSourceForm(currentSource); // For Podcast, Video, etc.
              }
            }),
            const SizedBox(height: 16),

            InkWell(
              onTap: () {},
              child: Text(
                '+ Add More Details',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 4. GENERATE BUTTON
            // ==========================================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: controller.generateReference,
                icon: const Icon(Icons.auto_awesome, color: AppColors.white, size: 20),
                label: const Text(
                  'Generate Reference',
                  style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 5. RESULT SECTION (Changes format based on Style Tab)
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.description_outlined, color: AppColors.textPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Your Reference',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                Obx(() => Text(
                  controller.refSelectedStyle.value,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                )),
              ],
            ),
            const SizedBox(height: 12),

            // Dynamic Result Card
            Obx(() => _buildResultCard(controller.refCitationParts)),
            const SizedBox(height: 80),
          ],
        ),
      ),
      const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
    ],
  )));
  }

  // ==========================================
  // MORE OPTIONS BOTTOM SHEETS
  // ==========================================

  void _showMoreStylesBottomSheet() {
    final stylesList = ['Harvard Style', 'Vancouver Style', 'IEEE Standard', 'AMA Manual'];
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
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.lightDivider, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Extended Citation Styles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Column(
              children: stylesList.map((style) => ListTile(
                title: Text(style, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                trailing: Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
                onTap: () {
                  controller.refSelectedStyle.value = style;
                  Get.back();
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreSourcesBottomSheet() {
    final sourcesList = [
      {'name': 'Online Video', 'icon': Icons.smart_display_outlined},
      {'name': 'Podcast Episode', 'icon': Icons.podcasts_outlined},
      {'name': 'Report / Thesis', 'icon': Icons.analytics_outlined},
      {'name': 'Software / App', 'icon': Icons.code_outlined},
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
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.lightDivider, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Extended Reference Sources', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: sourcesList.map((src) => InkWell(
                onTap: () {
                  controller.refSelectedSource.value = src['name'] as String;
                  Get.back();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: (Get.width - 52) / 2,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(src['icon'] as IconData, size: 18, color: AppColors.primaryPurple),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          src['name'] as String,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
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
  // DYNAMIC TABS FORM GENERATORS (SOURCE TYPE)
  // ==========================================

  Widget _buildJournalArticleForm() {
    return Column(
      children: [
        _buildInputField(controller: controller.refTitleCtrl, label: 'Article Title', hint: 'e.g., The impact of AI...', isRequired: true, suffixIcon: Icons.description_outlined),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refAuthorCtrl, label: 'Author(s)', hint: 'e.g., John Smith', isRequired: true, suffixIcon: Icons.person_outline),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refJournalCtrl, label: 'Journal Name', hint: 'e.g., Journal of Technology', isRequired: true, suffixIcon: Icons.menu_book_outlined),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField(controller: controller.refYearCtrl, label: 'Publication Year', hint: 'e.g., 2024', isRequired: true, isNumber: true, suffixIcon: Icons.calendar_today_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField(controller: controller.refVolCtrl, label: 'Volume', hint: 'e.g., 25', isNumber: true, suffixIcon: Icons.receipt_long_outlined)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField(controller: controller.refIssueCtrl, label: 'Issue', hint: 'e.g., 2', isNumber: true, suffixIcon: Icons.description_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField(controller: controller.refPagesCtrl, label: 'Page Range', hint: 'e.g., 45-60', suffixIcon: Icons.list_alt_outlined)),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refDoiCtrl, label: 'DOI or URL (Optional)', hint: 'https://doi.org/...', suffixIcon: Icons.link),
      ],
    );
  }

  Widget _buildBookForm(String type) {
    return Column(
      children: [
        _buildInputField(controller: controller.refTitleCtrl, label: '$type Title', hint: 'e.g., Clean Architecture', isRequired: true, suffixIcon: Icons.book_outlined),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refAuthorCtrl, label: 'Author(s)', hint: 'e.g., Robert C. Martin', isRequired: true, suffixIcon: Icons.person_outline),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refJournalCtrl, label: 'Publisher', hint: 'e.g., Prentice Hall', isRequired: true, suffixIcon: Icons.business_outlined),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField(controller: controller.refYearCtrl, label: 'Year Published', hint: 'e.g., 2025', isRequired: true, isNumber: true, suffixIcon: Icons.calendar_today_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField(controller: controller.refVolCtrl, label: 'Edition', hint: 'e.g., 2nd')),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refDoiCtrl, label: type == 'E-book' ? 'URL/DOI Link' : 'ISBN / DOI', hint: type == 'E-book' ? 'https://...' : 'e.g., 978-0134494166', suffixIcon: Icons.link),
      ],
    );
  }

  Widget _buildWebsiteForm() {
    return Column(
      children: [
        _buildInputField(controller: controller.refTitleCtrl, label: 'Webpage Title', hint: 'e.g., State Management in Flutter', isRequired: true, suffixIcon: Icons.language),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refAuthorCtrl, label: 'Author / Organization', hint: 'e.g., Google', isRequired: true, suffixIcon: Icons.people_outline),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refJournalCtrl, label: 'Website Name', hint: 'e.g., Flutter Medium', isRequired: true, suffixIcon: Icons.web_asset),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField(controller: controller.refYearCtrl, label: 'Date', hint: 'e.g., 2026', isRequired: true, suffixIcon: Icons.calendar_today_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField(controller: controller.refDoiCtrl, label: 'URL Address', hint: 'https://...', isRequired: true, suffixIcon: Icons.link)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenericSourceForm(String sourceName) {
    return Column(
      children: [
        _buildInputField(controller: controller.refTitleCtrl, label: '$sourceName Title', hint: 'e.g., Name of the resource', isRequired: true),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refAuthorCtrl, label: 'Creator / Host', hint: 'e.g., Main producer', isRequired: true, suffixIcon: Icons.person_outline),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField(controller: controller.refYearCtrl, label: 'Year', hint: 'e.g., 2026', isRequired: true, isNumber: true)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField(controller: controller.refJournalCtrl, label: 'Platform/Network', hint: 'e.g., Spotify, YouTube')),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField(controller: controller.refDoiCtrl, label: 'Link (Optional)', hint: 'https://...', suffixIcon: Icons.link),
      ],
    );
  }

  // ==========================================
  // ATOMIC HELPER WIDGETS
  // ==========================================

  Widget _buildStyleTab(String title, {bool isMore = false}) {
    return Obx(() {
      final mainStyles = ['APA 7th Edition', 'MLA 9th Edition', 'Chicago'];
      final isSelected = isMore ? !mainStyles.contains(controller.refSelectedStyle.value) : controller.refSelectedStyle.value == title;
      final displayText = (isMore && isSelected) ? controller.refSelectedStyle.value : title;

      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: InkWell(
          onTap: () {
            if (isMore) {
              _showMoreStylesBottomSheet();
            } else {
              controller.refSelectedStyle.value = title;
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryPurple : AppColors.bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(displayText, style: TextStyle(color: isSelected ? AppColors.white : AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                if (isMore) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: isSelected ? AppColors.white : AppColors.textSecondary),
                ]
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSourceCard(String title, IconData icon, {bool isMoreType = false}) {
    return Obx(() {
      final mainSources = ['Journal Article', 'Book', 'Website', 'E-book'];
      final isSelected = isMoreType ? !mainSources.contains(controller.refSelectedSource.value) : controller.refSelectedSource.value == title;
      final displayTitle = (isMoreType && isSelected) ? controller.refSelectedSource.value : title;

      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: InkWell(
          onTap: () {
            if (isMoreType) {
              _showMoreSourcesBottomSheet();
            } else {
              controller.refSelectedSource.value = title;
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryPurple.withValues(alpha: 0.15) : AppColors.bgLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primaryPurple : AppColors.lightDivider,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              children: [
                Icon(icon, color: isSelected ? AppColors.primaryPurple : AppColors.textSecondary, size: 24),
                const SizedBox(height: 10),
                Text(
                  displayTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: isSelected ? AppColors.primaryPurple : AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w500),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildInputField({required TextEditingController controller, required String label, required String hint, bool isRequired = false, bool isNumber = false, IconData? suffixIcon}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.bgLight,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            children: [
              if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: AppColors.lightTextHint, fontWeight: FontWeight.w400),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.textSecondary, size: 18) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.lightDivider)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primaryPurple, width: 1.5)),
      ),
    );
  }

  // ==========================================
  // CITATION FORMATTER (Changes based on Style Tab)
  // ==========================================
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
          child: Text('Fill out the details above to generate your reference.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13), textAlign: TextAlign.center),
        ),
      );
    }

    // Determine Style Formatting
    final style = parts['style'] ?? 'APA 7th Edition';
    List<InlineSpan> spans = [];

    if (style.contains('MLA')) {
      // MLA Formatting Logic
      if (parts['author']!.isNotEmpty) spans.add(TextSpan(text: '${parts['author']}. '));
      if (parts['title']!.isNotEmpty) spans.add(TextSpan(text: '"${parts['title']}." '));
      if (parts['journal']!.isNotEmpty) spans.add(TextSpan(text: '${parts['journal']}, ', style: const TextStyle(fontStyle: FontStyle.italic)));
      if (parts['volume']!.isNotEmpty) spans.add(TextSpan(text: 'vol. ${parts['volume']}, '));
      if (parts['issue']!.isNotEmpty) spans.add(TextSpan(text: 'no. ${parts['issue']}, '));
      if (parts['year']!.isNotEmpty) spans.add(TextSpan(text: '${parts['year']}, '));
      if (parts['pages']!.isNotEmpty) spans.add(TextSpan(text: 'pp. ${parts['pages']}. '));
    }
    else if (style.contains('Chicago')) {
      // Chicago Formatting Logic
      if (parts['author']!.isNotEmpty) spans.add(TextSpan(text: '${parts['author']}. '));
      if (parts['title']!.isNotEmpty) spans.add(TextSpan(text: '"${parts['title']}." '));
      if (parts['journal']!.isNotEmpty) spans.add(TextSpan(text: '${parts['journal']} ', style: const TextStyle(fontStyle: FontStyle.italic)));
      if (parts['volume']!.isNotEmpty) spans.add(TextSpan(text: '${parts['volume']}, '));
      if (parts['issue']!.isNotEmpty) spans.add(TextSpan(text: 'no. ${parts['issue']} '));
      if (parts['year']!.isNotEmpty) spans.add(TextSpan(text: '(${parts['year']}): '));
      if (parts['pages']!.isNotEmpty) spans.add(TextSpan(text: '${parts['pages']}. '));
    }
    else {
      // APA Formatting Logic (Default)
      if (parts['author']!.isNotEmpty) spans.add(TextSpan(text: '${parts['author']}. '));
      if (parts['year']!.isNotEmpty) spans.add(TextSpan(text: '(${parts['year']}). '));
      if (parts['title']!.isNotEmpty) spans.add(TextSpan(text: '${parts['title']}. '));
      if (parts['journal']!.isNotEmpty) spans.add(TextSpan(text: '${parts['journal']}, ', style: const TextStyle(fontStyle: FontStyle.italic)));
      if (parts['volume']!.isNotEmpty) spans.add(TextSpan(text: '${parts['volume']}'));
      if (parts['issue']!.isNotEmpty) spans.add(TextSpan(text: '(${parts['issue']})'));
      if (parts['pages']!.isNotEmpty) spans.add(TextSpan(text: ', ${parts['pages']}. '));
    }

    if (parts['doi']!.isNotEmpty) spans.add(TextSpan(text: '\n${parts['doi']}', style: TextStyle(color: AppColors.primaryPurple)));

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
                Expanded(child: RichText(text: TextSpan(style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5, fontWeight: FontWeight.w400), children: spans))),
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
                Container(width: 1, height: 18, color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                _buildActionItem(Icons.download_outlined, 'Download'),
                Container(width: 1, height: 18, color: AppColors.primaryPurple.withValues(alpha: 0.2)),
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
      onTap: () => Get.snackbar("Action", "$label tapped", snackPosition: SnackPosition.BOTTOM),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primaryPurple),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryPurple)),
          ],
        ),
      ),
    );
  }
}