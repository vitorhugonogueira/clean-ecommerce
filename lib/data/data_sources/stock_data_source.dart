import 'package:clean_ecommerce/data/data_config.dart';
import 'package:clean_ecommerce/data/data_models/stock_data_model.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class StockDataSource implements StockRepository {
  final http.Client httpClient;
  final String baseUrl;

  StockDataSource({http.Client? httpClient, String? baseUrl})
    : httpClient = httpClient ?? http.Client(),
      baseUrl = baseUrl ?? DataConfig.apiUrl;

  @override
  Future<Result<int>> getStockAvailable(String productId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/stock/$productId'),
      );

      if (response.statusCode != 200) {
        return Result.failure('Failed to load stock: ${response.statusCode}');
      }

      final stock = StockDataModel.fromJson(jsonDecode(response.body));

      return Result.success(stock.stock);
    } catch (e) {
      return Result.failure('Failed to load stock.');
    }
  }
}
