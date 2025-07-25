import 'package:clean_ecommerce/domain/entities/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/models/product_mock.dart';

void main() {
  group('Result', () {
    group('Normal success', () {
      final success = Result.success(product1);
      test('should inform result state correctly', () {
        expect(success.content?.description, 'Product Mock 1');
        expect(success.errorMessage, null);
        expect(success.isFailure, false);
        expect(success.isSuccess, true);
      });
    });
    group('Normal failure', () {
      final success = Result.failure('Sorry, it not works.');
      test('should inform result state correctly', () {
        expect(success.content, null);
        expect(success.errorMessage, 'Sorry, it not works.');
        expect(success.isFailure, true);
        expect(success.isSuccess, false);
      });
    });
  });
}
