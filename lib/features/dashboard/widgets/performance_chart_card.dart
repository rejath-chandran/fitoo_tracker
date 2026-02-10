import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/weekly_bar_chart.dart';

/// Performance chart section on the Dashboard.
class PerformanceChartCard extends StatelessWidget {
  const PerformanceChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const SectionHeader(title: 'Performance'),
          const SizedBox(height: AppSpacing.base),
          const WeeklyBarChart(
            values: [60, 85, 45, 95, 0, 0, 0],
            labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
            highlightIndex: 3,
          ),
        ],
      ),
    );
  }
}
