import 'package:clean_ecommerce/domain/entities/product.dart';

class Item {
  final Product product;
  final int quantity;

  Item({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;
}
