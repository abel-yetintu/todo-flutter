import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/data/models/message.dart';
import 'package:todo/data/models/todo_user.dart';

class Conversation {
  final String documentId;
  final Message lastMessage;
  final List<String> participantsUid;
  final List<TodoUser> participants;

  Conversation({
    required this.documentId,
    required this.lastMessage,
    required this.participantsUid,
    required this.participants,
  });

  Conversation copyWith({
    String? documentId,
    Message? lastMessage,
    List<String>? participantsUid,
    List<TodoUser>? participants,
  }) {
    return Conversation(
      documentId: documentId ?? this.documentId,
      lastMessage: lastMessage ?? this.lastMessage,
      participantsUid: participantsUid ?? this.participantsUid,
      participants: participants ?? this.participants,
    );
  }

  factory Conversation.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Conversation(
      documentId: data['documentId'] as String,
      lastMessage: Message.fromMap(data['lastMessage'] as Map<String, dynamic>),
      participantsUid: List<String>.from(data['participantsUid']),
      participants: List<TodoUser>.from(
        (data['participants'] as List).map(
          (p) {
            return TodoUser.fromMap(p);
          },
        ),
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'documentId': documentId,
      'lastMessage': lastMessage.toFirestore(),
      'participantsUid': participantsUid,
      'participants': participants.map((x) => x.toFirestore()).toList(),
    };
  }
}
