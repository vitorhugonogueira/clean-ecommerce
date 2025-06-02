import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';

class DecreaseCartItemUsecase {
  final CartRepository cartRepository;
  final DialogGateway dialog;
  final CartDetailsPresenter presenter;

  DecreaseCartItemUsecase({
    required this.cartRepository,
    required this.dialog,
    required this.presenter,
  });

  Future<void> execute({required String productId, required Cart cart}) async {
    final item = cart.getItem(productId);
    if (item == null) {
      dialog.showError('Item not found.');
      return;
    }

    final updatedCart = cart.updateItemQuantity(productId, item.quantity - 1);

    final result = await cartRepository.saveCart(updatedCart);
    if (result.isFailure) {
      dialog.showError(result.errorMessage!);
      return;
    }
    presenter.show(CartDetailsState(cart: updatedCart));
  }
}
