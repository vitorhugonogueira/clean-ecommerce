import 'package:clean_ecommerce/domain/entities/product_pagination.dart';

import 'package:clean_ecommerce/domain/usecases/product/show_products_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/datasources/product_list_datasource_mock.dart';
import '../../../mocks/models/product_mock.dart';
import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  group('ShowProductsUseCase', () {
    group('FAILURE - error in getProducts method', () {
      final dialog = MockDialogMockito();
      final presenter = MockProductListingPresenterMockito();
      final usecase = ShowProductsUseCase(
        dialog: dialog,
        presenter: presenter,
        repository: ProductListingDataSourceMock.failure(
          'There was a very specific error in listing products process.',
        ),
      );
      usecase.execute();

      test('should show error', () {
        verify(
          dialog.showError(
            'There was a very specific error in listing products process.',
          ),
        ).called(1);
      });
      test('should not show any products', () {
        verifyNever(presenter.showProducts(any));
      });
    });
    group('SUCCESS - default page', () {
      final dialog = MockDialogMockito();
      final presenter = MockProductListingPresenterMockito();
      final data = ProductPagination(products: [product1, product2]);
      final usecase = ShowProductsUseCase(
        dialog: dialog,
        presenter: presenter,
        repository: ProductListingDataSourceMock.success(data),
      );
      usecase.execute();

      test('should not show error', () {
        verifyNever(dialog.showError(any));
      });
      test('should inform the product list', () {
        verify(presenter.showProducts(data)).called(1);
      });
    });
  });
}
