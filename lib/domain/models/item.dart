import 'package:clean_ecommerce/domain/models/product.dart';

class Item {
  final Product product;
  final int quantity;

  Item({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;

  get priceLabel => '\$${totalPrice.toStringAsFixed(2)}';
}
