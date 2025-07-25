import 'package:clean_ecommerce/domain/entities/product_pagination.dart';
import 'package:clean_ecommerce/domain/presenters/product_listing_presenter.dart';
import 'package:clean_ecommerce/ui/common/states/product_listing_state.dart';

class ProductListingScreenPresenter implements ProductListingPresenter {
  final Function(ProductListingState) onStateChanged;
  late ProductListingState _state;

  ProductListingScreenPresenter({required this.onStateChanged}) {
    _show(ProductListingState());
  }

  _show(ProductListingState state) {
    _state = state;
    onStateChanged(state);
  }

  @override
  void setIsLoading(bool value) {
    _show(_state.copyWith(isLoading: value));
  }

  @override
  void showProducts(ProductPagination pagination) {
    _show(_state.copyWith(pagination: pagination));
  }
}
