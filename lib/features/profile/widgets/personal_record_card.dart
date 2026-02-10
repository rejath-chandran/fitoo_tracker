import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Personal record card for the horizontal scrollable list on the Profile screen.
class PersonalRecordCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final String date;
  final IconData icon;
  final bool isHighlighted;

  const PersonalRecordCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    required this.date,
    required this.icon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primaryAlpha30
              : AppColors.whiteAlpha05,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Icon badge
          Positioned(
            right: -8,
            top: -8,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppColors.primaryAlpha20
                    : AppColors.primaryAlpha10,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title.toUpperCase(),
                style:
                    (isHighlighted
                            ? AppTextStyles.captionPrimary
                            : AppTextStyles.caption)
                        .copyWith(letterSpacing: 2),
              ),
              const SizedBox(height: AppSpacing.xs),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: value, style: AppTextStyles.heading2xl),
                    if (unit != null)
                      TextSpan(
                        text: ' $unit',
                        style: AppTextStyles.bodySm.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(date, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
