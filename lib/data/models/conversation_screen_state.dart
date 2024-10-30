import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/models/message.dart';

class ConversationScreenState {
  final AsyncValue<List<Message>> messages;

  ConversationScreenState({required this.messages});

  ConversationScreenState.initial() : messages = const AsyncLoading();

  ConversationScreenState copyWith({
    AsyncValue<List<Message>>? messages,
  }) {
    return ConversationScreenState(
      messages: messages ?? this.messages,
    );
  }
}
