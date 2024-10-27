import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/core/enums/todo_color.dart';
import 'package:todo/core/enums/todo_status.dart';

class Todo {
  final String id;
  final String title;
  final String? description;
  final String owner;
  final List<String> collaborators;
  final List<String> pinnedBy;
  final TodoStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final TodoColor? todoColor;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.owner,
    required this.collaborators,
    required this.pinnedBy,
    required this.status,
    required this.createdAt,
    required this.dueDate,
    required this.todoColor,
  });

  Todo.empty()
      : id = '',
        title = '',
        description = null,
        owner = '',
        collaborators = [],
        pinnedBy = [],
        status = TodoStatus.notStarted,
        createdAt = DateTime.now(),
        dueDate = null,
        todoColor = null;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    String? owner,
    List<String>? collaborators,
    List<String>? pinnedBy,
    TodoStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    TodoColor? todoColor,
    bool setDescriptionToNull = false,
    bool setDueDateToNull = false,
    bool setTodoColorToNull = false,
  }) {
    return Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: setDescriptionToNull ? null : description ?? this.description,
        owner: owner ?? this.owner,
        collaborators: collaborators ?? List.from(this.collaborators),
        pinnedBy: pinnedBy ?? List.from(this.pinnedBy),
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        dueDate: setDueDateToNull ? null : dueDate ?? this.dueDate,
        todoColor: setTodoColorToNull ? null : todoColor ?? this.todoColor);
  }

  factory Todo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Todo(
      id: data['id'],
      title: data['title'] as String,
      description: data['description'],
      owner: data['owner'] as String,
      collaborators: List<String>.from(data['collaborators']),
      pinnedBy: List<String>.from(data['pinnedBy']),
      status: TodoStatus.values.firstWhere(
        (s) {
          return s.displayName == data['status'];
        },
        orElse: () {
          return TodoStatus.notStarted;
        },
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
      dueDate: data['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(data['dueDate'] as int) : null,
      todoColor: data['todoColor'] != null
          ? TodoColor.values.firstWhere(
              (tc) {
                return tc.name == data['todoColor'];
              },
              orElse: () {
                return TodoColor.brightCoral;
              },
            )
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'owner': owner,
      'collaborators': collaborators,
      'pinnedBy': pinnedBy,
      'status': status.displayName,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'todoColor': todoColor?.name,
    };
  }
}
