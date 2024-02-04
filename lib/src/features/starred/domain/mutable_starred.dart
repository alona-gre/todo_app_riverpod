import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starred.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starredItem.dart';

/// Helper extension used to mutate the items in the starred.
extension MutableStarred on Starred {
  /// set a product as starred
  Starred setStarredItem(StarredItem starredItem) {
    final copy = Map<TaskID, bool>.from(items);
    copy[starredItem.taskId] = true;
    return Starred(copy);
  }

  /// if an item with the given productId is found, remove it
  Starred removeFromStarredById(TaskID productId) {
    final copy = Map<TaskID, bool>.from(items);
    copy.remove(productId);
    return Starred(copy);
  }

  /// adds a list of starredItems by updating isStarred value
  /// used when syncing local to remote starred
  Starred addStarredItems(List<StarredItem> itemsToAdd) {
    final copy = Map<TaskID, bool>.from(items);
    for (var item in itemsToAdd) {
      copy.update(
        item.taskId,
        // if there is already a value, update it by adding the isStarred value
        (value) => item.isStarred,
        ifAbsent: () => item.isStarred,
      );
    }
    return Starred(copy);
  }
}
