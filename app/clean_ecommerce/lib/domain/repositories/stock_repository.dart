import 'package:clean_ecommerce/domain/result/result.dart';

abstract class StockRepository {
  Future<Result<int>> getStockAvailable(String productId);
}
