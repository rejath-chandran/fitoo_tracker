import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/template_repository.dart';
import '../../../core/models/workout_template.dart';
import '../../../core/models/template_exercise.dart';

/// Singleton repository provider.
final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepository();
});

/// Provides the full list of workout templates (with exercises).
final templatesProvider =
    AsyncNotifierProvider<TemplatesNotifier, List<WorkoutTemplate>>(
      TemplatesNotifier.new,
    );

class TemplatesNotifier extends AsyncNotifier<List<WorkoutTemplate>> {
  @override
  Future<List<WorkoutTemplate>> build() async {
    return ref.read(templateRepositoryProvider).getAllTemplates();
  }

  Future<void> addTemplate(String name, List<String> tags) async {
    final repo = ref.read(templateRepositoryProvider);
    await repo.insertTemplate(WorkoutTemplate(name: name, tags: tags));
    state = AsyncData(await repo.getAllTemplates());
  }

  Future<void> removeTemplate(int id) async {
    final repo = ref.read(templateRepositoryProvider);
    await repo.deleteTemplate(id);
    state = AsyncData(await repo.getAllTemplates());
  }

  /// Refresh from DB.
  Future<void> reload() async {
    state = AsyncData(
      await ref.read(templateRepositoryProvider).getAllTemplates(),
    );
  }
}

/// Provides exercises for a specific template.
final templateExercisesProvider =
    FutureProvider.family<List<TemplateExercise>, int>((ref, templateId) {
      return ref
          .read(templateRepositoryProvider)
          .getExercisesForTemplate(templateId);
    });
