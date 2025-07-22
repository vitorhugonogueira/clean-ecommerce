import 'package:clean_ecommerce/domain/states/product_listing_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/product_mock.dart';

void main() {
  group('ProductListingState', () {
    group('Default state', () {
      final state = ProductListingState();
      test('should build default properties rightly', () {
        expect(state.page, 1);
        expect(state.totalOfPages, 1);
        expect(state.pageSize, 10);
        expect(state.products, []);
      });
    });
    group('Custom state', () {
      final state = ProductListingState(
        page: 5,
        pageSize: 23,
        products: [product1, product2],
        totalOfPages: 5,
      );
      test('should build custom properties rightly', () {
        expect(state.page, 5);
        expect(state.totalOfPages, 5);
        expect(state.pageSize, 23);
        expect(state.products.length, 2);
        expect(state.products[1].name, 'Product 2');
      });
    });
  });
}
