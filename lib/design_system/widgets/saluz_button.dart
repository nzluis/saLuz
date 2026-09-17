import 'package:flutter/material.dart';

import '../app_spacing.dart';

class SaluzButton extends StatelessWidget {
  const SaluzButton({
    required this.label,
    required this.onPressed,
    this.variant = SaluzButtonVariant.filled,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final SaluzButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : _buildChild();

    final button = switch (variant) {
      SaluzButtonVariant.filled => FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.buttonPaddingH,
              vertical: AppSpacing.buttonPaddingV,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
          ),
          child: child,
        ),
      SaluzButtonVariant.tonal => FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.buttonPaddingH,
              vertical: AppSpacing.buttonPaddingV,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
          ),
          child: child,
        ),
      SaluzButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.buttonPaddingH,
              vertical: AppSpacing.buttonPaddingV,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
          ),
          child: child,
        ),
      SaluzButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.buttonPaddingH,
              vertical: AppSpacing.buttonPaddingV,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
          ),
          child: child,
        ),
    };

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildChild() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      );
    }
    return Text(label);
  }
}

enum SaluzButtonVariant { filled, tonal, outlined, text }
