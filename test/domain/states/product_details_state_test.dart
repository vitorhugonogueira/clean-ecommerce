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

    group('Copy with', () {
      final state = ProductDetailsState(product: product1, stock: 3);
      final updated = state.copyWith(
        product: product2,
        stock: 0,
        isLoading: true,
      );
      test('should copy properties rightly', () {
        expect(updated.product?.name, 'Product 2');
        expect(updated.stock, 0);
        expect(updated.stockIsAvailable, false);
        expect(updated.isLoading, true);
        expect(updated.isValidatingAction, false);
        expect(updated.isDisabled, true);
      });
    });
    group('Copy with - just isValidatingAction', () {
      final state = ProductDetailsState(product: product1, stock: 3);
      final updated = state.copyWith(isValidatingAction: true);
      test('should copy properties rightly', () {
        expect(updated.product?.name, 'Product 1');
        expect(updated.stock, 3);
        expect(updated.stockIsAvailable, true);
        expect(updated.isLoading, false);
        expect(updated.isValidatingAction, true);
        expect(updated.isDisabled, true);
      });
    });
  });
}
