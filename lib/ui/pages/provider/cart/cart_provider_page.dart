import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/domain/usecases/cart/decrease_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/increase_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/remove_item_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/show_cart_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';
import 'package:clean_ecommerce/ui/common/widgets/cart/cart_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider_page_presenter.dart';

class CartProviderPage extends StatelessWidget {
  final Cart? cart;

  const CartProviderPage({super.key, this.cart});

  @override
  Widget build(BuildContext context) {
    final repository = CartDataSource();
    final dialog = EcommerceDialog(context);
    final presenter = CartProviderPagePresenter(
      initialState: CartDetailsState(cart: cart ?? Cart()),
    );

    final showDetails = ShowCartDetailsUsecase(
      repository: CartDataSource(),
      presenter: presenter,
      cart: cart,
    );
    final increaseItem = IncreaseCartItemUsecase(
      cartRepository: repository,
      dialog: dialog,
      presenter: presenter,
      stockRepository: StockDataSource(),
    );
    final decreaseItem = DecreaseCartItemUsecase(
      cartRepository: repository,
      dialog: dialog,
      presenter: presenter,
    );
    final removeItem = RemoveItemToCartUseCase(
      cartRepository: repository,
      dialog: dialog,
      presenter: presenter,
    );
    showDetails.execute();

    return ChangeNotifierProvider<CartProviderPagePresenter>(
      create: (_) => presenter,
      child: Consumer<CartProviderPagePresenter>(
        builder: (context, presenter, child) {
          Future<void> increaseQuantity(Item item) async {
            if (presenter.state.isValidatingAction) {
              return;
            }
            await increaseItem.execute(
              productId: item.product.id,
              cart: presenter.state.cart,
            );
          }

          Future<void> decreaseQuantity(Item item) async {
            if (presenter.state.isValidatingAction) {
              return;
            }
            await decreaseItem.execute(
              productId: item.product.id,
              cart: presenter.state.cart,
            );
          }

          Future<void> remove(Item item) async {
            if (presenter.state.isValidatingAction) {
              return;
            }
            await removeItem.execute(
              productId: item.product.id,
              cart: presenter.state.cart,
            );
          }

          return CartDetails(
            increase: increaseQuantity,
            decrease: decreaseQuantity,
            remove: remove,
            state: presenter.state,
          );
        },
      ),
    );
  }
}
