import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// State of a calendar day indicator.
enum CalendarDayState { completed, active, upcoming }

/// Single day widget in the weekly calendar row.
class CalendarDayWidget extends StatelessWidget {
  final String label;
  final CalendarDayState state;
  final int? date;

  const CalendarDayWidget({
    super.key,
    required this.label,
    required this.state,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: state == CalendarDayState.active
                ? FontWeight.w900
                : FontWeight.w700,
            color: state == CalendarDayState.active
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildCircle(),
      ],
    );
  }

  Widget _buildCircle() {
    switch (state) {
      case CalendarDayState.completed:
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: const Icon(Icons.check, size: 20, color: AppColors.bgDark),
        );

      case CalendarDayState.active:
        return _PulsingCircle(date: date);

      case CalendarDayState.upcoming:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.neutralDark,
            border: Border.all(color: AppColors.whiteAlpha05),
          ),
        );
    }
  }
}

/// Pulsing animated circle for the active day.
class _PulsingCircle extends StatefulWidget {
  final int? date;
  const _PulsingCircle({this.date});

  @override
  State<_PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<_PulsingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.05),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: _animation.value),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '${widget.date ?? ''}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
