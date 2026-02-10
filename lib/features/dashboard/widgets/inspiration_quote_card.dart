import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';

/// Inspirational quote card with glass-morphism backdrop effect.
class InspirationQuoteCard extends StatelessWidget {
  final String quote;
  final String attribution;

  const InspirationQuoteCard({
    super.key,
    required this.quote,
    required this.attribution,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: GlassCard(
        child: Stack(
          children: [
            // Decorative quote icon
            Positioned(
              right: -8,
              bottom: -8,
              child: Icon(
                Icons.format_quote,
                size: 64,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"$quote"',
                  style: AppTextStyles.bodyBase.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary.withValues(alpha: 0.9),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('— $attribution', style: AppTextStyles.captionPrimary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
