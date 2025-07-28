import 'package:clean_ecommerce/domain/entities/product_pagination.dart';
import 'package:clean_ecommerce/domain/presenters/product_listing_presenter.dart';
import 'package:clean_ecommerce/ui/common/states/product_listing_state.dart';
import 'package:flutter/material.dart';

class ListingProviderPagePresenter extends ChangeNotifier
    implements ProductListingPresenter {
  late ProductListingState _state;

  ListingProviderPagePresenter() {
    _show(ProductListingState());
  }

  _show(ProductListingState state) {
    _state = state;
    notifyListeners();
  }

  @override
  void setIsLoading(bool value) {
    _show(_state.copyWith(isLoading: value));
  }

  @override
  void showProducts(ProductPagination pagination) {
    _show(_state.copyWith(pagination: pagination));
  }

  ProductListingState get state => _state;
}
