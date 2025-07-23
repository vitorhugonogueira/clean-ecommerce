import 'package:clean_ecommerce/domain/models/cart.dart';

class CartDetailsState {
  final Cart? cart;
  final bool isLoading;
  final bool isValidatingIncrease;

  CartDetailsState({
    this.cart,
    this.isLoading = false,
    this.isValidatingIncrease = false,
  });
}
