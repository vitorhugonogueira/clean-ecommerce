import 'package:clean_ecommerce/domain/models/product_pagination.dart';
import 'package:clean_ecommerce/domain/result/result.dart';

abstract class ProductListingRepository {
  Future<Result<ProductPagination>> getProducts(int page, int pageSize);
}
