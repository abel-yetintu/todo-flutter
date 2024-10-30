import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/core/enums/message_type.dart';

class Message {
  final String messageId;
  final String senderId;
  final MessageType type;
  final String content;
  final bool read;
  final DateTime timestamp;

  Message({
    required this.messageId,
    required this.senderId,
    required this.type,
    required this.content,
    required this.read,
    required this.timestamp,
  });

  Message copyWith({
    String? messageId,
    String? senderId,
    MessageType? type,
    String? content,
    bool? read,
    DateTime? timestamp,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      content: content ?? this.content,
      read: read ?? this.read,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Message(
      messageId: data['messageId'] as String,
      senderId: data['senderId'] as String,
      type: MessageType.values.firstWhere((m) {
        return m.name == data['type'];
      }),
      content: data['content'] as String,
      read: data['read'] as bool,
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int),
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'messageId': messageId,
      'senderId': senderId,
      'type': type.name,
      'content': content,
      'read': read,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'] as String,
      senderId: map['senderId'] as String,
      type: MessageType.values.firstWhere((m) {
        return m.name == map['type'];
      }),
      content: map['content'] as String,
      read: map['read'] as bool,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }
}
