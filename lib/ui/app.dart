import 'package:clean_ecommerce/ui/app_flavor.dart';
import 'package:clean_ecommerce/ui/app_router.dart';
import 'package:clean_ecommerce/ui/pages/bloc/cart/cart_bloc_page.dart';
import 'package:clean_ecommerce/ui/pages/bloc/listing/listing_bloc_page.dart';
import 'package:clean_ecommerce/ui/pages/bloc/product/product_bloc_page.dart';
import 'package:clean_ecommerce/ui/pages/menu_page.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/mvvm_router.dart';
import 'package:clean_ecommerce/ui/pages/provider/cart/cart_provider_page.dart';
import 'package:clean_ecommerce/ui/pages/provider/listing/listing_provider_page.dart';
import 'package:clean_ecommerce/ui/pages/provider/product/product_provider_page.dart';
import 'package:clean_ecommerce/ui/pages/state/cart/cart_state_page.dart';
import 'package:clean_ecommerce/ui/pages/state/product/product_state_page.dart';
import 'package:clean_ecommerce/ui/pages/state/listing/listing_state_page.dart';
import 'package:flutter/material.dart';

class CleanArchEcommerce extends StatelessWidget {
  const CleanArchEcommerce({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Arch E-Commerce',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Montserrat'),
      routes: {
        '/': (context) => MenuPage(),
        '/state-app':
            (context) => AppRouter(
              flavor: Flavor.state,
              listingScreenBuilder: (_) => ListingStatePage(),
              cartScreenBuilder: (_) => CartStatePage(),
              productScreenBuilder: (_, id) {
                return ProductStatePage(productId: id);
              },
            ),
        '/provider-app':
            (context) => AppRouter(
              flavor: Flavor.provider,
              listingScreenBuilder: (_) => ListingProviderPage(),
              cartScreenBuilder: (_) => CartProviderPage(),
              productScreenBuilder: (_, id) {
                return ProductProviderPage(productId: id);
              },
            ),
        '/bloc-app':
            (context) => AppRouter(
              flavor: Flavor.bloc,
              listingScreenBuilder: (_) => ListingBlocPage(),
              cartScreenBuilder: (_) => CartBlocPage(),
              productScreenBuilder: (_, id) {
                return ProductBlocPage(productId: id);
              },
            ),
        '/mvvm-app': (context) => MvvmRouter(),
      },
      initialRoute: '/',
    );
  }
}
