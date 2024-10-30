import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/models/todo_user.dart';

class ChatScreenState {
  final bool showChats;
  final AsyncValue<List<TodoUser>> searchResult;
  final String query;

  ChatScreenState({
    required this.showChats,
    required this.searchResult,
    required this.query,
  });

  ChatScreenState.initial()
      : showChats = true,
        searchResult = const AsyncData([]),
        query = '';

  ChatScreenState copyWith({
    bool? showChats,
    AsyncValue<List<TodoUser>>? searchResult,
    String? query,
  }) {
    return ChatScreenState(
      showChats: showChats ?? this.showChats,
      searchResult: searchResult ?? this.searchResult,
      query: query ?? this.query,
    );
  }
}
