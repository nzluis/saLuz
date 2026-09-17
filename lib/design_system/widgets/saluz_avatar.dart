import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';

class SaluzAvatar extends StatelessWidget {
  const SaluzAvatar({
    required this.initials,
    this.radius = 20,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  final String initials;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? AppColors.primaryContainer,
      foregroundColor: foregroundColor ?? AppColors.onPrimaryContainer,
      child: Text(
        initials,
        style: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
