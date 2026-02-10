import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Compact stat display tile (label + large value + optional suffix).
/// Used in Profile stats row, Attendance card sub-stats, and Workout summary.
class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final Color? valueColor;
  final Color? backgroundColor;
  final bool compact;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.valueColor,
    this.backgroundColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.base),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.neutralDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.whiteAlpha05),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: compact
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.xs),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style:
                      (compact
                              ? AppTextStyles.headingLg
                              : AppTextStyles.heading2xl)
                          .copyWith(color: valueColor ?? AppColors.textPrimary),
                ),
                if (suffix != null)
                  TextSpan(
                    text: ' $suffix',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
