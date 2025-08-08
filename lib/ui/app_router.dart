import 'package:clean_ecommerce/ui/app_config.dart';
import 'package:clean_ecommerce/ui/app_flavor.dart';
import 'package:flutter/material.dart';

class AppRouter extends StatelessWidget {
  final Widget Function(BuildContext context) listingScreenBuilder;
  final Widget Function(BuildContext context) cartScreenBuilder;
  final Widget Function(BuildContext context, String id) productScreenBuilder;
  final Flavor flavor;
  final AppDataSource dataSource;

  const AppRouter({
    super.key,
    required this.dataSource,
    required this.flavor,
    required this.listingScreenBuilder,
    required this.cartScreenBuilder,
    required this.productScreenBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AppConfig(
      dataSource: dataSource,
      child: Theme(
        data: AppFlavor.theme(flavor),
        child: Navigator(
          onGenerateRoute: (settings) {
            final String? path = settings.name;
            final uri = Uri.parse(path ?? '/');

            if (path == '/') {
              return MaterialPageRoute(builder: listingScreenBuilder);
            }
            if (path == '/cart') {
              return MaterialPageRoute(builder: cartScreenBuilder);
            }
            if (uri.pathSegments[0] == 'details') {
              final id = uri.pathSegments[1];
              return MaterialPageRoute(
                builder: (context) => productScreenBuilder(context, id),
              );
            }

            return MaterialPageRoute(
              builder: (context) => const Text('Erro de rota'),
            );
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}
