import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class WordCounterView extends GetView<HomeController> {
  const WordCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(HomeController());

    // Local toggles for the options checkboxes
    final RxBool excludeQuotes = false.obs;
    final RxBool excludeNumbers = false.obs;

    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: 'Word Counter',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: AppColors.primaryPurple),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Input Type Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightDivider),
              ),
              child: Row(
                children: [
                  _buildInputTypeTab('Text', Icons.description_outlined),
                  _buildInputTypeTab('File Upload', Icons.upload_file_outlined),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Dynamic Input Switcher Zone
            Obx(() {
              final type = controller.wordCounterSelectedInputType.value;
              if (type == 'File Upload') {
                return _buildFileUploadSection();
              } else {
                return _buildTextInputSection();
              }
            }),
            const SizedBox(height: 24),

            // 3. Statistics Grid
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightDivider),
              ),
              child: Column(
                children: [
                  // Row 1
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Obx(() {
                      final text = controller.activeTextForCounting.value;
                      final wordsCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;

                      final wordsStr = wordsCount.toString();
                      final charsWithSpaces = text.length.toString();
                      final charsNoSpaces = text.replaceAll(RegExp(r'\s+'), '').length.toString();
                      final sentences = text.isEmpty ? '0' : text.split(RegExp(r'[.!?]+')).where((e) => e.trim().isNotEmpty).length.toString();

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatBox(Icons.font_download_outlined, AppColors.primaryPurple, wordsStr, 'Words'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.text_fields, AppColors.error, charsWithSpaces, 'Characters\n(with spaces)'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.text_format, AppColors.secondary, charsNoSpaces, 'Characters\n(without spaces)'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.segment, AppColors.statusGreen, sentences, 'Sentences'),
                        ],
                      );
                    }),
                  ),
                  Divider(height: 1, color: AppColors.lightDivider),
                  // Row 2
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Obx(() {
                      final text = controller.activeTextForCounting.value;
                      final wordsCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;

                      final paragraphs = text.isEmpty ? '0' : text.split(RegExp(r'\n+')).where((e) => e.trim().isNotEmpty).length.toString();
                      final pages = text.isEmpty ? '0' : (wordsCount / 250).ceil().toString();
                      final readTime = text.isEmpty ? '0' : (wordsCount / 200).ceil().toString();
                      final syllables = text.isEmpty ? '0' : (wordsCount * 1.5).round().toString();

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatBox(Icons.format_align_left, AppColors.secondary, paragraphs, 'Paragraphs'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.find_in_page_outlined, AppColors.primaryPurple, pages, 'Pages\n(A4)'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.access_time, AppColors.primaryPurple, readTime, 'Reading Time\n(min)'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.tag, AppColors.secondary, syllables, 'Syllables'),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 4. Options Section
            Row(
              children: [
                Icon(Icons.settings_outlined, color: AppColors.textPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Options',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Options Wrap
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildOptionToggle('Exclude Quotes', Icons.format_quote, excludeQuotes.value, () => excludeQuotes.value = !excludeQuotes.value),
                _buildOptionToggle('Exclude Numbers', Icons.numbers, excludeNumbers.value, () => excludeNumbers.value = !excludeNumbers.value),
              ],
            )),
            const SizedBox(height: 24),

            // 5. Action Button (WITH LOADING STATE)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(() => ElevatedButton.icon(
                onPressed: controller.isWordCounterProcessing.value
                    ? null
                    : () => controller.processWordCount(),
                icon: controller.isWordCounterProcessing.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2.5))
                    : const Icon(Icons.bar_chart, color: AppColors.white, size: 20),
                label: Text(
                  controller.isWordCounterProcessing.value ? 'Processing...' : 'Count Words',
                  style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  disabledBackgroundColor: AppColors.primaryPurple.withValues(alpha: 0.6),
                ),
              )),
            ),
            const SizedBox(height: 28),

            // 6. Recent Counts Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: AppColors.textPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Recent Counts',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: AppColors.primaryPurple, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRecentCountCard(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    ));
  }

  // ==========================================
  // VIEW STRATEGY SWITCHER SECTIONS
  // ==========================================

  Widget _buildTextInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter or Paste Your Text',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            Obx(() {
              final text = controller.activeTextForCounting.value;
              final wordsCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
              return Text(
                '$wordsCount Words',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightDivider),
          ),
          child: Stack(
            children: [
              TextField(
                controller: controller.wordCounterTextController,
                maxLines: 6,
                minLines: 6,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Paste your text here...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.lightTextHint, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: InkWell(
                  onTap: () {
                    controller.wordCounterTextController.clear();
                    // Clear the active text as well
                    controller.activeTextForCounting.value = '';
                    Get.snackbar("Cleared", "Text area cleared.", snackPosition: SnackPosition.BOTTOM);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.auto_fix_high, color: AppColors.primaryPurple, size: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upload Document',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            Obx(() {
              final text = controller.activeTextForCounting.value;
              final wordsCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
              return Text(
                '$wordsCount Words',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.wordCounterSelectedFileName.value.isEmpty) {
            return InkWell(
              onTap: controller.pickWordCounterFile,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3), width: 1.5, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.cloud_upload_outlined, color: AppColors.primaryPurple, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Browse file from device or tap here',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Supports PDF, DOCX, TXT',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.insert_drive_file_outlined, color: AppColors.primaryPurple, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.wordCounterSelectedFileName.value,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.wordCounterSelectedFileSize.value,
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.error, size: 22),
                    onPressed: controller.removeWordCounterFile,
                    tooltip: "Remove file",
                  ),
                ],
              ),
            );
          }
        }),
      ],
    );
  }

  // ==========================================
  // ATOMIC HELPER COMPONENTS
  // ==========================================

  Widget _buildInputTypeTab(String title, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.setWordCounterTab(title), // Important: Using the set method for separate tab tracking
        borderRadius: BorderRadius.circular(8),
        child: Obx(() {
          final isSelected = controller.wordCounterSelectedInputType.value == title;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryPurple : AppColors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: isSelected ? AppColors.white : AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatBox(IconData icon, Color iconColor, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: AppColors.textSecondary, height: 1.2, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 60,
      width: 1,
      color: AppColors.lightDivider,
    );
  }

  Widget _buildOptionToggle(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPurple.withValues(alpha: 0.15) : AppColors.bgLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.primaryPurple : AppColors.lightDivider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6)
              ),
              child: Icon(icon, size: 14, color: AppColors.primaryPurple),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isActive ? Icons.check_box : Icons.check_box_outline_blank,
              size: 18,
              color: isActive ? AppColors.primaryPurple : AppColors.lightDisabled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCountCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.description_outlined, color: AppColors.primaryPurple, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Essay on AI',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'May 10, 2024 • 3:15 PM',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '1,245',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
              ),
              const SizedBox(height: 2),
              Text(
                'Words',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }
}