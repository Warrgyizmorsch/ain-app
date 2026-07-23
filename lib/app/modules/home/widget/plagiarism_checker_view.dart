import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class PlagiarismCheckerView extends GetView<HomeController> {
  const PlagiarismCheckerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: 'Plagiarism Checker',
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
                  // _buildInputTypeTab('URL', Icons.link),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
            const SizedBox(height: 24),

            // 3. Feature Highlights
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFeatureCard('Accurate', 'Advanced AI\nTechnology', AppColors.primaryPurple, Icons.shield_outlined),
                  _buildFeatureCard('Secure', 'Your data is\nsafe with us', AppColors.statusGreen, Icons.lock_outline),
                  _buildFeatureCard('Fast', 'Results in just\nseconds', AppColors.error, Icons.bolt_outlined),
                  _buildFeatureCard('Reliable', 'Detailed\nreporting', AppColors.secondary, Icons.description_outlined),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 4. Check Options Section
            Text(
              'Check Options',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgLight,
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
                  Divider(height: 1, color: AppColors.lightDivider, indent: 48),
                  Obx(() => _buildCheckOption(
                    title: 'Check Academic Sources',
                    subtitle: 'Compare with journals, papers, and publications',
                    value: controller.plagiarismCheckAcademic.value,
                    onTap: () => controller.plagiarismCheckAcademic.value = !controller.plagiarismCheckAcademic.value,
                  )),
                  Divider(height: 1, color: AppColors.lightDivider, indent: 48),
                  Obx(() => _buildCheckOption(
                    title: 'Exclude Quotes',
                    subtitle: 'Do not check content inside quotation marks',
                    value: controller.plagiarismExcludeQuotes.value,
                    onTap: () => controller.plagiarismExcludeQuotes.value = !controller.plagiarismExcludeQuotes.value,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
                icon: const Icon(Icons.search, color: AppColors.white, size: 20),
                label: const Text(
                  'Check for Plagiarism',
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

            // 6. Last Check Results Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Last Check',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'View History',
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
            _buildLastCheckCard(),
             const SizedBox(height: 80),
          ],
        ),
      ),
      const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
    ],
  )));
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            Obx(() => Text(
              '${controller.plagiarismWordCount.value} / 5000 Words',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
            )),
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
                controller: controller.plagiarismTextController,
                maxLines: 8,
                minLines: 8,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Paste your text here to check for plagiarism...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.lightTextHint, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: InkWell(
                  onTap: () {},
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

  // --- UPDATED INTERACTIVE FILE UPLOAD SECTION ---
  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Document',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Obx(() {
          // If no file is selected, show the upload box
          if (controller.plagiarismSelectedFileName.value.isEmpty) {
            return InkWell(
              onTap: controller.pickPlagiarismFile,
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
                      'Supports PDF, DOCX, TXT up to 10MB',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }
          // If a file IS selected, show the file details card
          else {
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
                          controller.plagiarismSelectedFileName.value,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.plagiarismSelectedFileSize.value,
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.error, size: 22),
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
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        TextFormField(
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bgLight,
            prefixIcon: Icon(Icons.link, color: AppColors.primaryPurple, size: 20),
            hintText: 'https://example.com/blog-post-article',
            hintStyle: TextStyle(fontSize: 13, color: AppColors.lightTextHint, fontWeight: FontWeight.w400),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.lightDivider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryPurple, width: 1.5),
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

  Widget _buildFeatureCard(String title, String subtitle, Color color, IconData icon) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 9, color: AppColors.textSecondary, height: 1.3),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
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
              child: value ? const Icon(Icons.check, size: 14, color: AppColors.white) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightDivider),
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
                  backgroundColor: AppColors.lightDivider,
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
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatDetail('Total Words', '1,245', AppColors.textPrimary),
                    _buildStatDetail('Plagiarized', '82%', AppColors.error),
                  ],
                ),
                const SizedBox(height: 16),
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
          Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}