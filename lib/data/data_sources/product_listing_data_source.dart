import 'package:clean_ecommerce/data/data_models/product_list_data_model.dart';
import 'package:clean_ecommerce/domain/repositories/product_listing_repository.dart';
import 'package:clean_ecommerce/domain/result/result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductListingDataSource extends ProductListingRepository {
  final http.Client httpClient;
  final String baseUrl;

  ProductListingDataSource({
    http.Client? httpClient,
    this.baseUrl = 'http://localhost:3000',
  }) : httpClient = httpClient ?? http.Client();
  @override
  Future<Result<ProductListingResult>> getProducts(
    int page,
    int pageSize,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      final response = await httpClient.get(
        Uri.parse('$baseUrl/products?_page=$page&_per_page=$pageSize'),
      );

      if (response.statusCode != 200) {
        return Result.failure(
          'Failed to load products: ${response.statusCode}',
        );
      }

      final data = ProductListingDataModel.fromJson(jsonDecode(response.body));

      return Result.success(
        ProductListingResult(
          page: page,
          pageSize: pageSize,
          products: data.data,
          totalOfPages: data.pages,
        ),
      );
    } catch (e) {
      return Result.failure('Failed to load products.');
    }
  }
}
