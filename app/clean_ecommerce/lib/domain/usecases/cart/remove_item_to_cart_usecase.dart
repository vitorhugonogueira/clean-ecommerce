import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';

class RemoveItemToCartUseCase {
  final CartRepository cartRepository;
  final DialogGateway dialog;
  final CartDetailsPresenter presenter;

  RemoveItemToCartUseCase({
    required this.cartRepository,
    required this.dialog,
    required this.presenter,
  });

  Future<void> execute({required String productId, required Cart cart}) async {
    final updatedCart = cart.removeItem(productId);

    final result = await cartRepository.saveCart(updatedCart);
    if (result.isFailure) {
      dialog.showError(result.errorMessage!);
      return;
    }

    presenter.show(CartDetailsState(cart: updatedCart));
  }
}
