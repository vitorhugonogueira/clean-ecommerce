import 'package:clean_ecommerce/ui/app_router.dart';
import 'package:clean_ecommerce/ui/menu_screen.dart';
import 'package:clean_ecommerce/ui/state_app/cart/cart_details_screen.dart';
import 'package:clean_ecommerce/ui/state_app/product/details/product_details_screen.dart';
import 'package:clean_ecommerce/ui/state_app/product/listing/product_listing_screen.dart';
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
              productListingScreen: ProductListingScreen(),
              cartScreen: CartDetailsScreen(),
              getProductDetailsScreen: (id) {
                return ProductDetailsScreen(productId: id);
              },
            ),
      },
      initialRoute: '/',
    );
  }
}
