import 'package:flutter_test/flutter_test.dart';
import '../../mocks/product_mock.dart';

void main() {
  group('Item - Produto1', () {
    final product = product1;
    group('totalPrice', () {
      test('should inform total based on price and quantity', () {
        expect(product.priceLabel, '\$ 58.89');
      });
    });
  });
}
