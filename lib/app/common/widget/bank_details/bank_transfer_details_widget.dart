import 'package:share_plus/share_plus.dart';
import '../../constant/app_imports.dart';
import '../../../core/models/payment_model/bank_list_model.dart';

class BankTransferDetailsWidget extends StatefulWidget {
  final List<BankDetail> banksList;
  final double tabViewHeight;
  final bool isBottomSheet;

  const BankTransferDetailsWidget({
    super.key,
    required this.banksList,
    this.tabViewHeight = 220,
    this.isBottomSheet = false,
  });

  @override
  State<BankTransferDetailsWidget> createState() => _BankTransferDetailsWidgetState();
}

class _BankTransferDetailsWidgetState extends State<BankTransferDetailsWidget> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _uniqueCountries;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTabs();
  }

  void _initTabs() {
    _uniqueCountries = widget.banksList
        .map((bank) => bank.name ?? 'Global')
        .toSet()
        .toList();
    if (_currentIndex >= _uniqueCountries.length) {
      _currentIndex = 0;
    }
    _tabController = TabController(
      length: _uniqueCountries.isEmpty ? 1 : _uniqueCountries.length,
      initialIndex: _currentIndex,
      vsync: this,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging || _tabController.index != _currentIndex) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  void didUpdateWidget(covariant BankTransferDetailsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banksList != widget.banksList) {
      _tabController.removeListener(_handleTabSelection);
      _tabController.dispose();
      _initTabs();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void shareCurrentTabBankDetails() {
    if (_uniqueCountries.isEmpty || _currentIndex >= _uniqueCountries.length) return;

    final currentCountry = _uniqueCountries[_currentIndex];
    final countryBanks = widget.banksList
        .where((bank) => (bank.name ?? 'Global') == currentCountry)
        .toList();

    if (countryBanks.isEmpty) return;

    final buffer = StringBuffer();
    buffer.writeln("🏦 *Bank Transfer Details ($currentCountry)*\n");
    for (int i = 0; i < countryBanks.length; i++) {
      final bank = countryBanks[i];
      if (countryBanks.length > 1) {
        buffer.writeln("📍 *Option ${i + 1}:*");
      }
      buffer.writeln("• Account Name: ${bank.accountHolder ?? 'N/A'}");
      buffer.writeln("• Account Number: ${bank.accountNumber ?? 'N/A'}");
      buffer.writeln("• Sort Code / Routing: ${bank.sortCode ?? 'N/A'}");
      if (i < countryBanks.length - 1) buffer.writeln();
    }

    // ignore: deprecated_member_use
    Share.share(buffer.toString(), subject: 'Bank Details - $currentCountry');
  }

  void _shareSingleBank(String country, BankDetail bank) {
    final buffer = StringBuffer();
    buffer.writeln("🏦 *Bank Transfer Details ($country)*\n");
    buffer.writeln("• Account Name: ${bank.accountHolder ?? 'N/A'}");
    buffer.writeln("• Account Number: ${bank.accountNumber ?? 'N/A'}");
    buffer.writeln("• Sort Code / Routing: ${bank.sortCode ?? 'N/A'}");

    // ignore: deprecated_member_use
    Share.share(buffer.toString(), subject: 'Bank Details - $country');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banksList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text("No bank details found.")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Bar Header & Share active tab button
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.primaryPurple,
          labelColor: AppColors.primaryPurple,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: _uniqueCountries.map((country) => Tab(text: country)).toList(),
        ),
        const SizedBox(height: 16),

        // Tab View
        SizedBox(
          height: widget.tabViewHeight,
          child: TabBarView(
            controller: _tabController,
            children: _uniqueCountries.map((country) {
              final countryBanks = widget.banksList
                  .where((bank) => (bank.name ?? 'Global') == country)
                  .toList();

              return ListView.separated(
                shrinkWrap: true,
                itemCount: countryBanks.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final bank = countryBanks[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.bgLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.lightDivider),
                      boxShadow: widget.isBottomSheet
                          ? [BoxShadow(color: AppColors.lightShadow, blurRadius: 4, offset: const Offset(0, 1))]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              countryBanks.length > 1 ? "Option ${index + 1}" : "Bank Details",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                            InkWell(
                              onTap: () => _shareSingleBank(country, bank),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.share, size: 12, color: AppColors.primaryPurple),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Share",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(height: 1, color: AppColors.lightDivider),
                        const SizedBox(height: 8),
                        _buildCopyableRow("Account Name", bank.accountHolder ?? "N/A"),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Divider(height: 1, color: AppColors.lightDivider),
                        ),
                        _buildCopyableRow("Account Number", bank.accountNumber ?? "N/A"),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Divider(height: 1, color: AppColors.lightDivider),
                        ),
                        _buildCopyableRow("Sort Code / Routing", bank.sortCode ?? "N/A"),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyableRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            Get.snackbar(
              "Copied",
              "$label copied to clipboard",
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(12),
              backgroundColor: AppColors.success,
              colorText: Colors.white,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.copy, size: 16, color: AppColors.primaryPurple),
          ),
        ),
      ],
    );
  }
}
