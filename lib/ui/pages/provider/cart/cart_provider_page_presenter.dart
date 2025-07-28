import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';
import 'package:flutter/material.dart';

class CartProviderPagePresenter extends ChangeNotifier
    implements CartDetailsPresenter {
  CartDetailsState _state;

  CartProviderPagePresenter({required CartDetailsState initialState})
    : _state = initialState;

  void show(CartDetailsState state) {
    _state = state;
    notifyListeners();
  }

  @override
  void setIsLoading(bool inProgress) {
    show(_state.copyWith(isLoading: inProgress));
  }

  @override
  void setIsValidatingAction(bool inProgress) {
    show(_state.copyWith(isValidatingAction: inProgress));
  }

  @override
  void showCart(Cart cart) {
    show(_state.copyWith(cart: cart));
  }

  CartDetailsState get state => _state;
}
