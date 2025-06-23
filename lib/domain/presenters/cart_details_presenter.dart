import 'package:clean_ecommerce/domain/states/cart_details_state.dart';

abstract class CartDetailsPresenter {
  void show(CartDetailsState state);
  void setInProgress(bool inProgress);
}
