import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/ui/common/states/product_details_state.dart';

class ProductDetailsScreenPresenter implements ProductDetailsPresenter {
  final Function(ProductDetailsState) onStateChanged;
  late ProductDetailsState _state;

  ProductDetailsScreenPresenter({required this.onStateChanged}) {
    _show(ProductDetailsState());
  }

  _show(ProductDetailsState state) {
    _state = state;
    onStateChanged(state);
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
}
