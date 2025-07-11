import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/gateways/navigator_gateway.dart';
import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/states/product_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/product/update_product_stock_details_usecase.dart';

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

    var cart = await cartRepository.getCart() ?? Cart();
    cart = cart.addItem(productState.product!, quantity);

    final result = await cartRepository.saveCart(cart);
    if (result.isFailure) {
      dialog.showError(result.errorMessage!);
      return;
    }

    final stockResult = await stockRepository.getStockAvailable(
      productState.product!.id,
    );
    if (stockResult.isFailure) {
      dialog.showError(stockResult.errorMessage!);
      presenter.setInProgress(false);
      return;
    }

    var currentStockAvailable = stockResult.content!;
    final item = cart.getItem(productState.product!.id);
    if (item != null) {
      currentStockAvailable -= item.quantity;
    }

    if (continueShopping) {
      presenter.show(
        ProductDetailsState(
          product: productState.product,
          stock: currentStockAvailable,
        ),
      );
      dialog.notifySuccess('Item added to cart successfully');
      return;
    }

    navigator.goCart(
      cart: cart,
      callback: () {
        final updateUseCase = UpdateProductStockDetailsUseCase(
          cartRepository: cartRepository,
          stockRepository: stockRepository,
          presenter: presenter,
          dialog: dialog,
        );
        updateUseCase.execute(product: productState.product!);
      },
    );
    return;
  }
}
