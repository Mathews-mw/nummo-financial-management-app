import 'package:flutter/material.dart';
import 'package:nummo/theme/app_colors.dart';

enum OutlineVariant {
  primary,
  secondary,
  optimistic,
  vibrant,
  muted,
  success,
  danger;

  Color get color {
    switch (this) {
      case OutlineVariant.primary:
        return AppColors.primary;
      case OutlineVariant.secondary:
        return AppColors.secondary;
      case OutlineVariant.vibrant:
        return AppColors.cyan;
      case OutlineVariant.optimistic:
        return AppColors.amber;
      case OutlineVariant.muted:
        return AppColors.gray400;
      case OutlineVariant.success:
        return AppColors.success;
      case OutlineVariant.danger:
        return AppColors.danger;
    }
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final OutlineVariant? variant;
  final Widget? icon;
  final bool isLoading;
  final bool disabled;
  final bool outline;
  final IconAlignment? iconAlignment;
  final void Function() onPressed;

  const CustomOutlinedButton({
    super.key,
    required this.label,
    this.variant = OutlineVariant.primary,
    this.icon,
    this.isLoading = false,
    this.disabled = false,
    this.outline = false,
    this.iconAlignment,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: variant != null ? variant!.color : AppColors.primary,
          width: 2,
          strokeAlign: 1,
        ),
        disabledForegroundColor: AppColors.gray400,
        foregroundColor: variant != null ? variant!.color : AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      label: Text(isLoading ? 'Carregando...' : label),
      icon: isLoading
          ? CircularProgressIndicator(
              backgroundColor: variant != null
                  ? variant!.color
                  : AppColors.primary,
              constraints: BoxConstraints(minHeight: 22, minWidth: 22),
            )
          : icon,
      iconAlignment: iconAlignment,
      onPressed: isLoading || disabled ? null : onPressed,
    );
  }
}
