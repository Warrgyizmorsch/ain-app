import 'package:ain/app/common/constant/app_imports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/contact_us_controller.dart';
import '../widget/contact_us_tile.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Contact Us',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ContactTile(
              icon: Icons.call_outlined,
              title: 'Call',
              subtitle: '+44 7000000876',
              onTap: () {},
            ),

            const SizedBox(height: 12),

            ContactTile(
              icon: Icons.chat_outlined,
              title: 'Whatsapp',
              subtitle: '+44 7000000876',
              onTap: () {},
            ),

            const SizedBox(height: 12),

            ContactTile(
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: 'help@assignmentinneed.com',
              onTap: () {},
            ),

            const SizedBox(height: 12),

            ContactTile(
              icon: Icons.message_outlined,
              title: 'Live Chat',
              subtitle: 'Chat online now',
              onTap: () {},
            ),

            const SizedBox(height: 12),

            ContactTile(
              icon: Icons.phone_callback_outlined,
              title: 'Request Call Back',
              subtitle: 'Help',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}