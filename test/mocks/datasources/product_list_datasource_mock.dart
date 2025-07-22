import 'package:clean_ecommerce/domain/repositories/product_listing_repository.dart';
import 'package:clean_ecommerce/domain/result/result.dart';
import 'package:clean_ecommerce/domain/states/product_listing_state.dart';

class ProductListingDataSourceMock extends ProductListingRepository {
  final Result<ProductListingState> _result;

  ProductListingDataSourceMock._(this._result);

  factory ProductListingDataSourceMock.success(ProductListingState state) =>
      ProductListingDataSourceMock._(Result.success(state));

  factory ProductListingDataSourceMock.failure(String errorMessage) =>
      ProductListingDataSourceMock._(Result.failure(errorMessage));

  @override
  Future<Result<ProductListingState>> getProducts(
    int page,
    int pageSize,
  ) async {
    return _result;
  }
}
