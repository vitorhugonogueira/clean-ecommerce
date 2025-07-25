import 'package:clean_ecommerce/domain/gateways/navigator_gateway.dart';
import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:flutter/material.dart';

class EcommerceNavigator implements NavigatorGateway {
  final BuildContext context;
  final Function? cartGoBackCallback;

  EcommerceNavigator(this.context, {this.cartGoBackCallback});

  @override
  void goCart({Cart? cart}) async {
    await Navigator.of(context).pushNamed('/cart');
    if (cartGoBackCallback != null) {
      cartGoBackCallback!();
    }
  }

  @override
  void goDetails(String id) {
    Navigator.of(context).pushNamed('/details/$id');
  }

  @override
  void goHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
