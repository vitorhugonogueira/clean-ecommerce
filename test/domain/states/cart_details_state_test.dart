import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/models/item.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/models/product_mock.dart';

void main() {
  group('CartDetailsState', () {
    group('Default state', () {
      final state = CartDetailsState();
      test('should build default properties rightly', () {
        expect(state.cart, null);
      });
    });
    group('Custom state', () {
      final state = CartDetailsState(
        cart: Cart(items: [Item(product: product1, quantity: 3)]),
      );
      test('should build custom properties rightly', () {
        expect(state.cart, isNot(null));
        expect(state.cart!.items.length, 1);
        expect(state.cart!.items[0].quantity, 3);
        expect(state.cart!.totalLabel, '\$ 176.67');
      });
    });
  });
}
