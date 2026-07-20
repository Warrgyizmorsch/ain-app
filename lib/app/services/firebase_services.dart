import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> init() async {
    await _firebaseMessaging.requestPermission();

    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      debugPrint("--- Firebase Token $token ---");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.notification?.title ?? "No Title";
      String body = message.notification?.body ?? "No Body";

      if (message.notification == null && message.data.isNotEmpty) {
        title = message.data['title'] ?? title;
        body = message.data['body'] ?? body;
      }

      debugPrint("Received JSON - Title: $title, Body: $body");

      // final controller = Get.find<HomeController>();
      // controller.addNotification(title, body);
    });
  }
}
