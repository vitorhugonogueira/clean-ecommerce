import 'package:clean_ecommerce/domain/entities/result.dart';

abstract class StockRepository {
  Future<Result<int>> getStockAvailable(String productId);
}
