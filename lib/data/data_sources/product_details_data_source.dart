import 'package:clean_ecommerce/data/data_config.dart';
import 'package:clean_ecommerce/data/mappers/product_mapper.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/repositories/product_details_repository.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailsDataSource extends ProductDetailsRepository {
  final http.Client httpClient;
  final String baseUrl;

  ProductDetailsDataSource({http.Client? httpClient, String? baseUrl})
    : httpClient = httpClient ?? http.Client(),
      baseUrl = baseUrl ?? DataConfig.apiUrl;
  @override
  Future<Result<Product>> getProductDetails(String id) async {
    try {
      final response = await httpClient.get(Uri.parse('$baseUrl/products/$id'));

      if (response.statusCode != 200) {
        return Result.failure(
          'Failed to load product details: ${response.statusCode}',
        );
      }

      final product = getProductFromMap(jsonDecode(response.body));

      return Result.success(product);
    } catch (e) {
      return Result.failure('Failed to load product details.');
    }
  }
}
