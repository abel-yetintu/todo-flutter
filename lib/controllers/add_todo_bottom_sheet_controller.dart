import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/enums/todo_color.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/database_service.dart';

final addTodoBSControllerProvider = AutoDisposeNotifierProvider<AddTodoBSController, Todo>(() {
  return AddTodoBSController();
});

class AddTodoBSController extends AutoDisposeNotifier<Todo> {
  @override
  build() {
    return Todo.empty();
  }

  Timer? _titleDebouncer;
  Timer? _descriptionDebouncer;

  void setTitle(String title) {
    if (_titleDebouncer != null) {
      _titleDebouncer?.cancel();
    }
    _titleDebouncer = Timer(const Duration(milliseconds: 200), () {
      state = state.copyWith(title: title);
    });
  }

  void setDescription(String description) {
    if (_descriptionDebouncer != null) {
      _descriptionDebouncer?.cancel();
    }
    _titleDebouncer = Timer(const Duration(milliseconds: 200), () {
      if (description.isEmpty) {
        state = state.copyWith(setDescriptionToNull: true);
      } else {
        state = state.copyWith(description: description);
      }
    });
  }

  void setTodoColor(TodoColor todoColor) {
    if (state.todoColor == todoColor) {
      state = state.copyWith(setTodoColorToNull: true);
    } else {
      state = state.copyWith(todoColor: todoColor);
    }
  }

  void setDueDate(DateTime? date) {
    if (date != null) {
      state = state.copyWith(dueDate: date);
    } else {
      state = state.copyWith(setDueDateToNull: true);
    }
  }

  Future<void> addTodo() async {
    if (state.title.isEmpty) {
      HelperFunctions.showErrorSnackBar(message: "Title can not be empty");
      return;
    }
    try {
      final todoUser = ref.read(todoUserProvider).value!;
      final Todo todo = state.copyWith(owner: todoUser.userName, collaborators: [todoUser.userName], createdAt: DateTime.now());
      await getIt<DatabaseService>().addtodo(todo: todo);
      state = Todo.empty();
    } catch (e) {
      HelperFunctions.showErrorSnackBar(message: e.toString());
      debugPrint(e.toString());
    }
  }
}
