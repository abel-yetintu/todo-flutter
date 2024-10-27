enum TodoStatus {
  notStarted(displayName: 'Not Started'),
  inProgress(displayName: 'In Progress'),
  completed(displayName: 'Completed');

  final String displayName;

  const TodoStatus({required this.displayName});
}
