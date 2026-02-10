import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// A single row in the workout history list.
class WorkoutHistoryTile extends StatelessWidget {
  final String date;
  final String name;
  final String duration;
  final int totalSets;
  final String totalVolume;
  final bool hasPR;
  final VoidCallback? onTap;

  const WorkoutHistoryTile({
    super.key,
    required this.date,
    required this.name,
    required this.duration,
    required this.totalSets,
    required this.totalVolume,
    this.hasPR = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: hasPR ? AppColors.primaryAlpha20 : AppColors.whiteAlpha05,
          ),
        ),
        child: Row(
          children: [
            // Date column
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: hasPR ? AppColors.primaryAlpha10 : AppColors.neutralDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Center(
                child: Icon(
                  hasPR ? Icons.emoji_events : Icons.calendar_today,
                  color: hasPR ? AppColors.primary : AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppTextStyles.bodyLg.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasPR)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAlpha10,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                          ),
                          child: Text(
                            'PR 🏆',
                            style: AppTextStyles.bodySm.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    date,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Stats
                  Row(
                    children: [
                      _miniStat(Icons.schedule, duration),
                      const SizedBox(width: AppSpacing.md),
                      _miniStat(Icons.repeat, '$totalSets sets'),
                      const SizedBox(width: AppSpacing.md),
                      _miniStat(Icons.bar_chart, '$totalVolume lbs'),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(
          text,
          style: AppTextStyles.bodySm.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
