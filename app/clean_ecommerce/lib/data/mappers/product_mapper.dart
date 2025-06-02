import 'package:clean_ecommerce/domain/models/product.dart';

Product getProductFromMap(Map<String, dynamic> json) {
  return Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'].toDouble(),
    imageUrl: json['imageUrl'],
  );
}

Map<String, dynamic> getMapFromProduct(Product product) {
  return {
    'id': product.id,
    'name': product.name,
    'description': product.description,
    'price': product.price,
    'imageUrl': product.imageUrl,
  };
}
