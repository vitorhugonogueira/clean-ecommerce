import 'package:flutter/material.dart';

enum Flavor { state, provider }

final variantColor = {
  Flavor.state: Colors.deepPurple,
  Flavor.provider: Colors.lightGreenAccent,
};

class AppFlavor {
  static ColorScheme getColorScheme(Flavor flavor) {
    return ColorScheme.fromSeed(
      seedColor: variantColor[flavor] ?? variantColor[Flavor.state]!,
    );
  }

  static ThemeData getTheme(Flavor flavor) {
    final scheme = getColorScheme(flavor);

    return ThemeData(
      scaffoldBackgroundColor: scheme.onPrimary,
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: 'Montserrat',
    );
  }
}
