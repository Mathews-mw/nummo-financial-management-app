import 'package:flutter/material.dart';
import 'package:nummo/theme/app_colors.dart';

enum Variant {
  primary,
  secondary,
  optimistic,
  vibrant,
  muted,
  success,
  danger;

  Color get color {
    switch (this) {
      case Variant.primary:
        return AppColors.primary;
      case Variant.secondary:
        return AppColors.secondary;
      case Variant.vibrant:
        return AppColors.cyan;
      case Variant.optimistic:
        return AppColors.amber;
      case Variant.muted:
        return AppColors.gray400;
      case Variant.success:
        return AppColors.success;
      case Variant.danger:
        return AppColors.danger;
    }
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Variant? variant;
  final Widget? icon;
  final bool isLoading;
  final bool disabled;
  final IconAlignment? iconAlignment;
  final void Function() onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.variant = Variant.primary,
    this.icon,
    this.isLoading = false,
    this.disabled = false,
    this.iconAlignment,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        disabledBackgroundColor: Color.fromRGBO(218, 75, 220, 0.4),
        disabledForegroundColor: AppColors.gray400,
        backgroundColor: variant != null ? variant!.color : AppColors.primary,
        foregroundColor: AppColors.foreground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      label: Text(isLoading ? 'Carregando...' : label),
      icon: isLoading
          ? CircularProgressIndicator(
              backgroundColor: AppColors.primary,
              constraints: BoxConstraints(minHeight: 22, minWidth: 22),
            )
          : icon,
      iconAlignment: iconAlignment,
      onPressed: isLoading || disabled ? null : onPressed,
    );
  }
}
