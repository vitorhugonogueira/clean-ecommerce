import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/states/product_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/product/add_product_to_cart_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/datasources/cart_datasource_mock.dart';
import '../../../mocks/datasources/stock_datasource_mock.dart';
import '../../../mocks/generated_mocks.mocks.dart';
import '../../../mocks/models/product_mock.dart';

void main() {
  group('AddItemToCartUseCase', () {
    group('Trying to add a non-existed product', () {
      final dialog = MockDialogMockito();
      final navigator = MockNavigatorMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = AddProductToCartUseCase(
        cartRepository: CartDataSourceMock.saveFail('.', null),
        dialog: dialog,
        presenter: presenter,
        navigator: navigator,
        stockRepository: StockDataSourceMock.success(10),
      );
      usecase.execute(productState: ProductDetailsState(product: null));
      test('Should present error message', () {
        verify(dialog.showError('Product not found.')).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should NOT present validation progress', () {
        verifyNever(presenter.setIsValidatingAction(any));
      });
    });
    group('Trying to add quantity 0', () {
      final dialog = MockDialogMockito();
      final navigator = MockNavigatorMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = AddProductToCartUseCase(
        cartRepository: CartDataSourceMock.saveFail('.', null),
        dialog: dialog,
        presenter: presenter,
        navigator: navigator,
        stockRepository: StockDataSourceMock.success(10),
      );
      usecase.execute(
        productState: ProductDetailsState(product: product1),
        quantity: 0,
      );
      test('Should present error message', () {
        verify(
          dialog.showError('Quantity must be greater than zero.'),
        ).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should NOT present validation progress', () {
        verifyNever(presenter.setIsValidatingAction(any));
      });
    });
    group('Trying to add quantity -1', () {
      final dialog = MockDialogMockito();
      final navigator = MockNavigatorMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = AddProductToCartUseCase(
        cartRepository: CartDataSourceMock.saveFail('.', null),
        dialog: dialog,
        presenter: presenter,
        navigator: navigator,
        stockRepository: StockDataSourceMock.success(10),
      );
      usecase.execute(
        productState: ProductDetailsState(product: product1),
        quantity: -1,
      );
      test('Should present error message', () {
        verify(
          dialog.showError('Quantity must be greater than zero.'),
        ).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should NOT present validation progress', () {
        verifyNever(presenter.setIsValidatingAction(any));
      });
    });

    group('Product OK, with error in stock repository', () {
      final dialog = MockDialogMockito();
      final navigator = MockNavigatorMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = AddProductToCartUseCase(
        cartRepository: CartDataSourceMock.saveFail('.', null),
        dialog: dialog,
        presenter: presenter,
        navigator: navigator,
        stockRepository: StockDataSourceMock.failure('Stock exception 4567'),
      );
      usecase.execute(productState: ProductDetailsState(product: product1));
      test('Should present error message', () {
        verify(dialog.showError('Stock exception 4567')).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should NOT go to cart', () {
        verifyNever(navigator.goCart());
      });
    });
    group('Product OK, but cart repository fails on saving', () {
      final dialog = MockDialogMockito();
      final navigator = MockNavigatorMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = AddProductToCartUseCase(
        cartRepository: CartDataSourceMock.saveFail(
          'An error had been done in saving cart.',
          null,
        ),
        dialog: dialog,
        presenter: presenter,
        navigator: navigator,
        stockRepository: StockDataSourceMock.success(10),
      );
      usecase.execute(productState: ProductDetailsState(product: product1));
      test('Should present error message', () {
        verify(
          dialog.showError('An error had been done in saving cart.'),
        ).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should NOT go to cart', () {
        verifyNever(navigator.goCart());
      });
    });
    group('Product OK, but stock insuficient', () {
      final dialog = MockDialogMockito();
      final navigator = MockNavigatorMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = AddProductToCartUseCase(
        cartRepository: CartDataSourceMock.saveFail(
          'An error had been done in saving cart.',
          null,
        ),
        dialog: dialog,
        presenter: presenter,
        navigator: navigator,
        stockRepository: StockDataSourceMock.success(0),
      );
      usecase.execute(productState: ProductDetailsState(product: product1));
      test('Should present error message', () {
        verify(dialog.showError('Insufficient stock available.')).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should NOT go to cart', () {
        verifyNever(navigator.goCart());
      });
    });
    group('Product OK, cart repository OK', () {
      final dialog = MockDialogMockito();
      final navigator = MockNavigatorMockito();
      final presenter = MockProductDetailsPresenterMockito();
      final usecase = AddProductToCartUseCase(
        cartRepository: CartDataSourceMock.saveSuccess(null),
        dialog: dialog,
        presenter: presenter,
        navigator: navigator,
        stockRepository: StockDataSourceMock.success(10),
      );
      usecase.execute(productState: ProductDetailsState(product: product1));
      test('Should present success notification', () {
        verify(
          dialog.notifySuccess('Item added to cart successfully'),
        ).called(1);
      });
      test('Should update stock available', () {
        verify(
          presenter.show(
            argThat(
              isA<ProductDetailsState>()
                  .having((obj) => obj.stock, 'stock', 9)
                  .having(
                    (obj) => obj.isValidatingAction,
                    'isValidatingAction',
                    false,
                  ),
            ),
          ),
        ).called(1);
      });
      test('Should present validation progress', () {
        verify(presenter.setIsValidatingAction(true)).called(1);
      });
      test('Should not go to cart', () {
        verifyNever(navigator.goCart());
      });
    });
    group(
      'Product OK, cart repository OK, do not continue shopping (go to Cart)',
      () {
        final dialog = MockDialogMockito();
        final navigator = MockNavigatorMockito();
        final presenter = MockProductDetailsPresenterMockito();
        final usecase = AddProductToCartUseCase(
          cartRepository: CartDataSourceMock.saveSuccess(null),
          dialog: dialog,
          presenter: presenter,
          navigator: navigator,
          stockRepository: StockDataSourceMock.success(10),
        );
        usecase.execute(
          productState: ProductDetailsState(product: product1),
          continueShopping: false,
        );
        test('Should not present success notification', () {
          verifyNever(dialog.notifySuccess(any));
        });
        test('Should go to cart sending updated cart', () {
          verify(
            navigator.goCart(
              cart: argThat(
                named: 'cart',
                isA<Cart>().having((o) => o.items.length, 'itemsLenght', 1),
              ),
            ),
          ).called(1);
        });
      },
    );
  });
}
