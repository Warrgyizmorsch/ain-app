import 'package:ain/app/common/constant/app_imports.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: 'Payment',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Card Payment Section ---
            _buildPaymentMethodContainer(
              title: "Card",
              icon: Icons.credit_card,
              child: Column(
                children: [
                  _customTextField("Your Name"),
                  const SizedBox(height: 10),
                  _customTextField("Card Number"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _customTextField("Exp. Date")),
                      const SizedBox(width: 10),
                      Expanded(child: _customTextField("CVV")),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- PayPal Section ---
            _buildPaymentMethodContainer(
              title: "Paypal",
              icon: Icons.payment, // Replace with an Image.asset('assets/paypal.png') for exact logo
            ),
            const SizedBox(height: 16),

            // --- Price Details Section ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  _priceRow("Basic Price (USD)",  controller.basePrice.value),
                  _priceRow("Discount",  controller.discount.value, isDiscount: true),
                  const Divider(),
                  _priceRow("Total",  controller.amount.value , isTotal: true),
                ],
              ),
            ),

            const Spacer(),

            // --- Pay Button ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6C4CF1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: controller.proceedToPay,
                child: const Text("Pay with Card", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodContainer({required String title, required IconData icon, Widget? child}) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: controller.selectedPaymentMethod.value == title
            ? Border.all(color: Colors.deepPurple, width: 2) : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              RadioGroup<String>(
                groupValue: controller.selectedPaymentMethod.value,
                onChanged: (value) {
                  controller.selectPaymentMethod(value!);
                },
                child: Radio<String>(
                  value: title,
                ),
              )
            ],
          ),
          if (child != null) ...[const SizedBox(height: 10), child],
        ],
      ),
    ));
  }

  Widget _customTextField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.grey.withValues(alpha:0.05), borderRadius: BorderRadius.circular(8)),
      child: TextField(decoration: InputDecoration(hintText: hint, border: InputBorder.none)),
    );
  }

  Widget _priceRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.black : Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}