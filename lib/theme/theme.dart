import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nummo/theme/app_colors.dart';

final ThemeData theme = ThemeData();

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.gray900,
    secondary: AppColors.secondary,
    onSecondary: AppColors.foreground,
    surface: Colors.white,
    onSurface: AppColors.gray900,
    onSurfaceVariant: AppColors.gray700,
    error: AppColors.danger,
    onError: AppColors.foreground,
    outline: AppColors.gray400,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
  scaffoldBackgroundColor: AppColors.background,
  menuButtonTheme: MenuButtonThemeData(
    style: MenuItemButton.styleFrom(foregroundColor: AppColors.foreground),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.foreground,
    secondary: AppColors.secondary,
    onSecondary: AppColors.foreground,
    surface: AppColors.gray800,
    onSurface: AppColors.gray100,
    onSurfaceVariant: AppColors.gray400,
    error: AppColors.danger,
    onError: Colors.black,
    outline: AppColors.gray700,
  ),
  textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
  scaffoldBackgroundColor: AppColors.darkBackground,
  menuButtonTheme: MenuButtonThemeData(
    style: MenuItemButton.styleFrom(foregroundColor: AppColors.foreground),
  ),
);
