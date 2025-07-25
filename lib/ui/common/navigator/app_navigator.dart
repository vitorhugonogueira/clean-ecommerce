import 'package:clean_ecommerce/domain/gateways/navigator_gateway.dart';
import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/ui/cart/cart_details_screen.dart';
import 'package:clean_ecommerce/ui/product/details/product_details_screen.dart';
import 'package:flutter/material.dart';

class AppNavigator implements NavigatorGateway {
  final BuildContext context;
  final Function? cartGoBackCallback;

  AppNavigator(this.context, {this.cartGoBackCallback});

  @override
  void goCart({Cart? cart, Function? callback}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: '/cart'),
        builder: (context) => CartDetailsScreen(cart: cart),
      ),
    );
    if (cartGoBackCallback != null) {
      cartGoBackCallback!();
    }
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
