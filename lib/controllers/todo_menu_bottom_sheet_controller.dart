import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/services/database_service.dart';

final todoMenuBSControllerProvider = AutoDisposeNotifierProvider<TodoMenuBSController, void>(() => TodoMenuBSController());

class TodoMenuBSController extends AutoDisposeNotifier<void> {
  @override
  void build() {}

  Future<void> pinTodo({required String todoId, required String userName}) async {
    try {
      getIt<DatabaseService>().pinTodo(todoId: todoId, userName: userName);
    } catch (e) {
      HelperFunctions.showErrorSnackBar(message: e.toString());
      debugPrint(e.toString());
    }
  }

  Future<void> unpinTodo({required String todoId, required String userName}) async {
    try {
      getIt<DatabaseService>().unpinTodo(todoId: todoId, userName: userName);
    } catch (e) {
      HelperFunctions.showErrorSnackBar(message: e.toString());
      debugPrint(e.toString());
    }
  }

  Future<void> deleteTodo({required String todoId}) async {
    try {
      await getIt<DatabaseService>().deleteTodo(todoId: todoId);
      HelperFunctions.showSnackBar(message: 'Todo Deleted');
    } catch (e) {
      HelperFunctions.showErrorSnackBar(message: e.toString());
      debugPrint(e.toString());
    }
  }
}
