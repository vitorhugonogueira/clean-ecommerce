import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';

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

    presenter.setIsValidatingAction(true);
    final stockResult = await stockRepository.getStockAvailable(productId);
    if (stockResult.isFailure) {
      dialog.showError(stockResult.errorMessage!);
      presenter.setIsValidatingAction(false);
      return;
    }

    final newQuantity = item.quantity + 1;
    if (newQuantity > stockResult.content!) {
      dialog.showWarning(
        'Sorry, we currently do not have enough stock for quantity $newQuantity of ${item.product.name}.',
      );
      presenter.setIsValidatingAction(false);
      return;
    }

    final updatedCart = cart.updateItemQuantity(productId, newQuantity);
    final result = await cartRepository.saveCart(updatedCart);
    if (result.isFailure) {
      dialog.showError(result.errorMessage!);
      presenter.setIsValidatingAction(false);
      return;
    }

    presenter.setIsValidatingAction(false);
    presenter.showCart(updatedCart);
  }
}
