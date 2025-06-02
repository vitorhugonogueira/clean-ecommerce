import '../states/product_listing_state.dart';

abstract class ProductListingPresenter {
  void show(ProductListingState state);
  void setInProgress(bool value);
}
