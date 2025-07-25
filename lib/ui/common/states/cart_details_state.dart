import 'package:clean_ecommerce/domain/models/cart.dart';

class CartDetailsState {
  final Cart? cart;
  final bool isLoading;
  final bool isValidatingAction;

  CartDetailsState({
    this.cart,
    this.isLoading = false,
    this.isValidatingAction = false,
  });

  CartDetailsState copyWith({
    Cart? cart,
    bool? isLoading,
    bool? isValidatingAction,
  }) {
    return CartDetailsState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      isValidatingAction: isValidatingAction ?? this.isValidatingAction,
    );
  }
}
