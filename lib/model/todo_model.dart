class TodoModel {
  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  final int id;
  final DateTime createdAt;
  final String title;
  final String description;

  static TodoModel fromJson(Map<String, Object?> json) {
    return TodoModel(
      id: int.parse(json['id'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }

  Map<String, Object?> toJson() => {
    'title': title,
    'description': description,
    'created_at': createdAt.toUtc().toIso8601String(),
  };
}
