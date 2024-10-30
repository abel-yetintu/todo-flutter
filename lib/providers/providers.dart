import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/enums/todo_filter.dart';
import 'package:todo/core/enums/todo_status.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/database_service.dart';

final authStateChangesProvider = StreamProvider.autoDispose((ref) {
  return getIt<AuthService>().authStateChanges;
});

final navigationMenuIndexProvider = StateProvider.autoDispose((ref) => 0);

final todoUserProvider = StreamProvider.autoDispose((ref) {
  final signedInUser = ref.watch(authStateChangesProvider).value;
  if (signedInUser != null) {
    return getIt<DatabaseService>().getUser(uid: signedInUser.uid);
  } else {
    return Stream<TodoUser>.error('Sign in first');
  }
});

final todosProvider = StreamProvider((ref) {
  final todoUser = ref.watch(todoUserProvider).value!;
  return getIt<DatabaseService>().getTodos(userName: todoUser.userName);
});

final filteredTodosProvider = FutureProvider((ref) async {
  final todos = await ref.watch(todosProvider.future);
  final selectedFilter = ref.watch(todoFilterProvider);

  switch (selectedFilter) {
    case TodoFilter.all:
      return todos;
    case TodoFilter.notStarted:
      return todos.where((todo) => todo.status == TodoStatus.notStarted).toList();
    case TodoFilter.inProgress:
      return todos.where((todo) => todo.status == TodoStatus.inProgress).toList();
    case TodoFilter.completed:
      return todos.where((todo) => todo.status == TodoStatus.completed).toList();
  }
});

final todoProvider = StreamProvider.family((ref, String id) {
  return getIt<DatabaseService>().getTodo(id: id);
});

final isTodosGridViewProvider = StateProvider((ref) => true);

final todoFilterProvider = StateProvider((ref) => TodoFilter.all);

final conversationsProvider = StreamProvider((ref) {
  final todoUser = ref.watch(todoUserProvider).value!;
  return getIt<DatabaseService>().getConverstations(uid: todoUser.uid);
});
