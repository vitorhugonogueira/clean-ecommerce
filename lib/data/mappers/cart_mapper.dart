import 'package:clean_ecommerce/data/mappers/item_mapper.dart';
import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/models/item.dart';

Cart getCartFromMap(Map<String, dynamic> map) {
  final List<dynamic>? rawItemsList = map['items'] as List<dynamic>?;

  if (rawItemsList == null) {
    return Cart(items: const []);
  }

  final List<Item> items =
      rawItemsList
          .map((itemMap) => getItemFromMap(itemMap as Map<String, dynamic>))
          .toList();

  return Cart(items: items);
}

Map<String, dynamic> getMapFromCart(Cart cart) {
  return {'items': cart.items.map((item) => getMapFromItem(item)).toList()};
}
