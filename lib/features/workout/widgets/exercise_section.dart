import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/active_workout_provider.dart';

/// Exercise section with title, set rows, and add-set button.
/// All callbacks are forwarded from the parent (WorkoutScreen).
class ExerciseSection extends StatelessWidget {
  final int exerciseIndex;
  final WorkoutExercise exercise;
  final void Function(int exerciseIndex) onAddSet;
  final void Function(int exerciseIndex, int setIndex) onToggleComplete;
  final void Function(int exerciseIndex, int setIndex, double weight)
  onWeightChanged;
  final void Function(int exerciseIndex, int setIndex, int reps) onRepsChanged;

  const ExerciseSection({
    super.key,
    required this.exerciseIndex,
    required this.exercise,
    required this.onAddSet,
    required this.onToggleComplete,
    required this.onWeightChanged,
    required this.onRepsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Exercise title row
        Row(
          children: [
            const Icon(
              Icons.fitness_center,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(exercise.name, style: AppTextStyles.headingLg),
            ),
            Text(
              '${exercise.completedSets}/${exercise.sets.length}',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // Column headers
        _buildColumnHeaders(),

        const SizedBox(height: AppSpacing.sm),

        // Set rows
        ...exercise.sets.asMap().entries.map((entry) {
          final setIndex = entry.key;
          final set = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _SetRow(
              set: set,
              onToggleComplete: () => onToggleComplete(exerciseIndex, setIndex),
              onWeightChanged: (w) =>
                  onWeightChanged(exerciseIndex, setIndex, w),
              onRepsChanged: (r) => onRepsChanged(exerciseIndex, setIndex, r),
            ),
          );
        }),

        // Add set button
        _buildAddSetButton(),
      ],
    );
  }

  Widget _buildColumnHeaders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: const [
          SizedBox(width: 40, child: Center(child: _HeaderLabel('SET'))),
          SizedBox(width: 64, child: Center(child: _HeaderLabel('LBS'))),
          SizedBox(width: 8),
          SizedBox(width: 64, child: Center(child: _HeaderLabel('REPS'))),
          Spacer(),
          SizedBox(width: 40, child: Center(child: _HeaderLabel('DONE'))),
        ],
      ),
    );
  }

  Widget _buildAddSetButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onAddSet(exerciseIndex),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              'ADD SET',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  final String text;
  const _HeaderLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.caption);
  }
}

/// Single row for one set.
class _SetRow extends StatelessWidget {
  final WorkoutSet set;
  final VoidCallback onToggleComplete;
  final void Function(double) onWeightChanged;
  final void Function(int) onRepsChanged;

  const _SetRow({
    required this.set,
    required this.onToggleComplete,
    required this.onWeightChanged,
    required this.onRepsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: set.isCompleted
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.primaryAlpha05,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: set.isCompleted
              ? AppColors.primaryAlpha30
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          // Set number
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                '${set.setNumber}',
                style: AppTextStyles.bodyLg.copyWith(
                  color: set.isCompleted
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          // Weight input
          SizedBox(
            width: 64,
            child: _NumericInput(
              initialValue: set.weight > 0 ? set.weight.toStringAsFixed(0) : '',
              placeholder: '0',
              onChanged: (val) {
                final w = double.tryParse(val) ?? 0;
                onWeightChanged(w);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Reps input
          SizedBox(
            width: 64,
            child: _NumericInput(
              initialValue: set.reps > 0 ? '${set.reps}' : '',
              placeholder: '0',
              onChanged: (val) {
                final r = int.tryParse(val) ?? 0;
                onRepsChanged(r);
              },
            ),
          ),
          const Spacer(),
          // Checkbox
          SizedBox(
            width: 40,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: set.isCompleted,
                  onChanged: (_) => onToggleComplete(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Numeric field for weight/reps.
class _NumericInput extends StatefulWidget {
  final String? initialValue;
  final String? placeholder;
  final void Function(String) onChanged;

  const _NumericInput({
    this.initialValue,
    this.placeholder,
    required this.onChanged,
  });

  @override
  State<_NumericInput> createState() => _NumericInputState();
}

class _NumericInputState extends State<_NumericInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: AppTextStyles.bodyLg.copyWith(fontSize: 13),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: AppTextStyles.bodySm.copyWith(
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.whiteAlpha05,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
      ),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
