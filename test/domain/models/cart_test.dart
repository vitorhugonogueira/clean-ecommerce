import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/models/item.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../mocks/models/product_mock.dart';

void main() {
  group('Cart', () {
    group('0 Itens', () {
      final cart = Cart();
      test('should inform total 0', () {
        expect(cart.total, 0);
        expect(cart.totalLabel, '\$ 0.00');
      });
    });
    group('1 Item - qtd 2', () {
      final cart = Cart(items: [Item(product: product1, quantity: 2)]);
      test('should inform total 0', () {
        expect(cart.total, 117.78);
        expect(cart.totalLabel, '\$ 117.78');
      });
      group('by adding item from another product', () {
        final updated = cart.addItem(product2, 1);
        test('should include in list', () {
          expect(updated.items.length, 2);
        });
        test('should update total correctly', () {
          expect(updated.total, 136.68);
          expect(updated.totalLabel, '\$ 136.68');
        });
      });
      group('by adding item from the same product', () {
        final updated = cart.addItem(product1, 1);
        test(
          'should update item list correctly (mergin items from same product)',
          () {
            expect(updated.items.length, 1);
            expect(updated.items[0].quantity, 3);
            expect(updated.items[0].totalPrice, 176.67000000000002);
          },
        );
        test('should update total correctly', () {
          expect(updated.total, 176.67000000000002);
          expect(updated.totalLabel, '\$ 176.67');
        });
      });
    });

    group('2 Items', () {
      final cart = Cart(
        items: [
          Item(product: product1, quantity: 1),
          Item(product: product2, quantity: 2),
        ],
      );

      group('by removing the second', () {
        final updated = cart.removeItem('2');
        test('should update cart info rightly', () {
          expect(updated.items.length, 1);
          expect(updated.total, 58.89);
        });
      });
      group('by updating the second amount', () {
        final updated = cart.updateItemQuantity('2', 3);
        test('should update cart info rightly', () {
          expect(updated.items.length, 2);
          expect(updated.items[1].quantity, 3);
          expect(updated.total, 115.59);
        });
      });
      group('by updating the first amount to zero', () {
        final updated = cart.updateItemQuantity('1', 0);
        test('should remove first item', () {
          expect(updated.items.length, 1);
          expect(updated.items[0].quantity, 2);
          expect(updated.total, 37.80);
        });
      });
      group('on getItem - 2', () {
        final resp = cart.getItem('2');
        test('should return specific object for productId', () {
          expect(resp?.product.description, 'Product Mock 2');
          expect(resp?.quantity, 2);
        });
      });
      group('on getItem - 556', () {
        final resp = cart.getItem('556');
        test('should return null', () {
          expect(resp, null);
        });
      });
    });
  });
}
