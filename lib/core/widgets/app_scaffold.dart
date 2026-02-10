import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../../features/workouts_list/providers/template_providers.dart';

/// App scaffold with persistent bottom navigation and a centered FAB.
class AppScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () => _showTemplatePicker(context, ref),
          backgroundColor: AppColors.primary,
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: AppColors.bgDark, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bgDark.withValues(alpha: 0.95),
          border: const Border(top: BorderSide(color: AppColors.whiteAlpha05)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'HOME',
                  isActive: navigationShell.currentIndex == 0,
                  onTap: () => navigationShell.goBranch(0),
                ),
                _NavItem(
                  icon: Icons.fitness_center_rounded,
                  label: 'WORKOUTS',
                  isActive: navigationShell.currentIndex == 1,
                  onTap: () => navigationShell.goBranch(1),
                ),
                // Gap for the centered FAB
                const SizedBox(width: 60),
                _NavItem(
                  icon: Icons.insights_rounded,
                  label: 'STATS',
                  isActive: navigationShell.currentIndex == 2,
                  onTap: () => navigationShell.goBranch(2),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'PROFILE',
                  isActive: navigationShell.currentIndex == 3,
                  onTap: () => navigationShell.goBranch(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTemplatePicker(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.read(templatesProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXxl),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.whiteAlpha10,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text('Start Workout', style: AppTextStyles.heading2xl),
                const SizedBox(height: AppSpacing.xxl),
                // Empty workout option
                _pickerTile(
                  ctx,
                  icon: Icons.bolt,
                  title: 'Empty Workout',
                  subtitle: 'Log exercises as you go',
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/workout/active');
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                // Template options
                ...templatesAsync.when(
                  loading: () => [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                  error: (e, _) => [
                    Text('Error: $e', style: AppTextStyles.bodySm),
                  ],
                  data: (templates) => templates.map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _pickerTile(
                        ctx,
                        icon: Icons.fitness_center,
                        title: t.name,
                        subtitle:
                            '${t.exerciseCount} exercises · ${t.tags.join(", ")}',
                        onTap: () {
                          Navigator.pop(ctx);
                          context.push('/workout/active?templateId=${t.id}');
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pickerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.whiteAlpha05),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryAlpha10,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
