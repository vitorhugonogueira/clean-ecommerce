import 'package:flutter/material.dart';

class AppRouter extends StatelessWidget {
  final Widget productListingScreen;
  final Widget cartScreen;
  final Widget Function(String id) getProductDetailsScreen;
  final Color themeColor;

  const AppRouter({
    super.key,
    required this.themeColor,
    required this.productListingScreen,
    required this.cartScreen,
    required this.getProductDetailsScreen,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: themeColor);
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: scheme.onPrimary,
        colorScheme: scheme,
        useMaterial3: true,
        fontFamily: 'Montserrat',
      ),
      child: Navigator(
        onGenerateRoute: (settings) {
          final String? path = settings.name;
          final uri = Uri.parse(path ?? '/');

          if (path == '/') {
            return MaterialPageRoute(
              builder: (context) => productListingScreen,
            );
          }
          if (path == '/cart') {
            return MaterialPageRoute(builder: (context) => cartScreen);
          }
          if (uri.pathSegments[0] == 'details') {
            final id = uri.pathSegments[1];
            return MaterialPageRoute(
              builder: (context) => getProductDetailsScreen(id),
            );
          }

          return MaterialPageRoute(
            builder: (context) => const Text('Erro de rota'),
          );
        },
        initialRoute: '/',
      ),
    );
  }
}
