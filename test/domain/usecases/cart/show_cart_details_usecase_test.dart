import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/models/item.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/cart/show_cart_details_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/generated_mocks.mocks.dart';
import '../../../mocks/datasources/cart_datasource_mock.dart';
import '../../../mocks/models/product_mock.dart';

void main() {
  group('ShowCartDetailsUseCase', () {
    group('With a pre informed cart', () {
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = ShowCartDetailsUsecase(
        presenter: presenter,
        repository: CartDataSourceMock.saveFail(
          'Fail to get cart right now.',
          null,
        ),
        cart: Cart(items: [Item(product: product2, quantity: 11)]),
      );
      usecase.execute();
      test('Should present that cart', () {
        verify(
          presenter.show(
            argThat(
              isA<CartDetailsState>()
                  .having(
                    (obj) => obj.cart!.items[0].product.id,
                    'product',
                    '2',
                  )
                  .having((obj) => obj.cart!.items[0].quantity, 'quantity', 11),
            ),
          ),
        );
      });
      test('Should not inform progress', () {
        verifyNever(presenter.setIsLoading(any));
      });
    });

    group('Without a pre informed cart - custom cart in repository', () {
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = ShowCartDetailsUsecase(
        presenter: presenter,
        repository: CartDataSourceMock.saveFail(
          'Fail to get cart right now.',
          Cart(items: [Item(product: product2, quantity: 7)]),
        ),
        cart: null,
      );
      usecase.execute();
      test('Should present the cart provided by repository', () {
        verify(
          presenter.show(
            argThat(
              isA<CartDetailsState>()
                  .having(
                    (obj) => obj.cart!.items[0].product.id,
                    'product',
                    '2',
                  )
                  .having((obj) => obj.cart!.items[0].quantity, 'quantity', 7),
            ),
          ),
        );
      });
      test('Should inform progress', () {
        verify(presenter.setIsLoading(true)).called(1);
        verify(presenter.setIsLoading(false)).called(1);
      });
    });
    group('Without a pre informed cart - no cart in repository', () {
      final presenter = MockCartDetailsPresenterMockito();
      final usecase = ShowCartDetailsUsecase(
        presenter: presenter,
        repository: CartDataSourceMock.saveFail(
          'Fail to get cart right now.',
          null,
        ),
        cart: null,
      );
      usecase.execute();
      test('Should present a new clean cart', () {
        verify(
          presenter.show(
            argThat(
              isA<CartDetailsState>().having(
                (obj) => obj.cart!.items.length,
                'cartLenght',
                0,
              ),
            ),
          ),
        );
      });
      test('Should inform progress', () {
        verify(presenter.setIsLoading(true)).called(1);
        verify(presenter.setIsLoading(false)).called(1);
      });
    });
  });
}
