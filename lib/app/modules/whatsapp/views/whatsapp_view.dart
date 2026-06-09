import 'package:ain/app/common/constant/app_imports.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/whatsapp_controller.dart';

class WhatsappView extends GetView<WhatsappController> {
  const WhatsappView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'WhatsappView',
        showBackButton: false,
      ),
      body: const Center(
        child: Text(
          'WhatsappView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
