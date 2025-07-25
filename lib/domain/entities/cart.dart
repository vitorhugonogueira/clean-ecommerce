import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:collection/collection.dart';

class Cart {
  final List<Item> items;

  Cart({this.items = const []});

  double get total => items.fold(0, (sum, item) => sum + item.totalPrice);

  Cart addItem(Product product, int quantity) {
    final updatedItems = List<Item>.from(items);
    final existingIndex = updatedItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = Item(
        product: existingItem.product,
        quantity: existingItem.quantity + quantity,
      );
    } else {
      updatedItems.add(Item(product: product, quantity: quantity));
    }

    final c = Cart(items: updatedItems);
    return c;
  }

  Cart removeItem(String productId) {
    return Cart(
      items: items.where((item) => item.product.id != productId).toList(),
    );
  }

  Cart updateItemQuantity(String productId, int quantity) {
    final updatedItems = List<Item>.from(items);
    final itemIndex = updatedItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (itemIndex != -1) {
      if (quantity > 0) {
        final existingItem = updatedItems[itemIndex];
        updatedItems[itemIndex] = Item(
          product: existingItem.product,
          quantity: quantity,
        );
      } else {
        updatedItems.removeAt(itemIndex);
      }
    }

    return Cart(items: updatedItems);
  }

  Item? getItem(String productId) {
    return items.firstWhereOrNull((item) => item.product.id == productId);
  }

  String get totalLabel => '\$ ${total.toStringAsFixed(2)}';
}
