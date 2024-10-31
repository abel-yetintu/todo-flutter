import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/models/message.dart';

class ConversationScreenState {
  final AsyncValue<List<Message>> messages;
  final bool isRecording;

  ConversationScreenState({required this.messages, required this.isRecording});

  ConversationScreenState.initial()
      : messages = const AsyncLoading(),
        isRecording = false;

  ConversationScreenState copyWith({
    AsyncValue<List<Message>>? messages,
    bool? isRecording,

  }) {
    return ConversationScreenState(
      messages: messages ?? this.messages,
      isRecording: isRecording ?? this.isRecording,
    );
  }
}
