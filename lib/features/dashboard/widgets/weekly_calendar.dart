import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/section_header.dart';
import 'calendar_day_widget.dart';

/// Weekly calendar row showing 7 days (Mon–Sun) with completion states.
class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const SectionHeader(title: 'Weekly View', trailingText: 'October'),
          const SizedBox(height: AppSpacing.base),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CalendarDayWidget(label: 'M', state: CalendarDayState.completed),
              CalendarDayWidget(label: 'T', state: CalendarDayState.completed),
              CalendarDayWidget(label: 'W', state: CalendarDayState.completed),
              CalendarDayWidget(
                label: 'T',
                state: CalendarDayState.active,
                date: 17,
              ),
              CalendarDayWidget(label: 'F', state: CalendarDayState.upcoming),
              CalendarDayWidget(label: 'S', state: CalendarDayState.upcoming),
              CalendarDayWidget(label: 'S', state: CalendarDayState.upcoming),
            ],
          ),
        ],
      ),
    );
  }
}
