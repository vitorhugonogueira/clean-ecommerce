import 'package:clean_ecommerce/domain/entities/product_pagination.dart';
import 'package:clean_ecommerce/domain/presenters/product_listing_presenter.dart';
import 'package:clean_ecommerce/ui/common/states/product_listing_state.dart';
import 'package:bloc/bloc.dart';

class ListingBlocPagePresenter extends Cubit<ProductListingState>
    implements ProductListingPresenter {
  ListingBlocPagePresenter() : super(ProductListingState());

  @override
  void setIsLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  @override
  void showProducts(ProductPagination pagination) {
    emit(state.copyWith(pagination: pagination));
  }
}
