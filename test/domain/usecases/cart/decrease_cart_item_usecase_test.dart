import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/domain/usecases/cart/decrease_cart_item_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/datasources/cart_datasource_mock.dart';
import '../../../mocks/generated_mocks.mocks.dart';
import '../../../mocks/models/product_mock.dart';

void main() {
  group('DecreaseCartItemUsecase', () {
    group('Trying to decrease a non-existent item', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = DecreaseCartItemUsecase(
        cartRepository: CartDataSourceMock.saveFail('.', null),
        dialog: dialog,
        presenter: presenter,
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
        verifyNever(presenter.showCart(any));
      });
      test('Should NOT present validation progress', () {
        verifyNever(presenter.setIsValidatingAction(any));
      });
    });
    group('Product OK, but cart repository fails on saving', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = DecreaseCartItemUsecase(
        cartRepository: CartDataSourceMock.saveFail(
          'Stranger fail had been done in saving cart.',
          null,
        ),
        dialog: dialog,
        presenter: presenter,
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
      test('Should present error message', () {
        verify(
          dialog.showError('Stranger fail had been done in saving cart.'),
        ).called(1);
      });
      test('Should NOT present cart', () {
        verifyNever(presenter.showCart(any));
      });
    });
    group('Product OK, cart repository OK', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = DecreaseCartItemUsecase(
        cartRepository: CartDataSourceMock.saveSuccess(null),
        dialog: dialog,
        presenter: presenter,
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
      test('Should NOT present error message', () {
        verifyNever(dialog.showError(any));
      });
      test('Should present cart with item decreased', () {
        verify(
          presenter.showCart(
            argThat(
              isA<Cart>()
                  .having((obj) => obj.items.length, 'itemsLenght', 2)
                  .having(
                    (obj) => obj.items[1].quantity,
                    'increasedQuantity',
                    3,
                  )
                  .having(
                    (obj) => obj.items[0].quantity,
                    'otherProductQuantity',
                    2,
                  ),
            ),
          ),
        ).called(1);
      });
    });
  });
}
