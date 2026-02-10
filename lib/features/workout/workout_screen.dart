import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/linear_progress.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/stat_tile.dart';
import 'providers/active_workout_provider.dart';
import 'widgets/exercise_section.dart';

/// Active workout logging screen (full-screen, no bottom nav).
class WorkoutScreen extends ConsumerStatefulWidget {
  final int? templateId;
  const WorkoutScreen({super.key, this.templateId});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Defer until after the first build so refs are valid.
    Future.microtask(() => _initWorkout());
  }

  Future<void> _initWorkout() async {
    if (_initialized) return;
    _initialized = true;
    final notifier = ref.read(activeWorkoutProvider.notifier);
    if (widget.templateId != null) {
      await notifier.startFromTemplate(widget.templateId!);
    } else {
      notifier.startEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final workout = ref.watch(activeWorkoutProvider);
    final notifier = ref.read(activeWorkoutProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          // Sticky header
          _buildHeader(context, workout),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              children: [
                // Exercise sections
                ...workout.exercises.asMap().entries.map((entry) {
                  final i = entry.key;
                  final exercise = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    child: ExerciseSection(
                      exerciseIndex: i,
                      exercise: exercise,
                      onAddSet: (idx) => notifier.addSet(idx),
                      onToggleComplete: (ei, si) =>
                          notifier.toggleSetComplete(ei, si),
                      onWeightChanged: (ei, si, w) =>
                          notifier.updateWeight(ei, si, w),
                      onRepsChanged: (ei, si, r) =>
                          notifier.updateReps(ei, si, r),
                    ),
                  );
                }),

                // Add exercise button
                _buildAddExerciseButton(notifier),

                const SizedBox(height: AppSpacing.base),

                // Summary tiles
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        label: 'Total Volume',
                        value: _formatVolume(workout.totalVolume),
                        suffix: 'lbs',
                        compact: true,
                        backgroundColor: AppColors.primaryAlpha05,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Expanded(
                      child: StatTile(
                        label: 'Sets Done',
                        value: '${workout.completedSets}/${workout.totalSets}',
                        compact: true,
                        backgroundColor: AppColors.primaryAlpha05,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),

          // Footer CTA
          Container(
            padding: const EdgeInsets.all(AppSpacing.base),
            decoration: const BoxDecoration(
              color: AppColors.bgDark,
              border: Border(top: BorderSide(color: AppColors.primaryAlpha10)),
            ),
            child: SafeArea(
              top: false,
              child: PrimaryButton(
                label: 'COMPLETE WORKOUT',
                isLarge: true,
                onPressed: () {
                  notifier.finishWorkout();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ActiveWorkoutState workout) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgDark.withValues(alpha: 0.8),
        border: const Border(
          bottom: BorderSide(color: AppColors.primaryAlpha10),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(activeWorkoutProvider.notifier).finishWorkout();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        workout.templateName.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        workout.timerDisplay,
                        style: AppTextStyles.timerDisplay,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      color: AppColors.textPrimary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                0,
                AppSpacing.base,
                AppSpacing.base,
              ),
              child: LinearProgress(progress: workout.progress),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddExerciseButton(ActiveWorkoutNotifier notifier) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryAlpha10,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.primaryAlpha20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAddExerciseDialog(notifier),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Add Exercise',
                  style: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddExerciseDialog(ActiveWorkoutNotifier notifier) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXxl),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.whiteAlpha10,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text('Add Exercise', style: AppTextStyles.heading2xl),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: AppColors.whiteAlpha05),
                    ),
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      style: AppTextStyles.bodyBase,
                      decoration: InputDecoration(
                        hintText: 'e.g., Lateral Raises',
                        hintStyle: AppTextStyles.bodySm.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          notifier.addExercise(name);
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.bgDark,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.base,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                        ),
                      ),
                      child: Text(
                        'ADD',
                        style: AppTextStyles.bodyBase.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: AppColors.bgDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatVolume(double vol) {
    if (vol >= 1000) {
      return '${(vol / 1000).toStringAsFixed(1)}k';
    }
    return vol.toStringAsFixed(0);
  }
}
