import 'package:clean_ecommerce/domain/presenters/cart_details_presenter.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';

class CartDetailsScreenPresenter implements CartDetailsPresenter {
  final Function(CartDetailsState) onStateChanged;
  final Function(bool) onInProgressChanged;
  CartDetailsState _state;
  bool _inProgress = false;

  CartDetailsScreenPresenter({
    required this.onStateChanged,
    required this.onInProgressChanged,
    required CartDetailsState initialState,
  }) : _state = initialState;

  @override
  void show(CartDetailsState state) {
    _state = state;
    onStateChanged(state);
  }

  @override
  void setInProgress(bool inProgress) {
    _inProgress = inProgress;
    onInProgressChanged(inProgress);
  }

  CartDetailsState get state => _state;
  bool get inProgress => _inProgress;
}
