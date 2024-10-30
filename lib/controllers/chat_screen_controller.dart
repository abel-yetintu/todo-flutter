import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/data/models/chat_screen_state.dart';
import 'package:todo/services/database_service.dart';

final chatScreenControllerProvider = AutoDisposeNotifierProvider<ChatScreenController, ChatScreenState>(() {
  return ChatScreenController();
});

class ChatScreenController extends AutoDisposeNotifier<ChatScreenState> {
  @override
  ChatScreenState build() {
    return ChatScreenState.initial();
  }

  Timer? _searchDebouncer;

  void setQueryTerm({required String query}) {
    state = state.copyWith(query: query);
    if (_searchDebouncer != null) {
      _searchDebouncer!.cancel();
    }
    if (query.isNotEmpty) {
      _searchDebouncer = Timer(const Duration(milliseconds: 500), () {
        _searchUser(query: query);
      });
      state = state.copyWith(showChats: false);
    } else {
      state = state.copyWith(showChats: true, searchResult: const AsyncData([]));
    }
  }

  Future<void> _searchUser({required String query}) async {
    try {
      state = state.copyWith(searchResult: const AsyncLoading());
      final result = await getIt<DatabaseService>().searchUser(query: query);
      state = state.copyWith(searchResult: AsyncData(result));
    } catch (e) {
      state = state.copyWith(searchResult: const AsyncData([]));
      HelperFunctions.showErrorSnackBar(message: e.toString());
      debugPrint(e.toString());
    }
  }
}
