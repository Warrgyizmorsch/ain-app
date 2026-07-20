import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Note: Adjust these imports based on your actual project structure
import '../../../common/constant/app_imports.dart';

class PaymentHistoryView extends StatelessWidget {
  const PaymentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background matching UI
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Payments', // Updated title
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF5E35B1)),
            onPressed: () {
              // TODO: Help action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Total Spent Card
            _buildTotalSpentCard(),
            const SizedBox(height: 24),

            // 2. Quick Actions Row
            _buildQuickActionsRow(),
            const SizedBox(height: 32),

            // 3. Transaction History Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt_outlined, size: 16, color: Colors.black87),
                      const SizedBox(width: 6),
                      const Text(
                        'Filter',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey.shade600),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Transaction List
            _buildTransactionTile(
              icon: Icons.calculate_outlined,
              iconColor: const Color(0xFF5E35B1),
              iconBg: const Color(0xFFEDE7F6),
              title: 'Grade Calculator (Premium)',
              date: 'May 12, 2025 • 10:30 AM',
              orderId: '#ORD12345',
              amount: '\$399.00',
            ),
            const SizedBox(height: 12),
            _buildTransactionTile(
              icon: Icons.plagiarism_outlined,
              iconColor: const Color(0xFF2E7D32),
              iconBg: const Color(0xFFE8F5E9),
              title: 'Plagiarism Checker (Premium)',
              date: 'May 10, 2025 • 04:15 PM',
              orderId: '#ORD12344',
              amount: '\$499.00',
            ),
            const SizedBox(height: 12),
            _buildTransactionTile(
              icon: Icons.format_quote_outlined,
              iconColor: const Color(0xFFE64A19),
              iconBg: const Color(0xFFFBE9E7),
              title: 'Reference Generator (Premium)',
              date: 'May 8, 2025 • 11:20 AM',
              orderId: '#ORD12343',
              amount: '\$299.00',
            ),
            const SizedBox(height: 32),

            // 5. Saved Payment Methods
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved Payment Methods',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        'Manage',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF5E35B1)),
                      ),
                      Icon(Icons.chevron_right, size: 16, color: Color(0xFF5E35B1)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildSavedPaymentMethodCard(),
            const SizedBox(height: 32),

            // 6. Support Banner
            const _SupportBanner(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET BUILDERS
  // ==========================================

  Widget _buildTotalSpentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF311B92), // Deep purple from UI
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Spent',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '\$1,197.00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Across all transactions',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // Simulated Wallet Illustration
          Container(
            width: 80,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.white70, size: 48),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('₹', style: TextStyle(color: Color(0xFF311B92), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionItem(Icons.credit_card, const Color(0xFF5E35B1), const Color(0xFFEDE7F6), 'Payment\nMethods'),
          _buildQuickActionItem(Icons.receipt_long_outlined, const Color(0xFF2E7D32), const Color(0xFFE8F5E9), 'Invoices'),
          _buildQuickActionItem(Icons.autorenew, const Color(0xFFE64A19), const Color(0xFFFBE9E7), 'Subscriptions'),
          _buildQuickActionItem(Icons.shield_outlined, const Color(0xFF1565C0), const Color(0xFFE3F2FD), 'Security'),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, Color iconColor, Color bgColor, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String date,
    required String orderId,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  maxLines: 3, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6), // Light purple badge bg
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Order $orderId',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF5E35B1)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              const Text(
                'Paid',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF388E3C)), // Green text
              ),
            ],
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }

  Widget _buildSavedPaymentMethodCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Mastercard Logo simulation
                SizedBox(
                  width: 40,
                  child: Stack(
                    children: [
                      Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.8), shape: BoxShape.circle)),
                      Positioned(left: 14, child: Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.8), shape: BoxShape.circle))),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '.... .... .... 4242',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87, letterSpacing: 1.2),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF5E35B1)),
                  ),
                ),
                const Spacer(),
                Icon(Icons.more_vert, color: Colors.grey.shade500, size: 20),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
          InkWell(
            onTap: () {
              // TODO: Add new payment method logic
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Color(0xFF5E35B1), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Add New Payment Method',
                    style: TextStyle(
                      color: Color(0xFF5E35B1),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SupportBanner extends StatelessWidget {
  const _SupportBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5), // Light purple background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.headset_mic_outlined, color: Color(0xFF5E35B1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need help with payments?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our support team is here to assist you.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to support
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF311B92), // Dark deep purple button
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: const Text(
              'Contact Support',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}