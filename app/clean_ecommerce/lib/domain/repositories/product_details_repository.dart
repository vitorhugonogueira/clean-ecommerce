import 'package:clean_ecommerce/domain/models/product.dart';
import 'package:clean_ecommerce/domain/result/result.dart';

abstract class ProductDetailsRepository {
  Future<Result<Product>> getProductDetails(String productId);
}
