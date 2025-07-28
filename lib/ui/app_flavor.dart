import 'package:flutter/material.dart';

enum Flavor { state, provider }

final variantColor = {
  Flavor.state: Colors.deepPurple,
  Flavor.provider: Colors.lightGreenAccent,
};

class AppFlavor {
  static ColorScheme colorScheme(Flavor flavor) {
    return ColorScheme.fromSeed(
      seedColor: variantColor[flavor] ?? variantColor[Flavor.state]!,
    );
  }

  static ThemeData theme(Flavor flavor) {
    final scheme = colorScheme(flavor);

    return ThemeData(
      scaffoldBackgroundColor: scheme.onPrimary,
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: 'Montserrat',
    );
  }
}
