import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/models/item.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/cart/increase_cart_item_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/datasources/cart_datasource_mock.dart';
import '../../../mocks/datasources/stock_datasource_mock.dart';
import '../../../mocks/generated_mocks.mocks.dart';
import '../../../mocks/models/product_mock.dart';

void main() {
  group('IncreaseCartItemUsecase', () {
    group('Trying to increase a non-existent item', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = IncreaseCartItemUsecase(
        cartRepository: CartDataSourceMock.saveFail('.', null),
        dialog: dialog,
        presenter: presenter,
        stockRepository: StockDataSourceMock.failure('.'),
      );
      usecase.execute(
        productId: '33',
        cart: Cart(
          items: [
            Item(product: product1, quantity: 2),
            Item(product: product2, quantity: 4),
          ],
        ),
      );
      test('Should present error message', () {
        verify(dialog.showError('Item not found.')).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should NOT present validation progress', () {
        verifyNever(presenter.setIsValidatingIncrease(any));
      });
    });
    group('Product OK, but stock repository fails', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = IncreaseCartItemUsecase(
        cartRepository: CartDataSourceMock.saveFail('.', null),
        dialog: dialog,
        presenter: presenter,
        stockRepository: StockDataSourceMock.failure(
          'Fail to get stock for that product.',
        ),
      );
      usecase.execute(
        productId: '2',
        cart: Cart(
          items: [
            Item(product: product1, quantity: 2),
            Item(product: product2, quantity: 4),
          ],
        ),
      );
      test('Should present stock error message', () {
        verify(
          dialog.showError('Fail to get stock for that product.'),
        ).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should present validation progress', () {
        verify(presenter.setIsValidatingIncrease(true)).called(1);
        verify(presenter.setIsValidatingIncrease(false)).called(1);
      });
    });
    group('Product OK, but stock not available', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = IncreaseCartItemUsecase(
        cartRepository: CartDataSourceMock.saveFail('.', null),
        dialog: dialog,
        presenter: presenter,
        stockRepository: StockDataSourceMock.success(4),
      );
      usecase.execute(
        productId: '2',
        cart: Cart(
          items: [
            Item(product: product1, quantity: 2),
            Item(product: product2, quantity: 4),
          ],
        ),
      );
      test('Should present stock error message', () {
        verify(
          dialog.showWarning(
            'Sorry, we currently do not have enough stock for quantity 5 of Product 2.',
          ),
        ).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should present validation progress', () {
        verify(presenter.setIsValidatingIncrease(true)).called(1);
        verify(presenter.setIsValidatingIncrease(false)).called(1);
      });
    });
    group('Product OK, stock OK, but error on saving', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = IncreaseCartItemUsecase(
        cartRepository: CartDataSourceMock.saveFail(
          'Some problem here on saving cart.',
          null,
        ),
        dialog: dialog,
        presenter: presenter,
        stockRepository: StockDataSourceMock.success(5),
      );
      usecase.execute(
        productId: '2',
        cart: Cart(
          items: [
            Item(product: product1, quantity: 2),
            Item(product: product2, quantity: 4),
          ],
        ),
      );
      test('Should NOT present stock error message', () {
        verifyNever(dialog.showWarning(any));
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.show(any));
      });
      test('Should present saving error message', () {
        verify(dialog.showError('Some problem here on saving cart.')).called(1);
      });
      test('Should present validation progress', () {
        verify(presenter.setIsValidatingIncrease(true)).called(1);
        verify(presenter.setIsValidatingIncrease(false)).called(1);
      });
    });
    group('Product OK, stock OK, saving OK', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = IncreaseCartItemUsecase(
        cartRepository: CartDataSourceMock.saveSuccess(null),
        dialog: dialog,
        presenter: presenter,
        stockRepository: StockDataSourceMock.success(5),
      );
      usecase.execute(
        productId: '2',
        cart: Cart(
          items: [
            Item(product: product1, quantity: 2),
            Item(product: product2, quantity: 4),
          ],
        ),
      );
      test('Should NOT present waring or error', () {
        verifyNever(dialog.showWarning(any));
        verifyNever(dialog.showError(any));
      });
      test('Should present updated cart state', () {
        verify(
          presenter.show(
            argThat(
              isA<CartDetailsState>()
                  .having((obj) => obj.cart!.items.length, 'itemsLenght', 2)
                  .having(
                    (obj) => obj.cart!.items[1].quantity,
                    'increasedQuantity',
                    5,
                  )
                  .having(
                    (obj) => obj.cart!.items[0].quantity,
                    'otherProductQuantity',
                    2,
                  ),
            ),
          ),
        );
      });
      test('Should present validation progress', () {
        verify(presenter.setIsValidatingIncrease(true)).called(1);
        verify(presenter.setIsValidatingIncrease(false)).called(1);
      });
    });
  });
}
