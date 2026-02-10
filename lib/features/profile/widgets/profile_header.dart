import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

/// Profile header with large avatar, verified badge, name, PRO badge, and handle.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          // Avatar with verified badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 4),
                ),
                padding: const EdgeInsets.all(4),
                child: const CircleAvatar(
                  radius: 56,
                  backgroundColor: AppColors.surfaceDark,
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCv-y6aUu-43tEKpUjHdc6WNLicpqZlXIJxlKnBbQsxnpH_uAuTw8Mzz6877n68lgAxUgTOOCkpJFvBg5FonQCA2mAZXmS1WiWkm8xRWC88cvkxlzVH67ro9BpbREpIEoFwQu1OlTCF8yuYzo6gxrPjDmn4JHgWVrEe1KiXgTv_0WrrTuNZpFZzmJ66aoxszo4aAy1VTwpofxKV_Wm0aTkLbZSSU2Ha2CQvHLsf4ntduQVFVAcKKLgbiXiLjJEfx9jpc3A7XokV4II',
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bgDark, width: 4),
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 14,
                    color: AppColors.bgDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          // Name
          Text(
            'Alex Rivers',
            style: AppTextStyles.heading2xl.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // PRO badge
          Text(
            'PRO MEMBER',
            style: AppTextStyles.bodyLg.copyWith(
              color: AppColors.primary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Handle
          Text(
            '@arivers_fit',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Edit profile button
          SizedBox(
            width: 240,
            child: PrimaryButton(label: 'EDIT PROFILE', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
