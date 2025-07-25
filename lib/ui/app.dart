import 'package:clean_ecommerce/ui/app_router.dart';
import 'package:clean_ecommerce/ui/menu_screen.dart';
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
        '/': (context) => const MenuScreen(),
        '/state-app':
            (context) => AppRouter(
              themeColor: Colors.deepOrange,
              productListingScreen: ListingStatePage(),
              cartScreen: CartStatePage(),
              getProductDetailsScreen: (id) {
                return ProductStatePage(productId: id);
              },
            ),
      },
      initialRoute: '/',
    );
  }
}
