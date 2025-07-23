import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';

class CartDetailsScreenPresenter implements CartDetailsPresenter {
  final Function(CartDetailsState) onStateChanged;
  CartDetailsState _state;

  CartDetailsScreenPresenter({
    required this.onStateChanged,
    required CartDetailsState initialState,
  }) : _state = initialState;

  @override
  void show(CartDetailsState state) {
    _state = state;
    onStateChanged(state);
  }

  @override
  void setIsLoading(bool inProgress) {
    show(
      CartDetailsState(
        cart: _state.cart,
        isValidatingIncrease: _state.isValidatingIncrease,
        isLoading: inProgress,
      ),
    );
  }

  @override
  void setIsValidatingIncrease(bool inProgress) {
    show(
      CartDetailsState(
        cart: _state.cart,
        isValidatingIncrease: inProgress,
        isLoading: _state.isLoading,
      ),
    );
  }
}
