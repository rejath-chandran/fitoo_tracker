import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'widgets/welcome_header.dart';
import 'widgets/weekly_calendar.dart';
import 'widgets/gym_attendance_card.dart';
import 'widgets/performance_chart_card.dart';
import 'widgets/inspiration_quote_card.dart';

/// Home / Dashboard screen.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Welcome header
              const SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: WelcomeHeader(
                    userName: 'Alex Rivera',
                    avatarUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuB9vfEh47o2ORU5enU0RCSJ7zRe3kHTTYHGei3s2I4bcOYT16SGv3cdrH_1_VRXnXvyrE5pTCYaoqLFLxYw-oHYIvuOJNDYILBLXq1mbK_54yBuLIzCiQ_VwomWshBhzTPZyVbQ8WtdFKoug2V-ZVO07fVjLwfAzrDdh2FDdZVEmabUUapM1hucr7IJx6YVHs9mvns8UQdCSCPM4mJvfrv2DyqhwV3OwALCOKTQLbtJg177mdcR3Sq59kNKABokpPeT7OO8nCmHt7Q',
                    streakDays: 12,
                  ),
                ),
              ),

              // Weekly calendar
              const SliverToBoxAdapter(child: WeeklyCalendar()),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

              // Gym attendance card
              SliverToBoxAdapter(
                child: GymAttendanceCard(
                  completedSessions: 4,
                  totalSessions: 5,
                  durationMinutes: 320,
                  avgIntensityPercent: 84,
                  onCheckIn: () => context.push('/workout/active'),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

              // Performance chart
              const SliverToBoxAdapter(child: PerformanceChartCard()),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

              // Inspiration quote
              const SliverToBoxAdapter(
                child: InspirationQuoteCard(
                  quote: "The only bad workout is the one that didn't happen.",
                  attribution: 'Daily Inspo',
                ),
              ),

              // Bottom padding for nav bar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Floating action button
          Positioned(
            right: AppSpacing.xl,
            bottom: 96,
            child: GestureDetector(
              onTap: () => context.push('/workout/active'),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: AppColors.bgDark, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
