import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Workout template card showing name, muscle tags, exercise count, and last-performed date.
class WorkoutTemplateCard extends StatelessWidget {
  final String name;
  final List<String> muscleTags;
  final int exerciseCount;
  final String estimatedDuration;
  final String? lastPerformed;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const WorkoutTemplateCard({
    super.key,
    required this.name,
    required this.muscleTags,
    required this.exerciseCount,
    required this.estimatedDuration,
    this.lastPerformed,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.whiteAlpha05),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row + more button
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAlpha10,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    name,
                    style: AppTextStyles.headingLg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: onMoreTap,
                  child: const Icon(
                    Icons.more_horiz,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Muscle tags
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: muscleTags
                  .map((tag) => _MuscleChip(label: tag))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),

            // Meta row
            Row(
              children: [
                const Icon(
                  Icons.list_alt,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '$exerciseCount exercises',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: AppSpacing.base),
                const Icon(
                  Icons.schedule,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '~$estimatedDuration',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            // Last performed
            if (lastPerformed != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Last: $lastPerformed',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Colored muscle group chip.
class _MuscleChip extends StatelessWidget {
  final String label;
  const _MuscleChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryAlpha10,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.primaryAlpha20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySm.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
