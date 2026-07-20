import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class PlagiarismCheckerView extends GetView<HomeController> {
    PlagiarismCheckerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

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
              'Plagiarism Checker',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
              SizedBox(height: 2),
            Text(
              'Check your content for plagiarism and\nensure originality.',
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
              final type = controller.plagiarismSelectedInputType.value;
              if (type == 'File Upload') {
                return _buildFileUploadSection();
              } else if (type == 'URL') {
                return _buildUrlInputSection();
              } else {
                return _buildTextInputSection();
              }
            }),
              SizedBox(height: 24),

            // 3. Feature Highlights
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFeatureCard('Accurate', 'Advanced AI\nTechnology', AppColors.primaryPurple, Icons.shield_outlined),
                  _buildFeatureCard('Secure', 'Your data is\nsafe with us', AppColors.statusGreen, Icons.lock_outline),
                  _buildFeatureCard('Fast', 'Results in just\nseconds',   Color(0xFFEF5350), Icons.bolt_outlined),
                  _buildFeatureCard('Reliable', 'Detailed\nreporting',   Color(0xFF4285F4), Icons.description_outlined),
                ],
              ),
            ),
              SizedBox(height: 28),

            // 4. Check Options Section
              Text(
              'Check Options',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
              SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightDivider),
              ),
              child: Column(
                children: [
                  Obx(() => _buildCheckOption(
                    title: 'Check Internet Sources',
                    subtitle: 'Scan content from web pages and online databases',
                    value: controller.plagiarismCheckInternet.value,
                    onTap: () => controller.plagiarismCheckInternet.value = !controller.plagiarismCheckInternet.value,
                  )),
                  Divider(height: 1, color: AppColors.lightDivider.withValues(alpha: 0.5), indent: 48),
                  Obx(() => _buildCheckOption(
                    title: 'Check Academic Sources',
                    subtitle: 'Compare with journals, papers, and publications',
                    value: controller.plagiarismCheckAcademic.value,
                    onTap: () => controller.plagiarismCheckAcademic.value = !controller.plagiarismCheckAcademic.value,
                  )),
                  Divider(height: 1, color: AppColors.lightDivider.withValues(alpha: 0.5), indent: 48),
                  Obx(() => _buildCheckOption(
                    title: 'Exclude Quotes',
                    subtitle: 'Do not check content inside quotation marks',
                    value: controller.plagiarismExcludeQuotes.value,
                    onTap: () => controller.plagiarismExcludeQuotes.value = !controller.plagiarismExcludeQuotes.value,
                  )),
                ],
              ),
            ),
              SizedBox(height: 24),

            // 5. Action Button (Updated with File Upload Validation)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  final type = controller.plagiarismSelectedInputType.value;

                  if (type == 'Text' && controller.plagiarismTextController.text.trim().isEmpty) {
                    Get.snackbar("Empty", "Please enter some text to check.", backgroundColor: AppColors.warning, colorText: AppColors.white);
                    return;
                  } else if (type == 'File Upload' && controller.plagiarismSelectedFileName.value.isEmpty) {
                    Get.snackbar("Empty", "Please upload a document to check.", backgroundColor: AppColors.warning, colorText: AppColors.white);
                    return;
                  }

                  Get.snackbar('Processing', 'Scanning your submission now...', backgroundColor: AppColors.primaryPurple, colorText: AppColors.white);
                },
                icon:   Icon(Icons.search, color: AppColors.white, size: 20),
                label:   Text(
                  'Check for Plagiarism',
                  style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
              SizedBox(height: 28),

            // 6. Last Check Results Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Text(
                  'Your Last Check',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                        Text(
                        'View History',
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
            _buildLastCheckCard(),
              SizedBox(height: 24),
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
              'Enter Text to Check',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            Obx(() => Text(
              '${controller.plagiarismWordCount.value} / 5000 Words',
              style:   TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
            )),
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
                controller: controller.plagiarismTextController,
                maxLines: 8,
                minLines: 8,
                style:   TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
                decoration:   InputDecoration(
                  hintText: 'Paste your text here to check for plagiarism...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.lightTextHint, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding:   EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child:   Icon(Icons.auto_fix_high, color: AppColors.primaryPurple, size: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- UPDATED INTERACTIVE FILE UPLOAD SECTION ---
  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
          'Upload Document',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
          SizedBox(height: 12),
        Obx(() {
          // If no file is selected, show the upload box
          if (controller.plagiarismSelectedFileName.value.isEmpty) {
            return InkWell(
              onTap: controller.pickPlagiarismFile,
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
                      'Supports PDF, DOCX, TXT up to 10MB',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            );
          }
          // If a file IS selected, show the file details card
          else {
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
                          controller.plagiarismSelectedFileName.value,
                          style:   TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                          SizedBox(height: 4),
                        Text(
                          controller.plagiarismSelectedFileSize.value,
                          style:   TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon:   Icon(Icons.close, color: AppColors.error, size: 22),
                    onPressed: controller.removePlagiarismFile,
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
          Text(
          'Enter Web URL to Scan',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
          SizedBox(height: 12),
        TextFormField(
          style:   TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            prefixIcon:   Icon(Icons.link, color: AppColors.primaryPurple, size: 20),
            hintText: 'https://example.com/blog-post-article',
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
          ),
        ),
      ],
    );
  }

  // ==========================================
  // ATOMIC HELPER COMPONENTS
  // ==========================================

  Widget _buildInputTypeTab(String title, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.plagiarismSelectedInputType.value = title,
        borderRadius: BorderRadius.circular(8),
        child: Obx(() {
          final isSelected = controller.plagiarismSelectedInputType.value == title;
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

  Widget _buildFeatureCard(String title, String subtitle, Color color, IconData icon) {
    return Container(
      width: 100,
      margin:   EdgeInsets.only(right: 12),
      padding:   EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:   EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
            SizedBox(height: 10),
          Text(
            title,
            style:   TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
          ),
            SizedBox(height: 4),
          Text(
            subtitle,
            style:   TextStyle(fontSize: 9, color: AppColors.textGrey, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckOption({
    required String title,
    required String subtitle,
    required bool value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:   EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin:   EdgeInsets.only(top: 2),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? AppColors.primaryPurple : AppColors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: value ? AppColors.primaryPurple : AppColors.lightDisabled,
                  width: 1.5,
                ),
              ),
              child: value ?   Icon(Icons.check, size: 14, color: AppColors.white) : null,
            ),
              SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:   TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                    SizedBox(height: 2),
                  Text(
                    subtitle,
                    style:   TextStyle(fontSize: 10, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastCheckCard() {
    return Container(
      padding:   EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
        boxShadow:   [BoxShadow(color: AppColors.lightShadow, blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.18,
                  strokeWidth: 6,
                  backgroundColor: AppColors.lightDivider.withValues(alpha: 0.5),
                  color: AppColors.statusGreen,
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Text(
                        '18%',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.statusGreen),
                      ),
                      Text(
                        'Unique',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
            SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatDetail('Total Words', '1,245', AppColors.textDark),
                    _buildStatDetail('Plagiarized', '82%', AppColors.error),
                  ],
                ),
                  SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatDetail('Matched Words', '203', AppColors.error),
                    _buildStatDetail('Sources Found', '12', AppColors.primaryPurple),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatDetail(String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style:   TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
            SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}