import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/section_header.dart';
import 'providers/template_providers.dart';
import 'widgets/create_template_dialog.dart';
import 'widgets/filter_chip_row.dart';
import 'widgets/workout_template_card.dart';
import 'widgets/workout_history_tile.dart';

/// Workouts list screen — the second tab in bottom navigation.
class WorkoutsListScreen extends ConsumerWidget {
  const WorkoutsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ─── Header ───
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.base,
                  AppSpacing.xl,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Workouts', style: AppTextStyles.heading2xl),
                    GestureDetector(
                      onTap: () => _showCreateDialog(context, ref),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.bgDark,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.base)),

          // ─── Search Bar ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.whiteAlpha05),
                ),
                child: TextField(
                  style: AppTextStyles.bodyBase,
                  decoration: InputDecoration(
                    hintText: 'Search workouts...',
                    hintStyle: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.base)),

          // ─── Filter Chips ───
          const SliverToBoxAdapter(
            child: FilterChipRow(
              filters: ['All', 'Push', 'Pull', 'Legs', 'Cardio', 'Custom'],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

          // ─── Quick Start ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: GestureDetector(
                onTap: () => context.push('/workout/active'),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    border: Border.all(color: AppColors.primaryAlpha20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                        ),
                        child: const Icon(
                          Icons.bolt,
                          color: AppColors.bgDark,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.base),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Empty Workout',
                              style: AppTextStyles.headingLg,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Log exercises as you go',
                              style: AppTextStyles.bodySm.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

          // ─── Templates Section ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: SectionHeader(
                title: 'Templates',
                trailingText: 'Create',
                onTrailingTap: () => _showCreateDialog(context, ref),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.base)),

          // ─── Template cards from DB ───
          templatesAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Text('Error: $e', style: AppTextStyles.bodyBase),
                ),
              ),
            ),
            data: (templates) {
              if (templates.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: _buildEmptyTemplates(context, ref),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                sliver: SliverList.separated(
                  itemCount: templates.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final t = templates[index];
                    return WorkoutTemplateCard(
                      name: t.name,
                      muscleTags: t.tags,
                      exerciseCount: t.exerciseCount,
                      estimatedDuration: t.estimatedDuration,
                      onTap: () => context.push('/workouts/template/${t.id}'),
                      onMoreTap: () => _confirmDelete(context, ref, t.id!),
                    );
                  },
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),

          // ─── Recent History Section (static demo) ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: SectionHeader(
                title: 'Recent History',
                trailingText: 'See All',
                onTrailingTap: () {},
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.base)),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverList.separated(
              itemCount: _historyData.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final h = _historyData[index];
                return WorkoutHistoryTile(
                  date: h['date']!,
                  name: h['name']!,
                  duration: h['duration']!,
                  totalSets: int.parse(h['sets']!),
                  totalVolume: h['volume']!,
                  hasPR: h['pr'] == 'true',
                );
              },
            ),
          ),

          // Bottom padding for nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    CreateTemplateDialog.show(
      context,
      onSave: (name, tags) {
        ref.read(templatesProvider.notifier).addTemplate(name, tags);
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Template?', style: AppTextStyles.headingLg),
        content: Text(
          'This will remove this template and all its exercises.',
          style: AppTextStyles.bodyBase.copyWith(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Delete',
              style: AppTextStyles.bodySm.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(templatesProvider.notifier).removeTemplate(id);
    }
  }

  Widget _buildEmptyTemplates(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showCreateDialog(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxxl,
          horizontal: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryAlpha05,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.primaryAlpha20),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.fitness_center,
              color: AppColors.textSecondary,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'No templates yet',
              style: AppTextStyles.headingLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap + to create your first workout template',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // Static demo data for history
  static const _historyData = [
    {
      'date': 'Mon, Feb 10',
      'name': 'Push Day — Hypertrophy',
      'duration': '52 min',
      'sets': '18',
      'volume': '14,200',
      'pr': 'false',
    },
    {
      'date': 'Sat, Feb 8',
      'name': 'Leg Day — Power',
      'duration': '58 min',
      'sets': '22',
      'volume': '18,100',
      'pr': 'true',
    },
    {
      'date': 'Thu, Feb 6',
      'name': 'Pull Day — Strength',
      'duration': '45 min',
      'sets': '16',
      'volume': '12,800',
      'pr': 'false',
    },
    {
      'date': 'Tue, Feb 4',
      'name': 'Push Day — Hypertrophy',
      'duration': '50 min',
      'sets': '18',
      'volume': '13,500',
      'pr': 'true',
    },
  ];
}
