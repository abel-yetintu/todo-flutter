import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/database_service.dart';
import 'package:todo/services/navigation_service.dart';

final addCollaboratorControllerProvider = AutoDisposeNotifierProvider<AddCollaboratorController, void>(() {
  return AddCollaboratorController();
});

class AddCollaboratorController extends AutoDisposeNotifier<void> {
  @override
  void build() {}

  Future<bool> addCollaborator({required TodoUser todoUser, required Todo todo}) async {
    try {
      showNonDismissibleLoadingDialog(getIt<GlobalKey<NavigatorState>>().currentContext!);
      await getIt<DatabaseService>().addCollaborator(todoId: todo.id, userName: todoUser.userName);
      getIt<NavigationService>().goBack();
      HelperFunctions.showSnackBar(message: 'Collaborator Added');
      return true;
    } catch (e) {
      getIt<NavigationService>().goBack();
      debugPrint(e.toString());
      HelperFunctions.showErrorSnackBar(message: 'Unkown error. Please try again later');
      return false;
    }
  }
}
