enum MessageType { text, file, chart }

class MessageModel {
  final String content;
  final String time;
  final bool isMe;
  final MessageType type;
  final String? fileSize;

  MessageModel({
    required this.content,
    required this.time,
    required this.isMe,
    this.type = MessageType.text,
    this.fileSize,
  });

  // The copyWith method allows us to duplicate the object while
  // changing specific fields (like appending new streamed text).
  MessageModel copyWith({
    String? content,
    String? time,
    bool? isMe,
    MessageType? type,
    String? fileSize,
  }) {
    return MessageModel(
      content: content ?? this.content,
      time: time ?? this.time,
      isMe: isMe ?? this.isMe,
      type: type ?? this.type,
      fileSize: fileSize ?? this.fileSize,
    );
  }
}