class Plan {
  String name;
  String description;
  DateTime date;
  bool isCompleted;
  String category;
  String priority;

  Plan({
    required this.name,
    required this.description,
    required this.date,
    this.isCompleted = false,
    required this.category,
    required this.priority,
  });
}
