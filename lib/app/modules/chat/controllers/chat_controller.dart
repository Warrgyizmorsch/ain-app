import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../core/models/chats_model/chat_message_model.dart';

class ChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // UI State
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isTyping = false.obs;

  // Typewriter & Queue State
  final RxBool isBotTypingText = false.obs;
  final List<String> _messageQueue = [];

  // WebSocket variables
  WebSocketChannel? _channel;
  late String sessionId;

  @override
  void onInit() {
    super.onInit();
    sessionId = "user_${Random().nextInt(999999999)}";

    _connectWebSocket();

    _messageQueue.add("Hi there! 👋 I'm Daniel. How can I help you today?");
    _processBotQueue();
  }

  void _connectWebSocket() {
    final wsUrl = Uri.parse('wss://love14-ain-chatbot.hf.space/api/ws/chat/$sessionId');
    try {
      _channel = WebSocketChannel.connect(wsUrl);

      _channel!.stream.listen(
            (message) {
          _handleIncomingMessage(message);
        },
        onDone: () {
          debugPrint("WebSocket Closed. Reconnecting in 3 seconds...");
          Future.delayed(const Duration(seconds: 3), _connectWebSocket);
        },
        onError: (error) {
          debugPrint("WebSocket Error: $error");
        },
      );
    } catch (e) {
      debugPrint("WebSocket Connection Error: $e");
    }
  }

  void _handleIncomingMessage(dynamic messageData) {
    try {
      final data = jsonDecode(messageData);
      if (data['type'] == 'admin_typing') {
        isTyping.value = data['is_typing'] ?? false;
        if (isTyping.value) _scrollToBottom();
        return;
      }
    } catch (e) {
      isTyping.value = false;
      _messageQueue.add(messageData.toString().trim());
      _processBotQueue();
    }
  }


  void _processBotQueue() {
    // Prevent overlapping typing if already processing a message or queue is empty
    if (isBotTypingText.value || _messageQueue.isEmpty) return;

    isBotTypingText.value = true;
    String rawText = _messageQueue.removeAt(0);
    String currentText = "";
    int charIndex = 0;

    final messageIndex = messages.length;
    messages.add(
      MessageModel(
        content: "",
        time: _getCurrentTime(),
        isMe: false,
      ),
    );


    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (charIndex < rawText.length) {
        currentText += rawText[charIndex];

        messages[messageIndex] = MessageModel(
          content: currentText,
          time: _getCurrentTime(),
          isMe: false,
        );

        charIndex++;
        _scrollToBottom();
      } else {
        // Finished typing the current message
        timer.cancel();
        isBotTypingText.value = false;

        // Check if there are more messages waiting in the queue
        _processBotQueue();
      }
    });
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(
      MessageModel(content: text, time: _getCurrentTime(), isMe: true),
    );
    textController.clear();
    _scrollToBottom();

    isTyping.value = true;
    _scrollToBottom();

    if (_channel != null) {
      _channel!.sink.add(text);
    } else {
      isTyping.value = false;
      Get.snackbar("Connection Error", "Reconnecting to server... Please try again.",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      _connectWebSocket();
    }
  }

  void onUserTyping(String val) {
    if (_channel != null) {
      final typingEvent = jsonEncode({"type": "typing", "is_typing": val.isNotEmpty});
      _channel!.sink.add(typingEvent);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    _channel?.sink.close();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}