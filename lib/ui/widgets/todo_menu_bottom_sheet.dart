import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/controllers/todo_menu_bottom_sheet_controller.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/navigation_service.dart';

class TodoMenuBS extends ConsumerWidget {
  final Todo todo;
  const TodoMenuBS({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoUser = ref.read(todoUserProvider).value!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.thumbtack),
          title: todo.pinnedBy.contains(todoUser.userName) ? const Text('Unpin Todo') : const Text('Pin Todo'),
          onTap: () {
            getIt<NavigationService>().goBack();
            if (!todo.pinnedBy.contains(todoUser.userName)) {
              ref.read(todoMenuBSControllerProvider.notifier).pinTodo(todoId: todo.id, userName: todoUser.userName);
            } else {
              ref.read(todoMenuBSControllerProvider.notifier).unpinTodo(todoId: todo.id, userName: todoUser.userName);
            }
          },
        ),
        if (todo.owner == todoUser.userName)
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.userPlus),
            title: const Text('Add Collaborator'),
            onTap: () {
              getIt<NavigationService>().goBack();
              getIt<NavigationService>().routeTo('/addCollaborator', arguments: todo);
            },
          ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.trash),
          title: const Text('Delete Todo'),
          onTap: () async {
            await _showDeleteDialog(context, ref);
            getIt<NavigationService>().goBack();
          },
        ),
      ],
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
                onPressed: () {
                  getIt<NavigationService>().goBack();
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                getIt<NavigationService>().goBack();
                ref.read(todoMenuBSControllerProvider.notifier).deleteTodo(todoId: todo.id);
              },
              child: const Text('Yes'),
            )
          ],
        );
      },
    );
  }
}
