import 'package:clean_ecommerce/domain/entities/product_pagination.dart';
import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/presenters/product_listing_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/product_listing_repository.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_products_usecase.dart';
import 'package:clean_ecommerce/ui/common/states/product_listing_state.dart';
import 'package:flutter/material.dart';

class ListingViewModel extends ChangeNotifier
    implements ProductListingPresenter {
  late ProductListingState _state;
  late ShowProductsUseCase _usecase;

  ListingViewModel({
    required ProductListingRepository repository,
    required DialogGateway dialog,
  }) {
    _state = ProductListingState();
    _usecase = ShowProductsUseCase(
      repository: repository,
      presenter: this,
      dialog: dialog,
    )..execute();
  }

  @override
  void setIsLoading(bool value) {
    _state = _state.copyWith(isLoading: value);
    notifyListeners();
  }

  @override
  void showProducts(ProductPagination pagination) {
    _state = _state.copyWith(pagination: pagination);
    notifyListeners();
  }

  Future<void> fetchProducts() => _usecase.execute();
  ProductListingState get state => _state;
}
