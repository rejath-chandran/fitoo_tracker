import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Bottom sheet dialog to create a new workout template.
class CreateTemplateDialog extends StatefulWidget {
  final void Function(String name, List<String> tags) onSave;

  const CreateTemplateDialog({super.key, required this.onSave});

  @override
  State<CreateTemplateDialog> createState() => _CreateTemplateDialogState();

  /// Show as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required void Function(String name, List<String> tags) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateTemplateDialog(onSave: onSave),
    );
  }
}

class _CreateTemplateDialogState extends State<CreateTemplateDialog> {
  final _nameController = TextEditingController();
  final _allTags = [
    'Chest',
    'Back',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Quads',
    'Hamstrings',
    'Glutes',
    'Core',
    'Cardio',
  ];
  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
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

                Text('Create Template', style: AppTextStyles.heading2xl),
                const SizedBox(height: AppSpacing.xxl),

                // Name field
                Text(
                  'WORKOUT NAME',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.whiteAlpha05),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: AppTextStyles.bodyBase,
                    decoration: InputDecoration(
                      hintText: 'e.g., Push Day — Hypertrophy',
                      hintStyle: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(AppSpacing.base),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Muscle tags
                Text(
                  'MUSCLE GROUPS',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _allTags.map((tag) {
                    final selected = _selectedTags.contains(tag);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected
                              ? _selectedTags.remove(tag)
                              : _selectedTags.add(tag);
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryAlpha15
                              : AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull,
                          ),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.whiteAlpha10,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: AppTextStyles.bodySm.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.bgDark,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.base,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                      ),
                    ),
                    child: Text(
                      'CREATE TEMPLATE',
                      style: AppTextStyles.bodyBase.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: AppColors.bgDark,
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

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    widget.onSave(name, _selectedTags.toList());
    Navigator.of(context).pop();
  }
}
