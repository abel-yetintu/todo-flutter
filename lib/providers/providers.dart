import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
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
