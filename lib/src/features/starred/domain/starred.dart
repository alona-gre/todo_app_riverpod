// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starredItem.dart';

/// Model class representing the Starred contents.
class Starred {
  const Starred([this.items = const {}]);

  /// All the items in the Starred, where:
  /// - key: product ID
  /// - value: bool (whether it is starred)
  final Map<TaskID, bool> items;

  @override
  String toString() => 'starred(items: $items)';

  Map<String, dynamic> toMap() {
    return {
      'items': items,
    };
  }

  factory Starred.fromMap(Map<String, dynamic> map) {
    return Starred(
      Map<TaskID, bool>.from(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Starred.fromJson(String source) =>
      Starred.fromMap(json.decode(source));

  @override
  bool operator ==(covariant Starred other) {
    if (identical(this, other)) return true;

    return mapEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;
}

extension StarredItems on Starred {
  /// this method converts a Map of items into a List of items
  /// used to display all the items of the Starred
  List<StarredItem> toStarredItemsList() {
    return items.entries.map((entry) {
      return StarredItem(
        taskId: entry.key,
        isStarred: entry.value,
      );
    }).toList();
  }
}
