import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/models/product.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/states/product_details_state.dart';

class UpdateProductStockDetailsUseCase {
  final CartRepository cartRepository;
  final StockRepository stockRepository;
  final ProductDetailsPresenter presenter;
  final DialogGateway dialog;

  UpdateProductStockDetailsUseCase({
    required this.stockRepository,
    required this.cartRepository,
    required this.presenter,
    required this.dialog,
  });

  Future<void> execute({required Product product}) async {
    presenter.setIsLoading(true);

    final stockResult = await stockRepository.getStockAvailable(product.id);
    if (stockResult.isFailure) {
      dialog.showError(stockResult.errorMessage!);
      presenter.setIsLoading(false);
      return;
    }
    var currentStockAvailable = stockResult.content!;
    final cart = await cartRepository.getCart() ?? Cart();
    final item = cart.getItem(product.id);
    if (item != null) {
      currentStockAvailable -= item.quantity;
    }

    presenter.show(
      ProductDetailsState(
        product: product,
        stock: currentStockAvailable,
        isLoading: false,
      ),
    );
  }
}
