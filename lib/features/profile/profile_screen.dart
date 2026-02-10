import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/weekly_bar_chart.dart';
import 'widgets/profile_header.dart';
import 'widgets/personal_record_card.dart';

/// Profile & Stats screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Top bar
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleButton(Icons.arrow_back, () {
                      Navigator.of(context).maybePop();
                    }),
                    Text('Profile', style: AppTextStyles.headingLg),
                    _circleButton(Icons.settings, () {}),
                  ],
                ),
              ),
            ),
          ),

          // Profile header
          const SliverToBoxAdapter(child: ProfileHeader()),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

          // Stats row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                children: [
                  _statCard('Workouts', '128'),
                  const SizedBox(width: AppSpacing.md),
                  _statCard(
                    'Streak',
                    '14',
                    suffix: 'd',
                    valueColor: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _statCard('Hours', '245'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

          // Weekly activity section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  SectionHeader(
                    title: 'Weekly Activity',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _toggleChip('Week', true),
                        const SizedBox(width: AppSpacing.sm),
                        _toggleChip('Month', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  const WeeklyBarChart(
                    values: [40, 60, 85, 30, 55, 90, 45],
                    highlightIndex: 5,
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),

          // Personal records section
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: SectionHeader(
                    title: 'Personal Records',
                    trailingText: 'View All',
                    onTrailingTap: () {},
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    children: const [
                      PersonalRecordCard(
                        title: 'Squat',
                        value: '140',
                        unit: 'kg',
                        date: 'Oct 24, 2023',
                        icon: Icons.fitness_center,
                      ),
                      SizedBox(width: AppSpacing.base),
                      PersonalRecordCard(
                        title: 'Fastest 5K',
                        value: '19:42',
                        date: 'Nov 12, 2023',
                        icon: Icons.bolt,
                        isHighlighted: true,
                      ),
                      SizedBox(width: AppSpacing.base),
                      PersonalRecordCard(
                        title: 'Deadlift',
                        value: '185',
                        unit: 'kg',
                        date: 'Sep 05, 2023',
                        icon: Icons.fitness_center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceDarkLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }

  Widget _statCard(
    String label,
    String value, {
    String? suffix,
    Color? valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.whiteAlpha05),
        ),
        child: Column(
          children: [
            Text(label.toUpperCase(), style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: AppTextStyles.heading2xl.copyWith(
                      color: valueColor ?? AppColors.textPrimary,
                    ),
                  ),
                  if (suffix != null)
                    TextSpan(text: suffix, style: AppTextStyles.bodySm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryAlpha10 : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySm.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
