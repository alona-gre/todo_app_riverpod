// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/added/domain/addedItem.dart';

/// Model class representing the Added contents.
class Added {
  const Added([this.items = const {}]);

  /// All the items in the Added, where:
  /// - key: Task ID
  /// - value: Task (with all its properties)
  final Map<TaskID, Task> items;

  @override
  String toString() => 'added(items: $items)';

  Map<String, dynamic> toMap() {
    return {
      'items': items,
    };
  }

  factory Added.fromMap(Map<String, dynamic> map) {
    return Added(
      Map<TaskID, Task>.from(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Added.fromJson(String source) => Added.fromMap(json.decode(source));

  @override
  bool operator ==(covariant Added other) {
    if (identical(this, other)) return true;

    return mapEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;
}

extension AddedItems on Added {
  /// this method converts a Map of items into a List of items
  /// used to display all the items of the Added
  List<AddedItem> toAddedItemsList() {
    return items.entries.map((entry) {
      return AddedItem(
        taskId: entry.key,
        task: entry.value,
      );
    }).toList();
  }
}
