import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';

abstract class ProductDetailsRepository {
  Future<Result<Product>> getProductDetails(String productId);
}
