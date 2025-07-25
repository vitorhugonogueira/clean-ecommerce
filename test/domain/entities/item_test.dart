import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/models/product_mock.dart';

void main() {
  group('Item - Produto1 - x5', () {
    final item = Item(product: product1, quantity: 5);
    group('totalPrice', () {
      test('should inform total based on price and quantity', () {
        expect(item.totalPrice, 294.45);
      });
    });
  });
}
