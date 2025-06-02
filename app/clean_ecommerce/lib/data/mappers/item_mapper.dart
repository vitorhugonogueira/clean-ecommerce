import 'package:clean_ecommerce/data/mappers/product_mapper.dart';
import 'package:clean_ecommerce/domain/models/item.dart';

Item getItemFromMap(Map<String, dynamic> map) {
  return Item(
    product: getProductFromMap(map['product']),
    quantity: map['quantity'],
  );
}

Map<String, dynamic> getMapFromItem(Item item) {
  return {
    'product': getMapFromProduct(item.product),
    'quantity': item.quantity,
  };
}
