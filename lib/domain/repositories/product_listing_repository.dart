import 'package:clean_ecommerce/domain/result/result.dart';
import 'package:clean_ecommerce/domain/states/product_listing_state.dart';

abstract class ProductListingRepository {
  Future<Result<ProductListingState>> getProducts(int page, int pageSize);
}
