import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/template_repository.dart';
import '../../../core/models/template_exercise.dart';

// ─── Data models for a live workout ───

/// One tracked set within an active workout.
class WorkoutSet {
  final int setNumber;
  final double weight;
  final int reps;
  final bool isCompleted;

  const WorkoutSet({
    required this.setNumber,
    this.weight = 0,
    this.reps = 0,
    this.isCompleted = false,
  });

  WorkoutSet copyWith({double? weight, int? reps, bool? isCompleted}) {
    return WorkoutSet(
      setNumber: setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// One exercise with its tracked sets.
class WorkoutExercise {
  final String name;
  final List<WorkoutSet> sets;

  const WorkoutExercise({required this.name, this.sets = const []});

  WorkoutExercise copyWith({String? name, List<WorkoutSet>? sets}) {
    return WorkoutExercise(name: name ?? this.name, sets: sets ?? this.sets);
  }

  int get completedSets => sets.where((s) => s.isCompleted).length;

  double get totalVolume => sets
      .where((s) => s.isCompleted)
      .fold(0, (sum, s) => sum + s.weight * s.reps);
}

/// Full active workout state.
class ActiveWorkoutState {
  final String templateName;
  final List<WorkoutExercise> exercises;
  final int elapsedSeconds;
  final bool isActive;

  const ActiveWorkoutState({
    this.templateName = 'Quick Workout',
    this.exercises = const [],
    this.elapsedSeconds = 0,
    this.isActive = false,
  });

  ActiveWorkoutState copyWith({
    String? templateName,
    List<WorkoutExercise>? exercises,
    int? elapsedSeconds,
    bool? isActive,
  }) {
    return ActiveWorkoutState(
      templateName: templateName ?? this.templateName,
      exercises: exercises ?? this.exercises,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isActive: isActive ?? this.isActive,
    );
  }

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets.length);
  int get completedSets => exercises.fold(0, (sum, e) => sum + e.completedSets);
  double get totalVolume => exercises.fold(0, (sum, e) => sum + e.totalVolume);

  double get progress => totalSets > 0 ? completedSets / totalSets : 0;

  String get timerDisplay {
    final h = elapsedSeconds ~/ 3600;
    final m = (elapsedSeconds % 3600) ~/ 60;
    final s = elapsedSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }
}

// ─── Provider ───

final activeWorkoutProvider =
    NotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>(
      ActiveWorkoutNotifier.new,
    );

class ActiveWorkoutNotifier extends Notifier<ActiveWorkoutState> {
  Timer? _timer;

  @override
  ActiveWorkoutState build() {
    ref.onDispose(() => _timer?.cancel());
    return const ActiveWorkoutState();
  }

  /// Start a workout from a template.
  Future<void> startFromTemplate(int templateId) async {
    final repo = TemplateRepository();
    final exercises = await repo.getExercisesForTemplate(templateId);
    final templates = await repo.getAllTemplates();
    final template = templates.where((t) => t.id == templateId).firstOrNull;

    final workoutExercises = exercises
        .map((e) => _toWorkoutExercise(e))
        .toList();

    state = ActiveWorkoutState(
      templateName: template?.name ?? 'Workout',
      exercises: workoutExercises,
      isActive: true,
    );
    _startTimer();
  }

  /// Start an empty workout.
  void startEmpty() {
    state = const ActiveWorkoutState(
      templateName: 'Quick Workout',
      exercises: [],
      isActive: true,
    );
    _startTimer();
  }

  /// Add a new exercise by name.
  void addExercise(String name, {int defaultSets = 3, int defaultReps = 10}) {
    final sets = List.generate(
      defaultSets,
      (i) => WorkoutSet(setNumber: i + 1, reps: defaultReps),
    );
    final exercise = WorkoutExercise(name: name, sets: sets);
    state = state.copyWith(exercises: [...state.exercises, exercise]);
  }

  /// Add a set to exercise at [exerciseIndex].
  void addSet(int exerciseIndex) {
    final exercises = [...state.exercises];
    final exercise = exercises[exerciseIndex];
    final newSetNumber = exercise.sets.length + 1;
    // Default to the same reps as the last set
    final lastReps = exercise.sets.isNotEmpty ? exercise.sets.last.reps : 10;
    final lastWeight = exercise.sets.isNotEmpty
        ? exercise.sets.last.weight
        : 0.0;
    exercises[exerciseIndex] = exercise.copyWith(
      sets: [
        ...exercise.sets,
        WorkoutSet(setNumber: newSetNumber, reps: lastReps, weight: lastWeight),
      ],
    );
    state = state.copyWith(exercises: exercises);
  }

  /// Update weight for a specific set.
  void updateWeight(int exerciseIndex, int setIndex, double weight) {
    final exercises = [...state.exercises];
    final exercise = exercises[exerciseIndex];
    final sets = [...exercise.sets];
    sets[setIndex] = sets[setIndex].copyWith(weight: weight);
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);
    state = state.copyWith(exercises: exercises);
  }

  /// Update reps for a specific set.
  void updateReps(int exerciseIndex, int setIndex, int reps) {
    final exercises = [...state.exercises];
    final exercise = exercises[exerciseIndex];
    final sets = [...exercise.sets];
    sets[setIndex] = sets[setIndex].copyWith(reps: reps);
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);
    state = state.copyWith(exercises: exercises);
  }

  /// Toggle completion of a set.
  void toggleSetComplete(int exerciseIndex, int setIndex) {
    final exercises = [...state.exercises];
    final exercise = exercises[exerciseIndex];
    final sets = [...exercise.sets];
    sets[setIndex] = sets[setIndex].copyWith(
      isCompleted: !sets[setIndex].isCompleted,
    );
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);
    state = state.copyWith(exercises: exercises);
  }

  /// End workout, stop timer, reset state.
  void finishWorkout() {
    _timer?.cancel();
    state = const ActiveWorkoutState();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  WorkoutExercise _toWorkoutExercise(TemplateExercise te) {
    final sets = List.generate(
      te.sets,
      (i) => WorkoutSet(setNumber: i + 1, weight: te.weight, reps: te.reps),
    );
    return WorkoutExercise(name: te.name, sets: sets);
  }
}
