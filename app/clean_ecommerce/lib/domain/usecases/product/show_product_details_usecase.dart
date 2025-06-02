import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/product_details_repository.dart';
import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/states/product_details_state.dart';

class ShowProductDetailsUseCase {
  final ProductDetailsRepository repository;
  final CartRepository cartRepository;
  final StockRepository stockRepository;
  final ProductDetailsPresenter presenter;
  final DialogGateway dialog;

  ShowProductDetailsUseCase({
    required this.repository,
    required this.stockRepository,
    required this.cartRepository,
    required this.presenter,
    required this.dialog,
  });

  Future<void> execute({required String productId}) async {
    presenter.setInProgress(true);

    final result = await repository.getProductDetails(productId);

    if (result.isFailure) {
      dialog.showError(result.errorMessage!);
      presenter.setInProgress(false);
      return;
    }

    final stockResult = await stockRepository.getStockAvailable(productId);
    if (stockResult.isFailure) {
      dialog.showError(stockResult.errorMessage!);
      presenter.setInProgress(false);
      return;
    }
    var currentStockAvailable = stockResult.content!;
    final cart = await cartRepository.getCart() ?? Cart();
    final item = cart.getItem(productId);
    if (item != null) {
      currentStockAvailable -= item.quantity;
    }

    presenter.show(
      ProductDetailsState(
        product: result.content,
        stock: currentStockAvailable,
      ),
    );
    presenter.setInProgress(false);
  }
}
