/// Class representing a task.
class Task {
  final String? title;
  final String? notes;
  final String id;
  final String? createdDate;
  final bool? isDone;
  final bool? isDeleted;
  final bool? isFavorite;

  const Task({
    this.title,
    this.notes,
    required this.id,
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
}
