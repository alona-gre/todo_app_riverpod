import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/added/domain/added.dart';
import 'package:riverpod_todo_app/src/features/added/domain/addedItem.dart';

/// Helper extension used to mutate the items in the added.
extension MutableAdded on Added {
  /// set a product as added
  addItem(AddedItem addedItem) {
    final copy = Map<TaskID, Task>.from(items);
    final newTask = {
      addedItem.taskId: addedItem.task,
    };
    copy.addEntries(newTask.entries);
    return Added(copy);
  }

  // /// if an item with the given productId is found, remove it
  // Added removeFromAddedById(TaskID productId) {
  //   final copy = Map<TaskID, bool>.from(items);
  //   copy.remove(productId);
  //   return Added(copy);
  // }

  // /// adds a list of addedItems by updating isAdded value
  // /// used when syncing local to remote added
  // Added addAddedItems(List<AddedItem> itemsToAdd) {
  //   final copy = Map<TaskID, bool>.from(items);
  //   for (var item in itemsToAdd) {
  //     copy.update(
  //       item.taskId,
  //       // if there is already a value, update it by adding the isAdded value
  //       (value) => item.isAdded,
  //       ifAbsent: () => item.isAdded,
  //     );
  //   }
  //   return Added(copy);
  // }
}
