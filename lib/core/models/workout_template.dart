import 'template_exercise.dart';

/// Model for a workout template (e.g., "Push Day — Hypertrophy").
class WorkoutTemplate {
  final int? id;
  final String name;
  final List<String> tags; // e.g., ["Chest", "Shoulders", "Triceps"]
  final String? createdAt;
  final List<TemplateExercise> exercises;

  const WorkoutTemplate({
    this.id,
    required this.name,
    this.tags = const [],
    this.createdAt,
    this.exercises = const [],
  });

  /// Approximate workout duration based on exercise count.
  String get estimatedDuration => '${exercises.length * 8} min';

  /// Number of exercises.
  int get exerciseCount => exercises.length;

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'tags': tags.join(','),
  };

  factory WorkoutTemplate.fromMap(
    Map<String, dynamic> map, {
    List<TemplateExercise> exercises = const [],
  }) {
    final rawTags = map['tags'] as String? ?? '';
    return WorkoutTemplate(
      id: map['id'] as int,
      name: map['name'] as String,
      tags: rawTags.isEmpty ? [] : rawTags.split(','),
      createdAt: map['created_at'] as String?,
      exercises: exercises,
    );
  }

  WorkoutTemplate copyWith({
    int? id,
    String? name,
    List<String>? tags,
    String? createdAt,
    List<TemplateExercise>? exercises,
  }) {
    return WorkoutTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      exercises: exercises ?? this.exercises,
    );
  }
}
