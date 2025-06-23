import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/states/product_details_state.dart';

class ProductDetailsScreenPresenter implements ProductDetailsPresenter {
  final Function(ProductDetailsState) onStateChanged;
  final Function(bool) onInProgressChanged;
  ProductDetailsState _state;
  bool _inProgress = false;

  ProductDetailsScreenPresenter({
    required this.onStateChanged,
    required this.onInProgressChanged,
    required ProductDetailsState initialState,
  }) : _state = initialState;

  @override
  void show(ProductDetailsState state) {
    _state = state;
    onStateChanged(state);
  }

  @override
  void setInProgress(bool inProgress) {
    _inProgress = inProgress;
    onInProgressChanged(inProgress);
  }

  ProductDetailsState get state => _state;
  bool get inProgress => _inProgress;
}
