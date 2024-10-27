import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/enums/todo_status.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/ui/widgets/edit_todo_bottom_sheet.dart';

class TodoDetailScreen extends ConsumerWidget {
  final String id;
  const TodoDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(todoProvider(id)).when(
          loading: () => _loadingUI(context),
          error: (error, stackTrace) => _errorUI(error),
          data: (todo) {
            final textColor = todo.todoColor != null ? Colors.white : null;
            return Scaffold(
              backgroundColor: todo.todoColor?.colorValue,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(context.screenWidth * .05, context.screenHeight * .02, context.screenWidth * .05, 0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                getIt<NavigationService>().goBack();
                              },
                              child: FaIcon(
                                FontAwesomeIcons.arrowLeft,
                                color: textColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showEditTodoBs(context, todo);
                              },
                              child: FaIcon(
                                FontAwesomeIcons.pencil,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(context.screenHeight * .02),
                        Text(
                          'Title',
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        addVerticalSpace(context.screenHeight * .01),
                        Text(
                          todo.title,
                          style: TextStyle(
                            color: textColor,
                            decoration: todo.status == TodoStatus.completed ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        if (todo.description != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addVerticalSpace(context.screenHeight * .02),
                              Text(
                                'Description',
                                style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: textColor),
                              ),
                              addVerticalSpace(context.screenHeight * .01),
                              Text(
                                todo.description!,
                                style: TextStyle(
                                  color: textColor,
                                  decoration: todo.status == TodoStatus.completed ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ],
                          ),
                        addVerticalSpace(context.screenHeight * .02),
                        Text(
                          'Status',
                          style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: textColor),
                        ),
                        addVerticalSpace(context.screenHeight * .01),
                        Text(
                          todo.status.displayName,
                          style: TextStyle(color: textColor),
                        ),
                        if (todo.dueDate != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addVerticalSpace(context.screenHeight * .02),
                              Text(
                                'Due Date',
                                style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: textColor),
                              ),
                              addVerticalSpace(context.screenHeight * .01),
                              Text(
                                todo.dueDate!.getMonthDay(),
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                        if (todo.collaborators.length > 1)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addVerticalSpace(context.screenHeight * .02),
                              Text(
                                'Collaborators',
                                style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: textColor),
                              ),
                              addVerticalSpace(context.screenHeight * .01),
                              SizedBox(
                                height: context.screenHeight * .4,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: todo.collaborators.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: context.screenHeight * .01),
                                      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .02, vertical: context.screenHeight * .01),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: textColor ?? context.colorScheme.onSurface),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "@${todo.collaborators[index]}",
                                            style: TextStyle(color: textColor),
                                          ),
                                          if (todo.owner == todo.collaborators[index])
                                            Text(
                                              'Owner',
                                              style: TextStyle(color: textColor),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
  }

  Widget _errorUI(Object error) {
    return Scaffold(
      body: Center(
        child: Text(error.toString()),
      ),
    );
  }

  Widget _loadingUI(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitThreeBounce(
          color: context.colorScheme.tertiary,
        ),
      ),
    );
  }

  void _showEditTodoBs(BuildContext context, Todo todo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return EditTodoBS(
          todo: todo,
        );
      },
    );
  }
}
