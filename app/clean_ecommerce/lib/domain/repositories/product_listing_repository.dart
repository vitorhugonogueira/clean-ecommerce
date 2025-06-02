import 'package:clean_ecommerce/domain/models/product.dart';
import 'package:clean_ecommerce/domain/result/result.dart';

class ProductListingResult {
  final List<Product> products;
  final int page;
  final int totalOfPages;
  final int pageSize;

  const ProductListingResult({
    required this.products,
    required this.page,
    required this.totalOfPages,
    required this.pageSize,
  });
}

abstract class ProductListingRepository {
  Future<Result<ProductListingResult>> getProducts(int page, int pageSize);
}
