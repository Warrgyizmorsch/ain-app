import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class WordCounterView extends GetView<HomeController> {
    WordCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(HomeController());

    // Local toggles for the options checkboxes
    final RxBool excludeQuotes = false.obs;
    final RxBool excludeUrl = false.obs;
    final RxBool excludeNumbers = false.obs;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(
          icon:   Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
              Text(
              'Word Counter',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
              SizedBox(height: 2),
            Text(
              'Count words, characters, sentences and\nparagraphs in your text.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 80,
        actions: [
          IconButton(
            icon:   Icon(Icons.history, color: AppColors.primaryPurple),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics:   BouncingScrollPhysics(),
        padding:   EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Input Type Selector
            Container(
              padding:   EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightDivider),
              ),
              child: Row(
                children: [
                  _buildInputTypeTab('Text', Icons.description_outlined),
                  _buildInputTypeTab('File Upload', Icons.upload_file_outlined),
                  _buildInputTypeTab('URL', Icons.link),
                ],
              ),
            ),
              SizedBox(height: 24),

            // 2. Dynamic Input Switcher Zone
            Obx(() {
              final type = controller.wordCounterSelectedInputType.value;
              if (type == 'File Upload') {
                return _buildFileUploadSection();
              } else if (type == 'URL') {
                return _buildUrlInputSection();
              } else {
                return _buildTextInputSection();
              }
            }),
              SizedBox(height: 24),

            // 3. Statistics Grid
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightDivider),
                boxShadow:   [BoxShadow(color: AppColors.lightShadow, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                children: [
                  // Row 1
                  Padding(
                    padding:   EdgeInsets.symmetric(vertical: 16.0),
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
                          _buildStatBox(Icons.text_fields,   Color(0xFFEF5350), charsWithSpaces, 'Characters\n(with spaces)'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.text_format,   Color(0xFF4285F4), charsNoSpaces, 'Characters\n(without spaces)'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.segment, AppColors.statusGreen, sentences, 'Sentences'),
                        ],
                      );
                    }),
                  ),
                  Divider(height: 1, color: AppColors.lightDivider.withValues(alpha: 0.5)),
                  // Row 2
                  Padding(
                    padding:   EdgeInsets.symmetric(vertical: 16.0),
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
                          _buildStatBox(Icons.format_align_left, AppColors.statusOrange, paragraphs, 'Paragraphs'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.find_in_page_outlined, AppColors.primaryPurple, pages, 'Pages\n(A4)'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.access_time,   Color(0xFF00ACC1), readTime, 'Reading Time\n(min)'),
                          _buildVerticalDivider(),
                          _buildStatBox(Icons.tag,   Color(0xFFEC407A), syllables, 'Syllables'),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
              SizedBox(height: 28),

            // 4. Options Section
            Row(
              children: [
                  Icon(Icons.settings_outlined, color: AppColors.textDark, size: 20),
                  SizedBox(width: 8),
                  Text(
                  'Options',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
              ],
            ),
              SizedBox(height: 12),

            // Options Wrap
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildOptionToggle('Exclude Quotes', Icons.format_quote, excludeQuotes.value, () => excludeQuotes.value = !excludeQuotes.value),
                _buildOptionToggle('Exclude URL', Icons.link, excludeUrl.value, () => excludeUrl.value = !excludeUrl.value),
                _buildOptionToggle('Exclude Numbers', Icons.numbers, excludeNumbers.value, () => excludeNumbers.value = !excludeNumbers.value),
              ],
            )),
              SizedBox(height: 24),

            // 5. Action Button (WITH LOADING STATE)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(() => ElevatedButton.icon(
                onPressed: controller.isWordCounterProcessing.value
                    ? null
                    : () => controller.processWordCount(),
                icon: controller.isWordCounterProcessing.value
                    ?   SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2.5))
                    :   Icon(Icons.bar_chart, color: AppColors.white, size: 20),
                label: Text(
                  controller.isWordCounterProcessing.value ? 'Processing...' : 'Count Words',
                  style:   TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  disabledBackgroundColor: AppColors.buttonPrimary.withValues(alpha: 0.6),
                ),
              )),
            ),
              SizedBox(height: 28),

            // 6. Recent Counts Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                      Icon(Icons.history, color: AppColors.textDark, size: 20),
                      SizedBox(width: 8),
                      Text(
                      'Recent Counts',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
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
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, color: AppColors.primaryPurple, size: 16),
                    ],
                  ),
                ),
              ],
            ),
              SizedBox(height: 12),
            _buildRecentCountCard(),

              SizedBox(height: 40),
          ],
        ),
      ),
    );
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            Obx(() {
              final text = controller.activeTextForCounting.value;
              final wordsCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
              return Text(
                '$wordsCount Words',
                style:   TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
              );
            }),
          ],
        ),
          SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightDivider),
            boxShadow:   [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 1))],
          ),
          child: Stack(
            children: [
              TextField(
                controller: controller.wordCounterTextController,
                maxLines: 6,
                minLines: 6,
                style:   TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
                decoration:   InputDecoration(
                  hintText: 'Paste your text here...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.lightTextHint, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
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
                    padding:   EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(Icons.auto_fix_high, color: AppColors.primaryPurple, size: 20),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            Obx(() {
              final text = controller.activeTextForCounting.value;
              final wordsCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
              return Text(
                '$wordsCount Words',
                style:   TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
              );
            }),
          ],
        ),
          SizedBox(height: 12),
        Obx(() {
          if (controller.wordCounterSelectedFileName.value.isEmpty) {
            return InkWell(
              onTap: controller.pickWordCounterFile,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding:   EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3), width: 1.5, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:   EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child:   Icon(Icons.cloud_upload_outlined, color: AppColors.primaryPurple, size: 32),
                    ),
                      SizedBox(height: 16),
                      Text(
                      'Browse file from device or tap here',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    ),
                      SizedBox(height: 6),
                      Text(
                      'Supports PDF, DOCX, TXT',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              padding:   EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                boxShadow:   [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 1))],
              ),
              child: Row(
                children: [
                  Container(
                    padding:   EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:   Icon(Icons.insert_drive_file_outlined, color: AppColors.primaryPurple, size: 28),
                  ),
                    SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.wordCounterSelectedFileName.value,
                          style:   TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                          SizedBox(height: 4),
                        Text(
                          controller.wordCounterSelectedFileSize.value,
                          style:   TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon:   Icon(Icons.close, color: AppColors.error, size: 22),
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

  Widget _buildUrlInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Text(
              'Enter Web URL to Count',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            Obx(() {
              final text = controller.activeTextForCounting.value;
              final wordsCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
              return Text(
                '$wordsCount Words',
                style:   TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
              );
            }),
          ],
        ),
          SizedBox(height: 12),
        Obx(() => TextFormField(
          controller: controller.wordCounterUrlController,
          enabled: !controller.isWordCounterProcessing.value,
          textInputAction: TextInputAction.go,
          onFieldSubmitted: (_) => controller.processWordCount(),
          style:   TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            prefixIcon:   Icon(Icons.link, color: AppColors.primaryPurple, size: 20),
            suffixIcon: IconButton(
              icon: controller.isWordCounterProcessing.value
                  ?   SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: AppColors.primaryPurple, strokeWidth: 2))
                  :   Icon(Icons.arrow_circle_right, color: AppColors.primaryPurple, size: 28),
              onPressed: controller.isWordCounterProcessing.value
                  ? null
                  : () => controller.processWordCount(),
            ),
            hintText: 'https://example.com/article',
            hintStyle:   TextStyle(fontSize: 13, color: AppColors.lightTextHint, fontWeight: FontWeight.w400),
            contentPadding:   EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   BorderSide(color: AppColors.lightDivider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   BorderSide(color: AppColors.primaryPurple, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.lightDivider.withValues(alpha: 0.5)),
            ),
          ),
        )),
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
            padding:   EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryPurple : AppColors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: isSelected ? AppColors.white : AppColors.textGrey),
                  SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.textGrey,
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
            padding:   EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
            SizedBox(height: 8),
          Text(
            value,
            style:   TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
          ),
            SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style:   TextStyle(fontSize: 9, color: AppColors.textGrey, height: 1.2, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 60,
      width: 1,
      color: AppColors.lightDivider.withValues(alpha: 0.6),
    );
  }

  Widget _buildOptionToggle(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPurple.withValues(alpha: 0.05) : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.primaryPurple : AppColors.lightDivider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:   EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6)
              ),
              child: Icon(icon, size: 14, color: AppColors.primaryPurple),
            ),
              SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.textDark : AppColors.textGrey,
              ),
            ),
              SizedBox(width: 8),
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
      padding:   EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
        boxShadow:   [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Row(
        children: [
          Container(
            padding:   EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:   Icon(Icons.description_outlined, color: AppColors.primaryPurple, size: 22),
          ),
            SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                  'My Essay on AI',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                  SizedBox(height: 4),
                Text(
                  'May 10, 2024 • 3:15 PM',
                  style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500),
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
                SizedBox(height: 2),
              Text(
                'Words',
                style: TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
            SizedBox(width: 8),
            Icon(Icons.chevron_right, color: AppColors.textGrey, size: 20),
        ],
      ),
    );
  }
}