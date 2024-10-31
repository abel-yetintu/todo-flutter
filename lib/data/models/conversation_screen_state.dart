import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/models/message.dart';

class ConversationScreenState {
  final AsyncValue<List<Message>> messages;
  final List<Message> filteredMessages;
  final bool isRecording;
  final bool isSearching;
  final String searchQuery;

  ConversationScreenState(
      {required this.messages, required this.isRecording, required this.searchQuery, required this.isSearching, required this.filteredMessages});

  ConversationScreenState.initial()
      : messages = const AsyncLoading(),
        filteredMessages = [],
        isRecording = false,
        isSearching = false,
        searchQuery = '';

  ConversationScreenState copyWith({
    AsyncValue<List<Message>>? messages,
    List<Message>? filteredMessages,
    bool? isRecording,
    bool? isSearching,
    String? searchQuery,
  }) {
    return ConversationScreenState(
      messages: messages ?? this.messages,
      filteredMessages: filteredMessages ?? this.filteredMessages,
      isRecording: isRecording ?? this.isRecording,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
