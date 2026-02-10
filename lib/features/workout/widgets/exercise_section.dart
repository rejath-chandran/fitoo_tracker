import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Data model for a single exercise set row.
class ExerciseSetData {
  final int setNumber;
  final int previousWeight;
  final int previousReps;
  final String? currentWeight;
  final String? currentReps;
  final bool isCompleted;
  final bool isActive;

  const ExerciseSetData({
    required this.setNumber,
    required this.previousWeight,
    required this.previousReps,
    this.currentWeight,
    this.currentReps,
    this.isCompleted = false,
    this.isActive = false,
  });
}

/// Exercise section with title, set header, set rows, and add set button.
class ExerciseSection extends StatelessWidget {
  final String exerciseName;
  final List<ExerciseSetData> sets;

  const ExerciseSection({
    super.key,
    required this.exerciseName,
    required this.sets,
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
            Expanded(child: Text(exerciseName, style: AppTextStyles.headingLg)),
            const Icon(
              Icons.info_outline,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // Column headers
        _buildColumnHeaders(),

        const SizedBox(height: AppSpacing.sm),

        // Set rows
        ...sets.map(
          (set) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _ExerciseSetRow(data: set),
          ),
        ),

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
          Expanded(child: Center(child: _HeaderLabel('PREVIOUS'))),
          SizedBox(width: 64, child: Center(child: _HeaderLabel('LBS'))),
          SizedBox(width: 8),
          SizedBox(width: 64, child: Center(child: _HeaderLabel('REPS'))),
          SizedBox(width: 8),
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
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
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

/// Single row for an exercise set (set#, previous, weight, reps, checkbox).
class _ExerciseSetRow extends StatefulWidget {
  final ExerciseSetData data;
  const _ExerciseSetRow({required this.data});

  @override
  State<_ExerciseSetRow> createState() => _ExerciseSetRowState();
}

class _ExerciseSetRowState extends State<_ExerciseSetRow> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.data.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.data.isActive;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryAlpha05,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isActive ? AppColors.primaryAlpha30 : Colors.transparent,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Set number
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                '${widget.data.setNumber}',
                style: AppTextStyles.bodyLg.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          // Previous
          Expanded(
            child: Center(
              child: Text(
                '${widget.data.previousWeight} x ${widget.data.previousReps}',
                style: AppTextStyles.bodyXs,
              ),
            ),
          ),
          // Weight input
          SizedBox(
            width: 64,
            child: _NumericInput(
              initialValue: widget.data.currentWeight,
              placeholder: '${widget.data.previousWeight}',
            ),
          ),
          const SizedBox(width: 8),
          // Reps input
          SizedBox(
            width: 64,
            child: _NumericInput(
              initialValue: widget.data.currentReps,
              placeholder: '${widget.data.previousReps}',
            ),
          ),
          const SizedBox(width: 8),
          // Checkbox
          SizedBox(
            width: 40,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _isCompleted,
                  onChanged: (val) => setState(() => _isCompleted = val!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small numeric text field for weight/reps input.
class _NumericInput extends StatelessWidget {
  final String? initialValue;
  final String? placeholder;

  const _NumericInput({this.initialValue, this.placeholder});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: AppTextStyles.bodyLg.copyWith(fontSize: 13),
      decoration: InputDecoration(
        hintText: placeholder,
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
