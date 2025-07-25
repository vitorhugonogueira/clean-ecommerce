import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';

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
      _presenter.showCart(_initialCart);
      return;
    }

    _presenter.setIsLoading(true);
    Cart cart = await _repository.getCart() ?? Cart();

    _presenter.showCart(cart);
    _presenter.setIsLoading(false);
  }
}
