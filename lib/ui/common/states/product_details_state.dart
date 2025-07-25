import 'package:clean_ecommerce/domain/entities/product.dart';

class ProductDetailsState {
  final Product? product;
  final int stock;
  final bool stockIsAvailable;
  final bool isLoading;
  final bool isValidatingAction;
  final bool isDisabled;

  ProductDetailsState({
    this.isLoading = false,
    this.isValidatingAction = false,
    this.product,
    this.stock = 0,
  }) : stockIsAvailable = stock > 0,
       isDisabled = isValidatingAction || stock <= 0;

  ProductDetailsState copyWith({
    Product? product,
    int? stock,
    bool? stockIsAvailable,
    bool? isLoading,
    bool? isValidatingAction,
  }) {
    return ProductDetailsState(
      product: product ?? this.product,
      stock: stock ?? this.stock,
      isLoading: isLoading ?? this.isLoading,
      isValidatingAction: isValidatingAction ?? this.isValidatingAction,
    );
  }
}
