import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';

class ShowCartDetailsUsecase {
  final CartDetailsPresenter _presenter;
  final CartRepository _repository;
  final Cart? _initialCart;

  ShowCartDetailsUsecase({
    required CartDetailsPresenter presenter,
    required CartRepository repository,
    Cart? cart,
  }) : _initialCart = cart,
       _presenter = presenter,
       _repository = repository;

  Future<void> execute() async {
    if (_initialCart != null) {
      _presenter.show(CartDetailsState(cart: _initialCart));
      return;
    }

    _presenter.setInProgress(true);
    Cart cart = await _repository.getCart() ?? Cart();

    _presenter.show(CartDetailsState(cart: cart));
    _presenter.setInProgress(false);
  }
}
