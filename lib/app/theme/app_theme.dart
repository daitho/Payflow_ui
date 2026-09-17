import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';

abstract final class AppTheme {

  static ThemeData get light {

    return ThemeData(

      useMaterial3: true,

      scaffoldBackgroundColor:
      AppColors.background,

      colorScheme:
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
      ),

      inputDecorationTheme:
      InputDecorationTheme(

        filled: true,

        fillColor: Colors.white,

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppRadius.medium,
          ),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppRadius.medium,
          ),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppRadius.medium,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme:
      ElevatedButtonThemeData(

        style: ElevatedButton.styleFrom(

          backgroundColor:
          AppColors.primary,

          foregroundColor:
          Colors.white,

          minimumSize:
          const Size(
            double.infinity,
            58,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              AppRadius.medium,
            ),
          ),

          textStyle:
          const TextStyle(
            fontSize: 17,
            fontWeight:
            FontWeight.w700,
          ),
        ),
      ),
    );
  }
}