import 'package:ain/app/common/constant/app_imports.dart';
import '../controllers/contact_us_controller.dart';
import '../widget/contact_us_tile.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const CustomAppBar(
        title: AppStrings.contactUs,
        showBackButton: false,
      ),
      // --- ADDED SingleChildScrollView HERE ---
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Optional: adds a nice bounce effect
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ContactTile(
              icon: Icons.call_outlined,
              title: 'Call',
              subtitle: '+44 78262 33106',
              onTap: controller.makeCall,
            ),

            const SizedBox(height: 12),

            ContactTile(
              icon: Icons.chat_outlined,
              title: 'WhatsApp',
              subtitle: '+44 78262 33106',
              onTap: controller.openWhatsapp,
            ),

            const SizedBox(height: 12),

            ContactTile(
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: 'help@assignmentinneed.com',
              onTap: controller.sendEmail,
            ),

            const SizedBox(height: 12),

            ContactTile(
              icon: Icons.message_outlined,
              title: 'Live Chat',
              subtitle: 'Chat online now',
              onTap: controller.openLiveChat,
            ),

            const SizedBox(height: 12),

            ContactTile(
              icon: Icons.phone_callback_outlined,
              title: 'Request Call Back',
              subtitle: "We'll call you back",
              onTap: () => controller.requestCallBack(context),
            ),
          ],
        ),
      ),
    ));
  }
}