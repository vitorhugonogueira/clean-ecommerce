import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/usecases/cart/decrease_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/increase_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/remove_item_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/show_cart_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';
import 'package:flutter/foundation.dart';

class CartViewModel extends ChangeNotifier implements CartDetailsPresenter {
  final CartRepository repository;
  final StockRepository stockRepository;
  final DialogGateway dialog;
  late IncreaseCartItemUsecase _increase;
  late DecreaseCartItemUsecase _decrease;
  late RemoveItemToCartUseCase _remove;
  late CartDetailsState _state;

  CartDetailsState get state => _state;

  CartViewModel({
    required this.dialog,
    required this.repository,
    required this.stockRepository,
  }) {
    _increase = IncreaseCartItemUsecase(
      cartRepository: repository,
      dialog: dialog,
      presenter: this,
      stockRepository: stockRepository,
    );
    _decrease = DecreaseCartItemUsecase(
      cartRepository: repository,
      dialog: dialog,
      presenter: this,
    );
    _remove = RemoveItemToCartUseCase(
      cartRepository: repository,
      dialog: dialog,
      presenter: this,
    );
    _state = CartDetailsState(cart: Cart());
    ShowCartDetailsUsecase(repository: repository, presenter: this).execute();
  }

  void increase(Item item) {
    _increase.execute(productId: item.product.id, cart: _state.cart);
  }

  void decrease(Item item) {
    _decrease.execute(productId: item.product.id, cart: _state.cart);
  }

  void remove(Item item) {
    _remove.execute(productId: item.product.id, cart: _state.cart);
  }

  @override
  void setIsLoading(bool inProgress) {
    _state = _state.copyWith(isLoading: inProgress);
    notifyListeners();
  }

  @override
  void setIsValidatingAction(bool inProgress) {
    _state = _state.copyWith(isValidatingAction: inProgress);
    notifyListeners();
  }

  @override
  void showCart(Cart cart) {
    _state = _state.copyWith(cart: cart);
    notifyListeners();
  }
}
