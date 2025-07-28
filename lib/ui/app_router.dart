import 'package:clean_ecommerce/ui/app_flavor.dart';
import 'package:flutter/material.dart';

class AppRouter extends StatelessWidget {
  final Widget productListingScreen;
  final Widget cartScreen;
  final Widget Function(String id) getProductDetailsScreen;
  final Flavor flavor;

  const AppRouter({
    super.key,
    required this.flavor,
    required this.productListingScreen,
    required this.cartScreen,
    required this.getProductDetailsScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppFlavor.getTheme(flavor),
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
