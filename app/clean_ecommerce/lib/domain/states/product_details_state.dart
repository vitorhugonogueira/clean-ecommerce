import 'package:clean_ecommerce/domain/models/product.dart';

class ProductDetailsState {
  final Product? product;
  final int stock;

  ProductDetailsState({this.product, this.stock = 0});

  bool get stockAvailable => stock > 0;
}
