import 'package:clean_ecommerce/domain/states/product_details_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/models/product_mock.dart';

void main() {
  group('ProductDetailsState', () {
    group('Default state', () {
      final state = ProductDetailsState();
      test('should build default properties rightly', () {
        expect(state.stock, 0);
        expect(state.stockIsAvailable, false);
        expect(state.product, null);
      });
    });
    group('Custom state', () {
      final state = ProductDetailsState(product: product1, stock: 3);
      test('should build custom properties rightly', () {
        expect(state.product?.name, 'Product 1');
        expect(state.stock, 3);
        expect(state.stockIsAvailable, true);
      });
    });
  });
}
