import "package:flutter/material.dart";

class AppTheme {
  final TextTheme textTheme;

  const AppTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6a5d45),
      surfaceTint: Color(0xff6a5d45),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffbbaa8f),
      onPrimaryContainer: Color(0xff29200d),
      secondary: Color(0xff655d52),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffede2d4),
      onSecondaryContainer: Color(0xff4e483d),
      tertiary: Color(0xff5b614c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa9af97),
      onTertiaryContainer: Color(0xff1e2313),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffef8f4),
      onSurface: Color(0xff1d1b19),
      onSurfaceVariant: Color(0xff4c463d),
      outline: Color(0xff7d766c),
      outlineVariant: Color(0xffcec5b9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff32302e),
      inversePrimary: Color(0xffd6c4a8),
      primaryFixed: Color(0xfff3e0c2),
      onPrimaryFixed: Color(0xff231a08),
      primaryFixedDim: Color(0xffd6c4a8),
      onPrimaryFixedVariant: Color(0xff51452f),
      secondaryFixed: Color(0xffece1d3),
      onSecondaryFixed: Color(0xff201b12),
      secondaryFixedDim: Color(0xffcfc5b7),
      onSecondaryFixedVariant: Color(0xff4c463b),
      tertiaryFixed: Color(0xffe0e5cb),
      onTertiaryFixed: Color(0xff181d0d),
      tertiaryFixedDim: Color(0xffc3c9b0),
      onTertiaryFixedVariant: Color(0xff434936),
      surfaceDim: Color(0xffded9d5),
      surfaceBright: Color(0xfffef8f4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2ef),
      surfaceContainer: Color(0xfff2ede9),
      surfaceContainerHigh: Color(0xffede7e3),
      surfaceContainerHighest: Color(0xffe7e1de),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd6c4a8),
      surfaceTint: Color(0xffd6c4a8),
      onPrimary: Color(0xff392f1b),
      primaryContainer: Color(0xffa7987d),
      onPrimaryContainer: Color(0xff0e0800),
      secondary: Color(0xffcfc5b7),
      onSecondary: Color(0xff353026),
      secondaryContainer: Color(0xff433d33),
      onSecondaryContainer: Color(0xffdad0c2),
      tertiary: Color(0xffc3c9b0),
      onTertiary: Color(0xff2d3321),
      tertiaryContainer: Color(0xff969c84),
      onTertiaryContainer: Color(0xff050901),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff151311),
      onSurface: Color(0xffe7e1de),
      onSurfaceVariant: Color(0xffcec5b9),
      outline: Color(0xff979085),
      outlineVariant: Color(0xff4c463d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e1de),
      inversePrimary: Color(0xff6a5d45),
      primaryFixed: Color(0xfff3e0c2),
      onPrimaryFixed: Color(0xff231a08),
      primaryFixedDim: Color(0xffd6c4a8),
      onPrimaryFixedVariant: Color(0xff51452f),
      secondaryFixed: Color(0xffece1d3),
      onSecondaryFixed: Color(0xff201b12),
      secondaryFixedDim: Color(0xffcfc5b7),
      onSecondaryFixedVariant: Color(0xff4c463b),
      tertiaryFixed: Color(0xffe0e5cb),
      onTertiaryFixed: Color(0xff181d0d),
      tertiaryFixedDim: Color(0xffc3c9b0),
      onTertiaryFixedVariant: Color(0xff434936),
      surfaceDim: Color(0xff151311),
      surfaceBright: Color(0xff3b3936),
      surfaceContainerLowest: Color(0xff0f0e0c),
      surfaceContainerLow: Color(0xff1d1b19),
      surfaceContainer: Color(0xff211f1d),
      surfaceContainerHigh: Color(0xff2c2a27),
      surfaceContainerHighest: Color(0xff373432),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        inputDecorationTheme: _inputDecorationTheme(colorScheme),
        filledButtonTheme: _filledButtonTheme(colorScheme),
      );

  InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: colorScheme.surface,
      errorMaxLines: 2,
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: colorScheme.error),
      ),
    );
  }

  FilledButtonThemeData _filledButtonTheme(ColorScheme colorScheme) {
    return const FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
