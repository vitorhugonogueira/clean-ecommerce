import '../models/product.dart';

class ProductListingState {
  final List<Product> products;
  final int page;
  final int totalOfPages;
  final int pageSize;

  const ProductListingState({
    this.products = const [],
    this.page = 1,
    this.totalOfPages = 1,
    this.pageSize = 10,
  });
}
