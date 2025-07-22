import 'package:clean_ecommerce/domain/models/product.dart';

class ProductDetailsState {
  final Product? product;
  final int stock;
  final bool stockIsAvailable;

  ProductDetailsState({this.product, this.stock = 0})
    : stockIsAvailable = stock > 0;
}
