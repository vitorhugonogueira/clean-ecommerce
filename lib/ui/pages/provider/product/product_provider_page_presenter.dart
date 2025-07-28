import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/ui/common/states/product_details_state.dart';
import 'package:flutter/material.dart';

class ProductProviderPagePresenter extends ChangeNotifier
    implements ProductDetailsPresenter {
  late ProductDetailsState _state;

  ProductProviderPagePresenter() {
    _show(ProductDetailsState());
  }

  _show(ProductDetailsState state) {
    _state = state;
    notifyListeners();
  }

  @override
  setIsLoading(bool inProgress) {
    _show(_state.copyWith(isLoading: inProgress));
  }

  @override
  setIsValidatingAction(bool inProgress) {
    _show(_state.copyWith(isValidatingAction: inProgress));
  }

  @override
  showProduct(Product product) {
    _show(_state.copyWith(product: product));
  }

  @override
  showStock(int stock) {
    _show(_state.copyWith(stock: stock));
  }

  ProductDetailsState get state => _state;
}
