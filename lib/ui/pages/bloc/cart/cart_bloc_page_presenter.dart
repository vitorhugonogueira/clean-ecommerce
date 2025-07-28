import 'package:bloc/bloc.dart';
import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';

class CartBlocPagePresenter extends Cubit<CartDetailsState>
    implements CartDetailsPresenter {
  CartBlocPagePresenter(Cart? cart) : super(CartDetailsState(cart: cart));

  @override
  void setIsLoading(bool inProgress) {
    emit(state.copyWith(isLoading: inProgress));
  }

  @override
  void setIsValidatingAction(bool inProgress) {
    emit(state.copyWith(isValidatingAction: inProgress));
  }

  @override
  void showCart(Cart cart) {
    emit(state.copyWith(cart: cart));
  }
}
