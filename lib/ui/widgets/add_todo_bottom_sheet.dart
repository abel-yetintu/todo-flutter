import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/controllers/add_todo_bottom_sheet_controller.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/enums/todo_color.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/services/navigation_service.dart';

class AddTodoBS extends ConsumerStatefulWidget {
  const AddTodoBS({super.key});

  @override
  ConsumerState<AddTodoBS> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends ConsumerState<AddTodoBS> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom),
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.screenWidth * .05, context.screenHeight * .02, context.screenWidth * .05, 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Todo',
                style: context.textTheme.headlineSmall,
              ),
              addVerticalSpace(context.screenHeight * .02),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text Field for title

                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Title'),
                      textCapitalization: TextCapitalization.sentences,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (value) {
                        ref.read(addTodoBSControllerProvider.notifier).setTitle(value.trim());
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        return 'Enter Titile';
                      },
                    ),
                    addVerticalSpace(context.screenHeight * .01),

                    // Text Field for description

                    TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (value) {
                        ref.read(addTodoBSControllerProvider.notifier).setDescription(value.trim());
                      },
                    ),
                    addVerticalSpace(context.screenHeight * .02),

                    // Color selection options

                    Row(
                      children: TodoColor.values.map(
                        (todoColor) {
                          return Padding(
                            padding: EdgeInsets.only(right: context.screenWidth * .05),
                            child: GestureDetector(
                              onTap: () {
                                ref.read(addTodoBSControllerProvider.notifier).setTodoColor(todoColor);
                              },
                              child: Container(
                                width: context.screenWidth * .12,
                                height: context.screenWidth * .12,
                                decoration: BoxDecoration(
                                  color: todoColor.colorValue,
                                  borderRadius: BorderRadius.circular(8),
                                  border: ref.watch(addTodoBSControllerProvider).todoColor == todoColor
                                      ? Border.all(width: 2, color: context.colorScheme.primary)
                                      : null,
                                ),
                                child: ref.watch(addTodoBSControllerProvider).todoColor == todoColor
                                    ? Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.check,
                                          size: context.screenWidth * .05,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    addVerticalSpace(context.screenHeight * .02),

                    // Button to add due date

                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            _showDatePicker();
                          },
                          icon: const FaIcon(FontAwesomeIcons.plus),
                          label: const Text('Due Date'),
                        ),
                        addHorizontalSpace(context.screenWidth * .02),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .01, vertical: context.screenHeight * .01),
                            decoration: BoxDecoration(border: Border.all(width: 1, color: context.colorScheme.secondary)),
                            child: Text(
                              ref.watch(addTodoBSControllerProvider).dueDate?.getMonthDay() ?? 'Not Selected',
                              maxLines: 2,
                              style: context.textTheme.bodySmall,
                            ),
                          ),
                        ),
                        addHorizontalSpace(context.screenWidth * .02),
                        if (ref.watch(addTodoBSControllerProvider).dueDate != null)
                          InkWell(
                            onTap: () {
                              ref.read(addTodoBSControllerProvider.notifier).setDueDate(null);
                            },
                            child: FaIcon(
                              FontAwesomeIcons.x,
                              size: context.screenWidth * .05,
                            ),
                          )
                      ],
                    ),
                    addVerticalSpace(context.screenHeight * .02),

                    // Button to add todo

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            getIt<NavigationService>().goBack();
                            ref.read(addTodoBSControllerProvider.notifier).addTodo();
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ),
                    addVerticalSpace(context.screenHeight * .02),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        ref.read(addTodoBSControllerProvider.notifier).setDueDate(date);
      }
    });
  }
}
