import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/core/enums/todo_filter.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/ui/widgets/add_todo_bottom_sheet.dart';
import 'package:todo/ui/widgets/todo_card.dart';
import 'package:todo/ui/widgets/todo_filter_chip.dart';
import 'package:todo/ui/widgets/todo_tile.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(filteredTodosProvider).when(
            skipLoadingOnReload: true,
            loading: () => _loadingUI(context),
            error: (error, stackTrace) {
              debugPrintStack();
              return _errorUI(context, error);
            },
            data: (todos) {
              final isGridView = ref.watch(isTodosGridViewProvider);
              return Padding(
                padding: EdgeInsets.fromLTRB(context.screenWidth * .05, context.screenHeight * .02, context.screenWidth * .05, 0),
                child: Column(
                  children: [
                    // Todos filter options

                    Row(
                      children: List<Widget>.from(
                        TodoFilter.values.map((todoFilter) => TodoFilterChip(todoFilter: todoFilter)),
                      ),
                    ),
                    addVerticalSpace(context.screenHeight * .02),

                    // Option to switch between list view and grid view

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(isTodosGridViewProvider.notifier).update((prevState) => true);
                          },
                          child: Container(
                            padding: EdgeInsets.all(context.screenWidth * .02),
                            decoration: BoxDecoration(
                              color: isGridView ? context.colorScheme.primaryContainer : null,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.tableCellsLarge,
                              size: context.screenWidth * .05,
                              color: isGridView ? context.colorScheme.onPrimaryContainer : context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        addHorizontalSpace(context.screenWidth * .03),
                        GestureDetector(
                          onTap: () {
                            ref.read(isTodosGridViewProvider.notifier).update((prevState) => false);
                          },
                          child: Container(
                            padding: EdgeInsets.all(context.screenWidth * .02),
                            decoration: BoxDecoration(
                              color: isGridView ? null : context.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.list,
                              size: context.screenWidth * .05,
                              color: isGridView ? context.colorScheme.onSurface : context.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(context.screenHeight * .02),

                    // When there is no todos

                    if (todos.isEmpty && ref.read(todoFilterProvider) == TodoFilter.all)
                      const Expanded(
                        child: Center(
                          child: Text('Add a todo to get started!'),
                        ),
                      ),

                    //  List View of Todos

                    if (!isGridView && todos.isNotEmpty)
                      Builder(builder: (context) {
                        final todoUser = ref.watch(todoUserProvider).value!;
                        final sortedList = List.of(todos)
                          ..sort((todo1, todo2) {
                            final todo1IsPinned = todo1.pinnedBy.contains(todoUser.userName);
                            final todo2IsPinned = todo2.pinnedBy.contains(todoUser.userName);

                            if (todo1IsPinned && !todo2IsPinned) return -1;
                            if (!todo1IsPinned && todo2IsPinned) return 1;
                            return 0;
                          });
                        return Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: sortedList.length,
                            itemBuilder: (context, index) {
                              return TodoTile(todo: sortedList[index]);
                            },
                          ),
                        );
                      }),

                    // Grid view of todos

                    if (isGridView && todos.isNotEmpty)
                      Builder(builder: (context) {
                        final todoUser = ref.watch(todoUserProvider).value!;
                        final sortedList = List.of(todos)
                          ..sort((todo1, todo2) {
                            final todo1IsPinned = todo1.pinnedBy.contains(todoUser.userName);
                            final todo2IsPinned = todo2.pinnedBy.contains(todoUser.userName);

                            if (todo1IsPinned && !todo2IsPinned) return -1;
                            if (!todo1IsPinned && todo2IsPinned) return 1;
                            return 0;
                          });
                        return Expanded(
                          child: MasonryGridView.builder(
                            physics: const BouncingScrollPhysics(),
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            itemCount: sortedList.length,
                            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return TodoCard(todo: sortedList[index]);
                            },
                          ),
                        );
                      }),
                  ],
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoBottomSheet(context);
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }

  Widget _loadingUI(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: context.colorScheme.tertiary,
      ),
    );
  }

  Widget _errorUI(BuildContext context, Object error) {
    return Center(
      child: Text(error.toString()),
    );
  }

  void _showAddTodoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return const AddTodoBS();
      },
    );
  }
}
