// ignore_for_file: public_member_api_docs, sort_constructors_first
/// * The task identifier is an important concept and can have its own type.
typedef TaskID = String;

/// Class representing a task.
class Task {
  final String? title;
  final String? notes;
  final TaskID? id;
  final String? createdDate;
  final bool? isDone;
  final bool? isDeleted;
  final bool? isFavorite;

  const Task({
    this.title,
    this.notes,
    this.id,
    this.createdDate,
    this.isDone = false,
    this.isDeleted = false,
    this.isFavorite = false,
  });

  Task copyWith({
    String? title,
    String? notes,
    String? id,
    String? createdDate,
    bool? isDone,
    bool? isDeleted,
    bool? isFavorite,
  }) {
    return Task(
      title: title ?? this.title,
      notes: notes ?? this.notes,
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      isDone: isDone ?? this.isDone,
      isDeleted: isDeleted ?? this.isDeleted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Task(title: $title, notes: $notes, id: $id, createdDate: $createdDate, isDone: $isDone, isDeleted: $isDeleted, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.notes == notes &&
        other.id == id &&
        other.createdDate == createdDate &&
        other.isDone == isDone &&
        other.isDeleted == isDeleted &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        notes.hashCode ^
        id.hashCode ^
        createdDate.hashCode ^
        isDone.hashCode ^
        isDeleted.hashCode ^
        isFavorite.hashCode;
  }
}
