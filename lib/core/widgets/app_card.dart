import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Dark card container with subtle white/5 border.
/// Used as the base container for all content cards across screens.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final bool hasBorderGlow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.hasBorderGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusLg,
        ),
        border: Border.all(
          color: hasBorderGlow
              ? AppColors.primaryAlpha30
              : AppColors.whiteAlpha05,
        ),
        boxShadow: hasBorderGlow
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
