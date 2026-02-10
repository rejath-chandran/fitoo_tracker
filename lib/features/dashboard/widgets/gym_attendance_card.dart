import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/circular_progress.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/stat_tile.dart';

/// Gym attendance card with circular progress, stat tiles, and CTA button.
class GymAttendanceCard extends StatelessWidget {
  final int completedSessions;
  final int totalSessions;
  final int durationMinutes;
  final int avgIntensityPercent;
  final bool isCheckedIn;
  final VoidCallback? onCheckIn;

  const GymAttendanceCard({
    super.key,
    required this.completedSessions,
    required this.totalSessions,
    required this.durationMinutes,
    required this.avgIntensityPercent,
    this.isCheckedIn = false,
    this.onCheckIn,
  });

  double get _progress =>
      totalSessions > 0 ? completedSessions / totalSessions : 0;

  String get _motivationText {
    final remaining = totalSessions - completedSessions;
    if (remaining <= 0) return 'Perfect week! 🔥';
    if (remaining == 1) return 'One more for a perfect week!';
    return '$remaining sessions left this week';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: AppCard(
        child: Stack(
          children: [
            // Glow accent
            Positioned(
              right: -32,
              top: -32,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
            ),
            Column(
              children: [
                // Header row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GYM ATTENDANCE',
                            style: AppTextStyles.captionPrimary.copyWith(
                              letterSpacing: 3.2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '$completedSessions / $totalSessions Sessions',
                            style: AppTextStyles.heading2xl,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _motivationText,
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircularProgress(
                      progress: _progress,
                      size: 80,
                      strokeWidth: 8,
                      center: Text(
                        '${(_progress * 100).toInt()}%',
                        style: AppTextStyles.headingLg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base),
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        label: 'Duration',
                        value: '$durationMinutes',
                        suffix: 'min',
                        compact: true,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Expanded(
                      child: StatTile(
                        label: 'Avg Intensity',
                        value: '$avgIntensityPercent',
                        suffix: '%',
                        compact: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // CTA — changes based on check-in state
                isCheckedIn
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAlpha10,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                          border: Border.all(color: AppColors.primaryAlpha20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Checked In Today',
                              style: AppTextStyles.bodyBase.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : PrimaryButton(
                        label: 'Check-in to Gym',
                        icon: Icons.add_task,
                        onPressed: onCheckIn,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
