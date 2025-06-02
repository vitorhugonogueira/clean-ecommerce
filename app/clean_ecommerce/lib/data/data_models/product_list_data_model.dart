import 'package:clean_ecommerce/data/mappers/product_mapper.dart';
import 'package:clean_ecommerce/domain/models/product.dart';

class ProductListingDataModel {
  final int first;
  final int? prev;
  final int? next;
  final int last;
  final int pages;
  final int items;
  final List<Product> data;

  ProductListingDataModel({
    required this.first,
    required this.prev,
    required this.next,
    required this.last,
    required this.pages,
    required this.items,
    required this.data,
  });

  factory ProductListingDataModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'];
    final List<Product> products =
        dataList.map((item) => getProductFromMap(item)).toList();

    return ProductListingDataModel(
      first: json['first'],
      prev: json['prev'],
      next: json['next'],
      last: json['last'],
      pages: json['pages'],
      items: json['items'],
      data: products,
    );
  }
}
