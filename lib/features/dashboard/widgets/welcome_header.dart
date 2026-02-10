import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'streak_badge.dart';

/// Welcome header with avatar, greeting, username, and streak badge.
class WelcomeHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final int streakDays;

  const WelcomeHeader({
    super.key,
    required this.userName,
    this.avatarUrl,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceDark,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null
                  ? const Icon(Icons.person, color: AppColors.textSecondary)
                  : null,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                Text(userName, style: AppTextStyles.headingXl),
              ],
            ),
          ),
          // Streak
          StreakBadge(days: streakDays),
        ],
      ),
    );
  }
}
