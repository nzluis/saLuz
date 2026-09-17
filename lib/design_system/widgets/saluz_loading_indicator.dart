import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_spacing.dart';
import '../app_text_styles.dart';

class SaluzLoadingIndicator extends StatelessWidget {
  const SaluzLoadingIndicator({
    this.message,
    this.isOverlay = false,
    super.key,
  });

  final String? message;
  final bool isOverlay;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (isOverlay) {
      return ColoredBox(
        color: Colors.black.withValues(alpha: 0.3),
        child: content,
      );
    }
    return content;
  }
}
