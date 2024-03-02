import 'package:uuid/uuid.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
/// * The task identifier is an important concept and can have its own type.
typedef TaskID = String;

/// Class representing a task.
class Task {
  final String? title;
  final String? notes;
  final TaskID? id;
  final String? createdDate;
  final bool? isCompleted;
  final bool? isDeleted;
  final bool? isStarred;

  const Task({
    this.title,
    this.notes,
    this.id,
    this.createdDate,
    this.isCompleted = false,
    this.isDeleted = false,
    this.isStarred = false,
  });

  Task copyWith({
    String? title,
    String? notes,
    TaskID? id,
    String? createdDate,
    bool? isCompleted,
    bool? isDeleted,
    bool? isStarred,
  }) {
    return Task(
      title: title ?? this.title,
      notes: notes ?? this.notes,
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      isStarred: isStarred ?? this.isStarred,
    );
  }

  @override
  String toString() {
    return 'Task(title: $title, notes: $notes, id: $id, createdDate: $createdDate, isCompleted: $isCompleted, isDeleted: $isDeleted, isStarred: $isStarred)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.notes == notes &&
        other.id == id &&
        other.createdDate == createdDate &&
        other.isCompleted == isCompleted &&
        other.isDeleted == isDeleted &&
        other.isStarred == isStarred;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        notes.hashCode ^
        id.hashCode ^
        createdDate.hashCode ^
        isCompleted.hashCode ^
        isDeleted.hashCode ^
        isStarred.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'notes': notes,
      'id': id,
      'createdDate': createdDate,
      'isCompleted': isCompleted,
      'isDeleted': isDeleted,
      'isStarred': isStarred,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] != null ? map['title'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      id: map['id'] != null
          ? map['id'] as TaskID
          : const Uuid().v4().toString(),
      createdDate:
          map['createdDate'] != null ? map['createdDate'] as String : null,
      isCompleted:
          map['isCompleted'] != null ? map['isCompleted'] as bool : null,
      isDeleted: map['isDeleted'] != null ? map['isDeleted'] as bool : null,
      isStarred: map['isStarred'] != null ? map['isStarred'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'notes': notes,
        'id': id,
        'createdDate': createdDate,
        'isCompleted': isCompleted,
        'isDeleted': isDeleted,
        'isStarred': isStarred,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'] != null ? json['title'] as String : null,
        notes: json['notes'] != null ? json['notes'] as String : null,
        id: json['id'] != null
            ? json['id'] as TaskID
            : const Uuid().v4().toString(),
        createdDate:
            json['createdDate'] != null ? json['createdDate'] as String : null,
        isCompleted:
            json['isCompleted'] != null ? json['isCompleted'] as bool : null,
        isDeleted: json['isDeleted'] != null ? json['isDeleted'] as bool : null,
        isStarred: json['isStarred'] != null ? json['isStarred'] as bool : null,
      );
}
