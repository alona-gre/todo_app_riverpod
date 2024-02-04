import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_todo_app/src/features/added/application/added_service.dart';
import 'package:riverpod_todo_app/src/features/added/domain/added.dart';
import 'package:riverpod_todo_app/src/features/added/presentation/added/added_items_builder.dart';
import 'package:riverpod_todo_app/src/features/added/presentation/added/added_item.dart';
import 'package:riverpod_todo_app/src/features/added/presentation/added/added_tasks_screen_controller.dart';
import 'package:riverpod_todo_app/src/utils/async_value_ui.dart';

class AddedTasksScreen extends ConsumerWidget {
  const AddedTasksScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      addedTasksScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final addedValue = ref.watch(addedProvider);
    debugPrint(addedValue.toString());

    return AsyncValueWidget(
      value: addedValue,
      data: (added) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Chip(
              label: Text(
                  '${added.toAddedItemsList().length} Added | ${added.toAddedItemsList().length} All'),
            ),
          ),

          /// TODO: create a common widget, e.g. TasksItemsBuilder
          AddedItemsBuilder(
            items: added.toAddedItemsList(),
            itemBuilder: (_, item, index) => AddedItemWidget(
              addedItem: item,
              itemIndex: index,
            ),
          ),
        ],
      ),
    );
  }
}
