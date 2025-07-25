import 'package:clean_ecommerce/domain/entities/product_pagination.dart';

abstract class ProductListingPresenter {
  void showProducts(ProductPagination pagination);
  void setIsLoading(bool value);
}
