import 'package:clean_ecommerce/domain/models/product_pagination.dart';

class ProductListingState {
  final ProductPagination pagination;
  final bool isLoading;

  ProductListingState({
    this.pagination = const ProductPagination(),
    this.isLoading = false,
  });

  ProductListingState copyWith({
    ProductPagination? pagination,
    bool? isLoading,
  }) {
    return ProductListingState(
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
