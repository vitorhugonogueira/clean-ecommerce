import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/repositories/product_details_repository.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';

class ProductDetailsDataSourceMock extends ProductDetailsRepository {
  final Result<Product> _result;

  ProductDetailsDataSourceMock._(this._result);

  factory ProductDetailsDataSourceMock.success(Product state) =>
      ProductDetailsDataSourceMock._(Result.success(state));

  factory ProductDetailsDataSourceMock.failure(String errorMessage) =>
      ProductDetailsDataSourceMock._(Result.failure(errorMessage));

  @override
  Future<Result<Product>> getProductDetails(String productId) async {
    return _result;
  }
}
