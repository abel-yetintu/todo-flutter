import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/enums/todo_filter.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/providers/providers.dart';

class TodoFilterChip extends ConsumerWidget {
  final TodoFilter todoFilter;
  const TodoFilterChip({super.key, required this.todoFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(todoFilterProvider);
    return GestureDetector(
      onTap: () {
        if (ref.read(todoFilterProvider) != todoFilter) {
          ref.read(todoFilterProvider.notifier).update((previousFilter) => todoFilter);
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: context.screenWidth * .02),
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .02, vertical: context.screenHeight * .01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: selectedFilter == todoFilter ? context.colorScheme.primaryContainer : context.colorScheme.secondaryContainer,
        ),
        child: Text(
          todoFilter.displayName,
          style: context.textTheme.bodySmall?.copyWith(
            color: selectedFilter == todoFilter ? context.colorScheme.onPrimaryContainer : context.colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
