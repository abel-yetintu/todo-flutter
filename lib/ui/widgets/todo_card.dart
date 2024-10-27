import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/enums/todo_status.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/ui/widgets/todo_menu_bottom_sheet.dart';

class TodoCard extends ConsumerWidget {
  final Todo todo;
  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () {
        _showTodoMenuBs(context);
      },
      onTap: () {
        getIt<NavigationService>().routeTo('/todoDetail', arguments: todo.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .02, vertical: context.screenHeight * .01),
        decoration: BoxDecoration(
          color: todo.todoColor?.colorValue,
          border: Border.all(color: context.colorScheme.secondary, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    todo.title,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: todo.todoColor != null ? Colors.white : context.colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      decoration: todo.status == TodoStatus.completed ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (todo.pinnedBy.contains(ref.read(todoUserProvider).value!.userName))
                  Row(
                    children: [
                      addHorizontalSpace(context.screenWidth * .01),
                      FaIcon(
                        FontAwesomeIcons.thumbtack,
                        color: todo.todoColor != null ? Colors.white : context.colorScheme.onSurface,
                        size: context.screenWidth * .04,
                      ),
                    ],
                  )
              ],
            ),
            if (todo.description != null)
              Column(
                children: [
                  addVerticalSpace(context.screenHeight * .01),
                  Text(
                    todo.description!,
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: todo.todoColor != null ? Colors.white : context.colorScheme.onSurface,
                      fontWeight: FontWeight.w300,
                      decoration: todo.status == TodoStatus.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            addVerticalSpace(context.screenHeight * .01),
            Text(
              todo.status.displayName,
              style: context.textTheme.labelSmall?.copyWith(
                color: todo.todoColor != null ? Colors.white : context.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showTodoMenuBs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return TodoMenuBS(
          todo: todo,
        );
      },
    );
  }
}
