import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';

class IncreaseCartItemUsecase {
  final CartRepository cartRepository;
  final StockRepository stockRepository;
  final DialogGateway dialog;
  final CartDetailsPresenter presenter;

  IncreaseCartItemUsecase({
    required this.cartRepository,
    required this.dialog,
    required this.presenter,
    required this.stockRepository,
  });

  Future<void> execute({required String productId, required Cart cart}) async {
    final item = cart.getItem(productId);
    if (item == null) {
      dialog.showError('Item not found.');
      return;
    }

    final stockResult = await stockRepository.getStockAvailable(productId);
    if (stockResult.isFailure) {
      dialog.showError(stockResult.errorMessage!);
      presenter.setInProgress(false);
      return;
    }

    final newQuantity = item.quantity + 1;
    if (newQuantity > stockResult.content!) {
      dialog.showWarning(
        'Sorry, we currently do not have enough stock for quantity $newQuantity of ${item.product.name}.',
      );
      return;
    }

    final updatedCart = cart.updateItemQuantity(productId, newQuantity);

    final result = await cartRepository.saveCart(updatedCart);
    if (result.isFailure) {
      dialog.showError(result.errorMessage!);
      return;
    }

    presenter.show(CartDetailsState(cart: updatedCart));
  }
}
