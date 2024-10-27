import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/controllers/add_collaborator_controller.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/navigation_service.dart';

class CollaboratorUserTile extends ConsumerWidget {
  final TodoUser todoUser;
  final Todo todo;
  const CollaboratorUserTile({super.key, required this.todoUser, required this.todo});

  static Widget loading(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.screenHeight * .02),
      child: Row(
        children: [
          shimmerWidget(context: context, shape: BoxShape.circle, width: context.screenWidth * .14, height: context.screenHeight * .1),
          addHorizontalSpace(context.screenWidth * .03),
          shimmerWidget(context: context, width: context.screenWidth * .3, height: 16)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: context.screenHeight * .02),
      child: Row(
        children: [
          CircleAvatar(
            radius: context.screenWidth * .07,
            backgroundColor: context.colorScheme.primary,
            backgroundImage: todoUser.profilePicture.isNotEmpty ? NetworkImage(todoUser.profilePicture) : null,
            child: todoUser.profilePicture.isEmpty
                ? FaIcon(
                    FontAwesomeIcons.user,
                    color: context.colorScheme.onPrimary,
                    size: context.screenWidth * .05,
                  )
                : null,
          ),
          addHorizontalSpace(context.screenWidth * .03),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todoUser.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '@${todoUser.userName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (todo.owner != todoUser.userName)
                  TextButton.icon(
                    onPressed: () async {
                      var result = await ref.read(addCollaboratorControllerProvider.notifier).addCollaborator(todoUser: todoUser, todo: todo);
                      if (result) getIt<NavigationService>().goBack();
                    },
                    label: const Text('Add'),
                    icon: const FaIcon(FontAwesomeIcons.plus),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
