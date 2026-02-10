import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Section header with a title and an optional trailing widget/text.
/// Used for "Weekly View", "Performance", "Weekly Activity", "Personal Records", etc.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingText;
  final VoidCallback? onTrailingTap;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailingText,
    this.onTrailingTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: AppTextStyles.headingLg),
        if (trailing != null)
          trailing!
        else if (trailingText != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailingText!.toUpperCase(),
              style: AppTextStyles.captionPrimary,
            ),
          ),
      ],
    );
  }
}
