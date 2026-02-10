import 'package:sqflite/sqflite.dart';
import '../models/template_exercise.dart';
import '../models/workout_template.dart';
import 'database_helper.dart';

/// Repository for CRUD operations on workout templates and their exercises.
class TemplateRepository {
  Future<Database> get _db => DatabaseHelper.instance.database;

  // ──────────────────── Templates ────────────────────

  /// Get all templates, each with its exercises pre-loaded.
  Future<List<WorkoutTemplate>> getAllTemplates() async {
    final db = await _db;
    final rows = await db.query('templates', orderBy: 'created_at DESC');

    final templates = <WorkoutTemplate>[];
    for (final row in rows) {
      final exercises = await _exercisesForTemplate(db, row['id'] as int);
      templates.add(WorkoutTemplate.fromMap(row, exercises: exercises));
    }
    return templates;
  }

  /// Insert a new template. Returns the new id.
  Future<int> insertTemplate(WorkoutTemplate template) async {
    final db = await _db;
    return db.insert('templates', template.toMap());
  }

  /// Update an existing template (name/tags only).
  Future<void> updateTemplate(WorkoutTemplate template) async {
    final db = await _db;
    await db.update(
      'templates',
      template.toMap(),
      where: 'id = ?',
      whereArgs: [template.id],
    );
  }

  /// Delete a template and its exercises (cascade via FK).
  Future<void> deleteTemplate(int id) async {
    final db = await _db;
    // manually delete exercises first since sqflite doesn't enforce FK by default
    await db.delete(
      'template_exercises',
      where: 'template_id = ?',
      whereArgs: [id],
    );
    await db.delete('templates', where: 'id = ?', whereArgs: [id]);
  }

  // ──────────────────── Exercises ────────────────────

  Future<List<TemplateExercise>> _exercisesForTemplate(
    Database db,
    int templateId,
  ) async {
    final rows = await db.query(
      'template_exercises',
      where: 'template_id = ?',
      whereArgs: [templateId],
      orderBy: 'sort_order ASC',
    );
    return rows.map(TemplateExercise.fromMap).toList();
  }

  /// Get exercises for a given template id.
  Future<List<TemplateExercise>> getExercisesForTemplate(int templateId) async {
    final db = await _db;
    return _exercisesForTemplate(db, templateId);
  }

  /// Add an exercise to a template. Returns new exercise id.
  Future<int> addExercise(TemplateExercise exercise) async {
    final db = await _db;
    return db.insert('template_exercises', exercise.toMap());
  }

  /// Update an existing exercise.
  Future<void> updateExercise(TemplateExercise exercise) async {
    final db = await _db;
    await db.update(
      'template_exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  /// Delete an exercise by id.
  Future<void> deleteExercise(int id) async {
    final db = await _db;
    await db.delete('template_exercises', where: 'id = ?', whereArgs: [id]);
  }
}
