import 'package:riverpod_todo_app/src/common_widgets/shimmer_loading_cart_items_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/error_message_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/fake_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/task_list/task_tile.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starredItem.dart';

/// Shows a starred item (or loading/error UI if needed)
class StarredItemWidget extends ConsumerWidget {
  const StarredItemWidget({
    super.key,
    required this.starredItem,
    required this.itemIndex,
  });
  final StarredItem starredItem;
  final int itemIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskValue = ref.watch(taskProvider(starredItem.taskId));
    return taskValue.when(
        data: (task) => TaskTile(task: task!),
        error: (e, st) => Center(child: ErrorMessageWidget(e.toString())),
        loading: () => const ShimmerLoadingCartItem(height: 60.0, margin: 2.0));
  }
}
