/// Model for a single exercise within a workout template.
class TemplateExercise {
  final int? id;
  final int templateId;
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final int sortOrder;

  const TemplateExercise({
    this.id,
    required this.templateId,
    required this.name,
    this.sets = 3,
    this.reps = 10,
    this.weight = 0,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'template_id': templateId,
    'name': name,
    'sets': sets,
    'reps': reps,
    'weight': weight,
    'sort_order': sortOrder,
  };

  factory TemplateExercise.fromMap(Map<String, dynamic> map) {
    return TemplateExercise(
      id: map['id'] as int,
      templateId: map['template_id'] as int,
      name: map['name'] as String,
      sets: map['sets'] as int? ?? 3,
      reps: map['reps'] as int? ?? 10,
      weight: (map['weight'] as num?)?.toDouble() ?? 0,
      sortOrder: map['sort_order'] as int? ?? 0,
    );
  }

  TemplateExercise copyWith({
    int? id,
    int? templateId,
    String? name,
    int? sets,
    int? reps,
    double? weight,
    int? sortOrder,
  }) {
    return TemplateExercise(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
