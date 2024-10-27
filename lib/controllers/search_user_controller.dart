import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/database_service.dart';

final searchUserControllerProvider = AutoDisposeAsyncNotifierProvider<SearchUserController, List<TodoUser>>(() {
  return SearchUserController();
});

class SearchUserController extends AutoDisposeAsyncNotifier<List<TodoUser>> {
  @override
  FutureOr<List<TodoUser>> build() {
    return [];
  }

  Future<void> searchUser({required String query}) async {
    final previousState = state;
    try {
      state = const AsyncLoading();
      final result = await getIt<DatabaseService>().searchUser(query: query);
      state = AsyncData(result);
    } catch (e) {
      state = previousState;
      HelperFunctions.showErrorSnackBar(message: e.toString());
      debugPrint(e.toString());
    }
  }
}
