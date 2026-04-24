import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class GradientButton extends StatelessWidget {
  final bool isValid;
  final VoidCallback? onPressed;
  const GradientButton({super.key, required this.isValid, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isValid
          ? LinearGradient(colors: [colorScheme.primary, colorScheme.secondary])
          : null,
        color: isValid ? null : colorScheme.surfaceContainerHighest
      ),
      child: ElevatedButton(
        onPressed: isValid ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: isValid ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          AppStrings.saveButton.tr(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
      ),
    );
  }
}
