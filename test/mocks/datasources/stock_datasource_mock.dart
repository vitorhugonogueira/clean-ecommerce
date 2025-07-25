import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';

class StockDataSourceMock extends StockRepository {
  final Result<int> _result;

  StockDataSourceMock._(this._result);

  factory StockDataSourceMock.success(int state) =>
      StockDataSourceMock._(Result.success(state));

  factory StockDataSourceMock.failure(String errorMessage) =>
      StockDataSourceMock._(Result.failure(errorMessage));

  @override
  Future<Result<int>> getStockAvailable(String productId) async {
    return _result;
  }
}
