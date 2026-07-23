import '../../../common/constant/app_imports.dart';
import '../controllers/add_to_cart_controller.dart';

class AddToCartView extends GetView<AddToCartController> {
  const AddToCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
        ),
        title: const Text('My Cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
      body: Stack(
        children: [
          Obx(() => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // --- Order Details Card ---
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:.05), blurRadius: 10)],
                      ),
                      child: Column(
                        children: [
                          Row(children: [Text("Essay", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600))]),
                          const SizedBox(height: 12),
                          _item('Order ID', controller.orderId.value),
                          _item('Topic', controller.topic.value),
                          _item('Pages', controller.pages.value),
                          _item('Deadline', controller.deadline.value),
                          _item('Amount to Pay', '£${controller.amount.value}'),
                        ],
                      ),
                    ),
                    // The blue blob effect seen in the screenshot
                    Positioned(right: 0, top: 0, child: Container(height: 120, width: 120, decoration: BoxDecoration(color: Colors.blue.withValues(alpha:0.05), shape: BoxShape.circle))),
                  ],
                ),

                const Spacer(),

                // --- Coupon & Wallet Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Have a coupon code ?', style: TextStyle(fontWeight: FontWeight.w500)),
                    TextButton(onPressed: () {}, child: const Text('View All')),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (v) {}),
                    const Text('Pay £1.87 with Wallet', style: TextStyle(color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 16),

                // --- Bottom Price Container ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:.05), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Price', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          // Pill shaped price highlight
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: Text('£${controller.amount.value}', style: const TextStyle(color: Color(0xff6C4CF1), fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        height: 48, width: 48,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: const LinearGradient(colors: [Color(0xff4D6CF7), Color(0xff8758FF)])),
                        child: IconButton(onPressed: () => Get.toNamed(Routes.PAYMENT), icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
        ],
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black87)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}