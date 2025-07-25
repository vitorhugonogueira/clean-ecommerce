import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/gateways/navigator_gateway.dart';
import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';

class AddProductToCartUseCase {
  final CartRepository cartRepository;
  final StockRepository stockRepository;
  final ProductDetailsPresenter presenter;
  final NavigatorGateway navigator;
  final DialogGateway dialog;

  AddProductToCartUseCase({
    required this.cartRepository,
    required this.dialog,
    required this.navigator,
    required this.presenter,
    required this.stockRepository,
  });

  Future<void> execute(
    Product product, {
    int quantity = 1,
    bool continueShopping = true,
  }) async {
    if (quantity <= 0) {
      dialog.showError('Quantity must be greater than zero.');
      return;
    }

    presenter.setIsValidatingAction(true);
    var cart = await cartRepository.getCart() ?? Cart();
    final item = cart.getItem(product.id);

    final stockResult = await stockRepository.getStockAvailable(product.id);
    if (stockResult.isFailure) {
      dialog.showError(stockResult.errorMessage!);
      presenter.setIsValidatingAction(false);
      return;
    }

    final stock = stockResult.content!;
    final stockAvailable = stock - (item?.quantity ?? 0);

    if (stockAvailable < quantity) {
      dialog.showError('Insufficient stock available.');
      presenter.setIsValidatingAction(false);
      return;
    }

    cart = cart.addItem(product, quantity);
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
    presenter.showStock(stockAvailable - quantity);
    presenter.setIsValidatingAction(false);
  }
}
