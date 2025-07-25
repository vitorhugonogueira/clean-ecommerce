import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks/datasources/cart_datasource_mock.dart';
import '../../../mocks/datasources/product_details_datasource_mock.dart';
import '../../../mocks/datasources/stock_datasource_mock.dart';
import '../../../mocks/generated_mocks.mocks.dart';
import '../../../mocks/models/product_mock.dart';

void main() {
  group('ShowProductDetailsUseCase', () {
    group('Error in product repository', () {
      final dialog = MockDialogMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = ShowProductDetailsUseCase(
        repository: ProductDetailsDataSourceMock.failure(
          'There was a fail in product data source.',
        ),
        stockRepository: StockDataSourceMock.failure(
          'Failure on getting stock information.',
        ),
        cartRepository: CartDataSourceMock.saveFail(
          'Error on saving cart.',
          null,
        ),
        presenter: presenter,
        dialog: dialog,
      );
      usecase.execute(productId: '321');
      test('should show error', () {
        verify(
          dialog.showError('There was a fail in product data source.'),
        ).called(1);
      });
      test('should not show product details', () {
        verifyNever(presenter.showProduct(any));
      });
      test('should inform progress', () {
        verify(presenter.setIsLoading(true)).called(1);
        verify(presenter.setIsLoading(false)).called(1);
      });
      test('should not inform validation progress', () {
        verifyNever(presenter.setIsValidatingAction(any));
      });
    });

    group('Error in stock repository', () {
      final dialog = MockDialogMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = ShowProductDetailsUseCase(
        repository: ProductDetailsDataSourceMock.success(product1),
        stockRepository: StockDataSourceMock.failure(
          'Failure on getting stock information.',
        ),
        cartRepository: CartDataSourceMock.saveFail(
          'Error on saving cart.',
          null,
        ),
        presenter: presenter,
        dialog: dialog,
      );
      usecase.execute(productId: '321');
      test('should show stock error', () {
        verify(
          dialog.showError('Failure on getting stock information.'),
        ).called(1);
      });
    });
    group('Success - [current cart DO NOT contains that product]', () {
      final dialog = MockDialogMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = ShowProductDetailsUseCase(
        repository: ProductDetailsDataSourceMock.success(product1),
        stockRepository: StockDataSourceMock.success(5),
        cartRepository: CartDataSourceMock.saveFail(
          'Error on saving cart.',
          null,
        ),
        presenter: presenter,
        dialog: dialog,
      );
      usecase.execute(productId: '1');
      test('should not show any error', () {
        verifyNever(dialog.showError(any));
      });
      test('should present product details', () {
        verify(
          presenter.showProduct(
            argThat(isA<Product>().having((obj) => obj.id, 'id', '1')),
          ),
        ).called(1);
      });
      test('should present stock rightly', () {
        verify(presenter.showStock(5)).called(1);
      });
      test('should finish validation process', () {
        verify(presenter.setIsValidatingAction(false)).called(1);
      });
      test('should inform progress', () {
        verify(presenter.setIsLoading(true)).called(1);
      });
    });
    group('Success - [current cart contains that product]', () {
      final dialog = MockDialogMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = ShowProductDetailsUseCase(
        repository: ProductDetailsDataSourceMock.success(product1),
        stockRepository: StockDataSourceMock.success(5),
        cartRepository: CartDataSourceMock.saveFail(
          'Error on saving cart.',
          Cart(items: [Item(product: product1, quantity: 3)]),
        ),
        presenter: presenter,
        dialog: dialog,
      );
      usecase.execute(productId: '1');
      test('should not show any error', () {
        verifyNever(dialog.showError(any));
      });
      test('should present product details', () {
        verify(
          presenter.showProduct(
            argThat(isA<Product>().having((obj) => obj.id, 'id', '1')),
          ),
        ).called(1);
      });
      test(
        'should present stock rightly (UPDATED BY CURRENT CART QUANTITY)',
        () {
          verify(presenter.showStock(2)).called(1);
        },
      );
      test('should finish validation process', () {
        verify(presenter.setIsValidatingAction(false)).called(1);
      });
      test('should inform progress', () {
        verify(presenter.setIsLoading(true)).called(1);
      });
    });
  });
}
