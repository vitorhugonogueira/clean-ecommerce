import 'package:clean_ecommerce/domain/states/product_details_state.dart';

abstract class ProductDetailsPresenter {
  void show(ProductDetailsState state);
  void setInProgress(bool inProgress);
}
