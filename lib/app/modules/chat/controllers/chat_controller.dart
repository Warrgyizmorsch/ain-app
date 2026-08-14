import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import '../../../core/models/chats_model/chat_message_model.dart';
import '../../../services/storage_services.dart';

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
    _initChat();
  }

  // ==========================================
  // INITIALIZATION & HISTORY
  // ==========================================

  Future<void> _initChat() async {
    // Fetch existing session from StorageService
    final savedSession = StorageService.to.getChatSession();

    if (savedSession != null && savedSession.isNotEmpty) {
      sessionId = savedSession;
      await _loadHistory();
    } else {
      _createNewSession();
    }

    _connectWebSocket();
  }

  void _createNewSession() {
    sessionId = "user_${Random().nextInt(999999999)}";

    // Save to local storage using your centralized service
    StorageService.to.saveChatSession(sessionId);

    _messageQueue.add("Hi there! 👋 I'm Daniel. How can I help you today?");
    _processBotQueue();
  }

  Future<void> _loadHistory() async {
    try {
      final url = Uri.parse('https://love14-ain-chatbot.hf.space/api/admin/chats/$sessionId');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> history = jsonDecode(res.body);

        if (history.isNotEmpty) {
          messages.clear();
          for (var m in history) {
            final isUser = m['sender'].toString().toLowerCase().contains('user');
            messages.add(
                MessageModel(
                  content: m['message'] ?? '',
                  time: _getCurrentTime(),
                  isMe: isUser,
                )
            );
          }
          _scrollToBottom();
        } else {
          // If session exists locally but server history is empty, treat as new
          _createNewSession();
        }
      } else {
        debugPrint("Failed to load history. Status Code: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error loading history: $e");
    }
  }

  Future<void> resetChat() async {
    // Clear old session from storage
    await StorageService.to.clearChatSession();

    // Reset local UI state
    messages.clear();
    _messageQueue.clear();
    isBotTypingText.value = false;
    isTyping.value = false;

    // Create new session & trigger welcome message
    _createNewSession();

    // Reconnect WebSocket with the new session ID
    _channel?.sink.close();
    _connectWebSocket();
  }

  // ==========================================
  // WEBSOCKET LOGIC
  // ==========================================

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
      // If it's not JSON, it's a standard text message from the bot
      isTyping.value = false;
      _messageQueue.add(messageData.toString().trim());
      _processBotQueue();
    }
  }

  // ==========================================
  // BOT TYPEWRITER ANIMATION
  // ==========================================

  void _processBotQueue() {
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

    Timer.periodic(const Duration(milliseconds: 30), (timer) { // Adjust ms for typing speed
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
        timer.cancel();
        isBotTypingText.value = false;
        _processBotQueue(); // Check if more messages are in queue
      }
    });
  }

  // ==========================================
  // USER ACTIONS
  // ==========================================

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    // Add user message to UI
    messages.add(
      MessageModel(content: text, time: _getCurrentTime(), isMe: true),
    );
    textController.clear();
    _scrollToBottom();

    // Show remote typing indicator optimistically
    isTyping.value = true;
    _scrollToBottom();

    // Send through WebSocket
    if (_channel != null) {
      _channel!.sink.add(text);
    } else {
      isTyping.value = false;
      Get.snackbar(
          "Connection Error",
          "Reconnecting to server... Please try again.",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900
      );
      _connectWebSocket();
    }
  }

  void onUserTyping(String val) {
    if (_channel != null) {
      final typingEvent = jsonEncode({"type": "typing", "is_typing": val.isNotEmpty});
      _channel!.sink.add(typingEvent);
    }
  }

  // ==========================================
  // UTILS & CLEANUP
  // ==========================================

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