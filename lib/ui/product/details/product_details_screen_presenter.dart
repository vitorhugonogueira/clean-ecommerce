import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/states/product_details_state.dart';

class ProductDetailsScreenPresenter implements ProductDetailsPresenter {
  final Function(ProductDetailsState) onStateChanged;
  ProductDetailsState _state;

  ProductDetailsScreenPresenter({
    required this.onStateChanged,
    required ProductDetailsState initialState,
  }) : _state = initialState;

  @override
  void show(ProductDetailsState state) {
    _state = state;
    onStateChanged(state);
  }

  @override
  void setIsLoading(bool inProgress) {
    show(_state.copyWith(isLoading: inProgress));
  }

  @override
  void setIsValidatingAction(bool inProgress) {
    show(_state.copyWith(isValidatingAction: inProgress));
  }
}
