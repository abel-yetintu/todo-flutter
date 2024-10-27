enum TodoFilter {
  all(displayName: 'All'),
  notStarted(displayName: 'Not Started'),
  inProgress(displayName: 'In Progress'),
  completed(displayName: 'Completed');

  final String displayName;

  const TodoFilter({required this.displayName});
}
