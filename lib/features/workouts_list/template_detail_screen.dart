import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/models/template_exercise.dart';
import '../../core/widgets/section_header.dart';
import 'providers/template_providers.dart';
import 'widgets/add_exercise_dialog.dart';

/// Detail screen for a single workout template — shows its exercises.
class TemplateDetailScreen extends ConsumerWidget {
  final int templateId;
  const TemplateDetailScreen({super.key, required this.templateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templatesProvider);

    return templates.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e', style: AppTextStyles.bodyBase)),
      ),
      data: (list) {
        final template = list.where((t) => t.id == templateId).firstOrNull;
        if (template == null) {
          return Scaffold(
            body: Center(
              child: Text('Template not found', style: AppTextStyles.bodyBase),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // ─── Header ───
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.base,
                      AppSpacing.sm,
                      AppSpacing.xl,
                      0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template.name,
                                style: AppTextStyles.headingXl,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (template.tags.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  template.tags.join(' · '),
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Delete template
                        IconButton(
                          onPressed: () async {
                            final confirmed = await _confirmDelete(context);
                            if (confirmed && context.mounted) {
                              await ref
                                  .read(templatesProvider.notifier)
                                  .removeTemplate(templateId);
                              if (context.mounted) Navigator.of(context).pop();
                            }
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

              // ─── Exercises header ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: SectionHeader(
                    title: 'Exercises (${template.exercises.length})',
                    trailingText: 'Add',
                    onTrailingTap: () => _addExercise(context, ref),
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.base),
              ),

              // ─── Exercise list ───
              if (template.exercises.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: _emptyState(context, ref),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  sliver: SliverList.separated(
                    itemCount: template.exercises.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final exercise = template.exercises[index];
                      return _ExerciseTile(
                        exercise: exercise,
                        onDelete: () async {
                          final repo = ref.read(templateRepositoryProvider);
                          await repo.deleteExercise(exercise.id!);
                          ref.read(templatesProvider.notifier).reload();
                        },
                      );
                    },
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),
            ],
          ),

          // FAB — Add Exercise
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addExercise(context, ref),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: AppColors.bgDark),
          ),
        );
      },
    );
  }

  void _addExercise(BuildContext context, WidgetRef ref) {
    AddExerciseDialog.show(
      context,
      onSave: (name, sets, reps, weight) async {
        final repo = ref.read(templateRepositoryProvider);
        final currentExercises = await repo.getExercisesForTemplate(templateId);
        await repo.addExercise(
          TemplateExercise(
            templateId: templateId,
            name: name,
            sets: sets,
            reps: reps,
            weight: weight,
            sortOrder: currentExercises.length,
          ),
        );
        ref.read(templatesProvider.notifier).reload();
      },
    );
  }

  Widget _emptyState(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _addExercise(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxxl,
          horizontal: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryAlpha05,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(
            color: AppColors.primaryAlpha20,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.fitness_center,
              color: AppColors.textSecondary,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'No exercises yet',
              style: AppTextStyles.headingLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap + to add your first exercise',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.cardDark,
            title: Text('Delete Template?', style: AppTextStyles.headingLg),
            content: Text(
              'This will permanently remove this template and all its exercises.',
              style: AppTextStyles.bodyBase.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'Delete',
                  style: AppTextStyles.bodySm.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

/// Single exercise row with swipe-to-delete.
class _ExerciseTile extends StatelessWidget {
  final TemplateExercise exercise;
  final VoidCallback onDelete;

  const _ExerciseTile({required this.exercise, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(exercise.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: const Icon(Icons.delete, color: Colors.redAccent),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.whiteAlpha05),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryAlpha10,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Center(
                child: Text(
                  '${exercise.sortOrder + 1}',
                  style: AppTextStyles.headingLg.copyWith(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${exercise.sets} sets × ${exercise.reps} reps'
                    '${exercise.weight > 0 ? ' @ ${exercise.weight} lbs' : ''}',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.drag_handle,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
