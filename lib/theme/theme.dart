import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nummo/theme/app_colors.dart';

final ThemeData theme = ThemeData();

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: AppColors.primary,
  textTheme: GoogleFonts.latoTextTheme(),
  scaffoldBackgroundColor: AppColors.background,
  // menuTheme: MenuThemeData(
  //   style: MenuStyle(
  //     backgroundColor: WidgetStateProperty.all(AppColors.neutral800),
  //   ),
  // ),
  menuButtonTheme: MenuButtonThemeData(
    style: MenuItemButton.styleFrom(foregroundColor: AppColors.foreground),
  ),
);
