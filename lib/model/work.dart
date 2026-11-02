
class Work {
  int? id;
  String name;
  String description;
  bool isCompleted;

  Work({
    this.id,
    required this.name,
    required this.description,
    this.isCompleted = false,
  });

  factory Work.fromMap(Map<String, dynamic> map) {
    return Work(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'is_completed': isCompleted ? 1 : 0,
    };
  }
}
