import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_todo_app/src/features/starred/application/starred_service.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starred.dart';
import 'package:riverpod_todo_app/src/features/starred/presentation/starred/starred_item.dart';
import 'package:riverpod_todo_app/src/features/starred/presentation/starred/starred_items_builder.dart';
import 'package:riverpod_todo_app/src/features/starred/presentation/starred/starred_screen_controller.dart';
import 'package:riverpod_todo_app/src/utils/async_value_ui.dart';

class StarredScreen extends ConsumerWidget {
  const StarredScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      starredScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final starredValue = ref.watch(starredProvider);
    //debugPrint(tasksListValue.toString());

    return AsyncValueWidget(
      value: starredValue,
      data: (starred) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Chip(
              label: Text(
                  '${starred.toStarredItemsList().length} Completed | ${starred.toStarredItemsList().length} All'),
            ),
          ),
          StarredItemsBuilder(
            items: starred.toStarredItemsList(),
            itemBuilder: (_, item, index) => StarredItemWidget(
              starredItem: item,
              itemIndex: index,
            ),
          ),
        ],
      ),
    );
  }
}
