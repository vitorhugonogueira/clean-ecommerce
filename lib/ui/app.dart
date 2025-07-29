import 'package:clean_ecommerce/ui/app_flavor.dart';
import 'package:clean_ecommerce/ui/app_router.dart';
import 'package:clean_ecommerce/ui/pages/bloc/cart/cart_bloc_page.dart';
import 'package:clean_ecommerce/ui/pages/bloc/listing/listing_bloc_page.dart';
import 'package:clean_ecommerce/ui/pages/bloc/product/product_bloc_page.dart';
import 'package:clean_ecommerce/ui/pages/menu_page.dart';
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
        '/': (context) => const MenuPage(),
        '/state-app':
            (context) => AppRouter(
              flavor: Flavor.state,
              productListingScreen: ListingStatePage(),
              cartScreen: CartStatePage(),
              getProductDetailsScreen: (id) {
                return ProductStatePage(productId: id);
              },
            ),
        '/provider-app':
            (context) => AppRouter(
              flavor: Flavor.provider,
              productListingScreen: ListingProviderPage(),
              cartScreen: CartProviderPage(),
              getProductDetailsScreen: (id) {
                return ProductProviderPage(productId: id);
              },
            ),
        '/bloc-app':
            (context) => AppRouter(
              flavor: Flavor.bloc,
              productListingScreen: ListingBlocPage(),
              cartScreen: CartBlocPage(),
              getProductDetailsScreen: (id) {
                return ProductBlocPage(productId: id);
              },
            ),
      },
      initialRoute: '/',
    );
  }
}
