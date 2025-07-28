import 'package:bloc/bloc.dart';
import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/product_details_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/usecases/product/add_product_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/states/product_details_state.dart';
import 'package:flutter/material.dart';

class ProductBlocPagePresenter extends Cubit<ProductDetailsState>
    implements ProductDetailsPresenter {
  late final ShowProductDetailsUseCase usecase;
  late final AddProductToCartUseCase addProductUsecase;

  ProductBlocPagePresenter(BuildContext context, String productId)
    : super(ProductDetailsState()) {
    final cartDataSource = CartDataSource();
    final stockDataSource = StockDataSource();
    final dialog = EcommerceDialog(context);
    final navigator = EcommerceNavigator(
      context,
      cartGoBackCallback: () {
        usecase.execute(productId: productId, product: state.product);
      },
    );

    usecase = ShowProductDetailsUseCase(
      repository: ProductDetailsDataSource(),
      presenter: this,
      dialog: dialog,
      cartRepository: cartDataSource,
      stockRepository: stockDataSource,
    )..execute(productId: productId);

    addProductUsecase = AddProductToCartUseCase(
      cartRepository: CartDataSource(),
      dialog: dialog,
      navigator: navigator,
      presenter: this,
      stockRepository: stockDataSource,
    );
  }

  @override
  void setIsLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  @override
  void setIsValidatingAction(bool inProgress) {
    emit(state.copyWith(isValidatingAction: inProgress));
  }

  @override
  void showProduct(Product product) {
    emit(state.copyWith(product: product));
  }

  @override
  void showStock(int stock) {
    emit(state.copyWith(stock: stock));
  }
}
