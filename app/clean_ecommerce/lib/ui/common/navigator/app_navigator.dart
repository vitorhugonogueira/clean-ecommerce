import 'package:clean_ecommerce/domain/gateways/navigator_gateway.dart';
import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/ui/cart/cart_details_screen.dart';
import 'package:clean_ecommerce/ui/product/details/product_details_screen.dart';
import 'package:flutter/material.dart';

class AppNavigator implements NavigatorGateway {
  final BuildContext context;

  AppNavigator(this.context);

  @override
  void goCart({Cart? cart}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: '/cart'),
        builder: (context) => CartDetailsScreen(cart: cart),
      ),
    );
  }

  @override
  void goDetails(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: '/details/$id'),
        builder: (context) => ProductDetailsScreen(productId: id),
      ),
    );
  }

  @override
  void goHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
