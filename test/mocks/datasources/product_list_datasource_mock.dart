import 'package:clean_ecommerce/domain/entities/product_pagination.dart';
import 'package:clean_ecommerce/domain/repositories/product_listing_repository.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';

class ProductListingDataSourceMock extends ProductListingRepository {
  final Result<ProductPagination> _result;

  ProductListingDataSourceMock._(this._result);

  factory ProductListingDataSourceMock.success(ProductPagination state) =>
      ProductListingDataSourceMock._(Result.success(state));

  factory ProductListingDataSourceMock.failure(String errorMessage) =>
      ProductListingDataSourceMock._(Result.failure(errorMessage));

  @override
  Future<Result<ProductPagination>> getProducts(int page, int pageSize) async {
    return _result;
  }
}
