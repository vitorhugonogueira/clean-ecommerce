import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/gateways/navigator_gateway.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/product_details_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/usecases/product/add_product_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/states/product_details_state.dart';
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier
    implements ProductDetailsPresenter {
  final ProductDetailsRepository repository;
  final CartRepository cartRepository;
  final DialogGateway dialog;
  final NavigatorGateway navigator;
  final StockRepository stockRepository;
  final String productId;
  late final ShowProductDetailsUseCase _usecase;
  late final AddProductToCartUseCase _addUsecase;

  late ProductDetailsState _state;

  ProductDetailsState get state => _state;

  ProductViewModel({
    required this.productId,
    required this.cartRepository,
    required this.dialog,
    required this.navigator,
    required this.stockRepository,
    required this.repository,
    Product? product,
  }) {
    _state = ProductDetailsState(
      isLoading: true,
      isValidatingAction: false,
      product: product,
      stock: 0,
    );
    _usecase = ShowProductDetailsUseCase(
      repository: repository,
      stockRepository: stockRepository,
      cartRepository: cartRepository,
      presenter: this,
      dialog: dialog,
    )..execute(productId: productId, product: product);
    _addUsecase = AddProductToCartUseCase(
      cartRepository: cartRepository,
      dialog: dialog,
      navigator: navigator,
      presenter: this,
      stockRepository: stockRepository,
    );
  }

  @override
  void setIsLoading(bool inProgress) {
    _state = _state.copyWith(isLoading: inProgress);
    notifyListeners();
  }

  @override
  void setIsValidatingAction(bool inProgress) {
    _state = _state.copyWith(isValidatingAction: inProgress);
    notifyListeners();
  }

  @override
  void showProduct(Product product) {
    _state = _state.copyWith(product: product);
    notifyListeners();
  }

  @override
  void showStock(int stock) {
    _state = _state.copyWith(stock: stock);
    notifyListeners();
  }

  Future<void> load({required String productId, Product? product}) {
    return _usecase.execute(productId: productId, product: product);
  }

  Future<void> addProductToCart(
    Product product, {
    int quantity = 1,
    bool continueShopping = true,
  }) {
    return _addUsecase.execute(
      product,
      quantity: quantity,
      continueShopping: continueShopping,
    );
  }
}
