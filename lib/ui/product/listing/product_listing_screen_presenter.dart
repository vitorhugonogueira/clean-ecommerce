import 'package:clean_ecommerce/domain/presenters/product_listing_presenter.dart';
import 'package:clean_ecommerce/domain/states/product_listing_state.dart';

class ProductListingScreenPresenter implements ProductListingPresenter {
  final Function(ProductListingState) onStateChanged;
  final Function(bool) onInProgressChanged;
  ProductListingState _state;
  bool _inProgress = false;

  ProductListingScreenPresenter({
    required this.onStateChanged,
    required this.onInProgressChanged,
    required ProductListingState initialState,
  }) : _state = initialState;

  @override
  void show(ProductListingState state) {
    _state = state;
    onStateChanged(state);
  }

  @override
  void setInProgress(bool inProgress) {
    _inProgress = inProgress;
    onInProgressChanged(inProgress);
  }

  ProductListingState? get state => _state;

  bool get inProgress => _inProgress;
}
