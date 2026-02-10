import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/linear_progress.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/stat_tile.dart';
import 'widgets/exercise_section.dart';

/// Active workout logging screen (full-screen, no bottom nav).
class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final String _timer = '00:42:18';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Sticky header with blur
          _buildHeader(context),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              children: [
                // Exercise 1: Barbell Bench Press
                ExerciseSection(
                  exerciseName: 'Barbell Bench Press',
                  sets: [
                    ExerciseSetData(
                      setNumber: 1,
                      previousWeight: 225,
                      previousReps: 8,
                      currentWeight: '230',
                      currentReps: '8',
                      isCompleted: true,
                    ),
                    ExerciseSetData(
                      setNumber: 2,
                      previousWeight: 225,
                      previousReps: 8,
                      isActive: true,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // Exercise 2: Incline DB Press
                ExerciseSection(
                  exerciseName: 'Incline DB Press',
                  sets: [
                    ExerciseSetData(
                      setNumber: 1,
                      previousWeight: 70,
                      previousReps: 10,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Add exercise button
                _buildAddExerciseButton(),

                const SizedBox(height: AppSpacing.base),

                // Summary tiles
                Row(
                  children: const [
                    Expanded(
                      child: StatTile(
                        label: 'Total Volume',
                        value: '12,450',
                        suffix: 'lbs',
                        compact: true,
                        backgroundColor: AppColors.primaryAlpha05,
                      ),
                    ),
                    SizedBox(width: AppSpacing.base),
                    Expanded(
                      child: StatTile(
                        label: 'Rest Timer',
                        value: '01:30',
                        suffix: 'sec',
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
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  // Close button
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  // Title + timer
                  Column(
                    children: [
                      Text(
                        'PUSH DAY - HYPERTROPHY',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(_timer, style: AppTextStyles.timerDisplay),
                    ],
                  ),
                  // More button
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
              child: const LinearProgress(progress: 0.65),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddExerciseButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryAlpha10,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.primaryAlpha20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
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
}
