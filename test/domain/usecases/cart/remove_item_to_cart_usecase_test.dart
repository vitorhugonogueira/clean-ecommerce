import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/domain/usecases/cart/remove_item_to_cart_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/datasources/cart_datasource_mock.dart';
import '../../../mocks/generated_mocks.mocks.dart';
import '../../../mocks/models/product_mock.dart';

void main() {
  group('RemoveItemToCartUseCase', () {
    group('Failure on saving', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = RemoveItemToCartUseCase(
        cartRepository: CartDataSourceMock.saveFail(
          'There was a bug on saving this removing.',
          null,
        ),
        dialog: dialog,
        presenter: presenter,
      );
      usecase.execute(
        productId: '1',
        cart: Cart(
          items: [
            Item(product: product1, quantity: 2),
            Item(product: product2, quantity: 4),
          ],
        ),
      );
      test('Should inform error message', () {
        verify(
          dialog.showError('There was a bug on saving this removing.'),
        ).called(1);
      });
      test('Should NOT present cart details state', () {
        verifyNever(presenter.showCart(any));
      });
    });
    group('Success on saving', () {
      final dialog = MockDialogMockito();
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = RemoveItemToCartUseCase(
        cartRepository: CartDataSourceMock.saveSuccess(null),
        dialog: dialog,
        presenter: presenter,
      );
      usecase.execute(
        productId: '1',
        cart: Cart(
          items: [
            Item(product: product1, quantity: 2),
            Item(product: product2, quantity: 4),
          ],
        ),
      );
      test('Should NOT inform error message', () {
        verifyNever(dialog.showError(any));
      });
      test('Should present updated cart rightly', () {
        verify(
          presenter.showCart(
            argThat(
              isA<Cart>()
                  .having((obj) => obj.items.length, 'itemsLenght', 1)
                  .having((obj) => obj.items[0].product.id, 'product', '2')
                  .having((obj) => obj.items[0].quantity, 'quantity', 4),
            ),
          ),
        );
      });
    });
  });
}
