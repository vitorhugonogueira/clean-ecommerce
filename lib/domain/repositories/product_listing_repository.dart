import 'package:clean_ecommerce/domain/entities/product_pagination.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';

abstract class ProductListingRepository {
  Future<Result<ProductPagination>> getProducts(int page, int pageSize);
}
