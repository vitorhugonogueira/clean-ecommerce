import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/gateways/navigator_gateway.dart';
import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/states/product_details_state.dart';

class AddItemToCartUseCase {
  final CartRepository cartRepository;
  final StockRepository stockRepository;
  final ProductDetailsPresenter presenter;
  final NavigatorGateway navigator;
  final DialogGateway dialog;

  AddItemToCartUseCase({
    required this.cartRepository,
    required this.dialog,
    required this.navigator,
    required this.presenter,
    required this.stockRepository,
  });

  Future<void> execute({
    required ProductDetailsState productState,
    int quantity = 1,
    bool continueShopping = true,
  }) async {
    if (productState.product == null) {
      dialog.showError('Product not found.');
      return;
    }
    if (quantity <= 0) {
      dialog.showError('Quantity must be greater than zero.');
      return;
    }

    presenter.setIsValidatingAction(true);
    var cart = await cartRepository.getCart() ?? Cart();
    cart = cart.addItem(productState.product!, quantity);

    final result = await cartRepository.saveCart(cart);
    if (result.isFailure) {
      dialog.showError(result.errorMessage!);
      presenter.setIsValidatingAction(false);
      return;
    }

    if (!continueShopping) {
      navigator.goCart(cart: cart);
      return;
    }

    dialog.notifySuccess('Item added to cart successfully');
    final item = cart.getItem(productState.product!.id);
    final stock = await _getStockOrShowError(productState.product!.id);
    final stockAvailable = stock - (item?.quantity ?? 0);

    presenter.show(
      productState.copyWith(stock: stockAvailable, isValidatingAction: false),
    );
  }

  Future<int> _getStockOrShowError(String productId) async {
    final stockResult = await stockRepository.getStockAvailable(productId);
    if (stockResult.isFailure) {
      dialog.showError(stockResult.errorMessage!);
    }
    return stockResult.content ?? 0;
  }
}
