import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/models/product.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/product_details_repository.dart';
import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';

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

  Future<void> execute({required String productId, Product? product}) async {
    Product? loadedProduct = product;
    if (loadedProduct == null) {
      presenter.setIsLoading(true);
      loadedProduct = await _getProductOrShowError(productId);
      presenter.setIsLoading(false);
      if (loadedProduct == null) {
        return;
      }
    }

    presenter.showProduct(loadedProduct);
    presenter.setIsValidatingAction(true);

    final cart = await cartRepository.getCart() ?? Cart();
    final item = cart.getItem(productId);
    final stock = await _getStockOrShowError(productId);
    final stockAvailable = stock - (item?.quantity ?? 0);

    presenter.showStock(stockAvailable);
    presenter.setIsValidatingAction(false);
  }

  Future<Product?> _getProductOrShowError(String productId) async {
    final result = await repository.getProductDetails(productId);
    if (result.isFailure) {
      dialog.showError(result.errorMessage!);
    }
    return result.content;
  }

  Future<int> _getStockOrShowError(String productId) async {
    final stockResult = await stockRepository.getStockAvailable(productId);
    if (stockResult.isFailure) {
      dialog.showError(stockResult.errorMessage!);
    }
    return stockResult.content ?? 0;
  }
}
