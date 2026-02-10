import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Horizontal scrollable filter chip row.
class FilterChipRow extends StatefulWidget {
  final List<String> filters;
  final int initialIndex;
  final ValueChanged<int>? onSelected;

  const FilterChipRow({
    super.key,
    required this.filters,
    this.initialIndex = 0,
    this.onSelected,
  });

  @override
  State<FilterChipRow> createState() => _FilterChipRowState();
}

class _FilterChipRowState extends State<FilterChipRow> {
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: widget.filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isActive = index == _selected;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = index);
              widget.onSelected?.call(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.whiteAlpha10,
                ),
              ),
              child: Text(
                widget.filters[index],
                style: AppTextStyles.bodySm.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.bgDark : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
