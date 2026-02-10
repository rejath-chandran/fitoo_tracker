import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Full-width primary action button with green background and dark text.
/// Matches the Stitch design CTA buttons (e.g., "Check-in to Gym", "COMPLETE WORKOUT").
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLarge;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.bgDark,
          padding: EdgeInsets.symmetric(vertical: isLarge ? 18 : 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isLarge ? AppSpacing.radiusXl : AppSpacing.radiusLg,
            ),
          ),
          elevation: 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: isLarge ? 18 : 14,
            fontWeight: isLarge ? FontWeight.w900 : FontWeight.w700,
            letterSpacing: isLarge ? -0.25 : 0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}
