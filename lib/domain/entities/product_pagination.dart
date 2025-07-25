import 'package:clean_ecommerce/domain/entities/product.dart';

class ProductPagination {
  final List<Product> products;
  final int page;
  final int totalOfPages;
  final int pageSize;

  const ProductPagination({
    this.products = const [],
    this.page = 1,
    this.totalOfPages = 1,
    this.pageSize = 10,
  });
}
