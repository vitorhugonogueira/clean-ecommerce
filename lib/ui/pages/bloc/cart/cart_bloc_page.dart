import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/usecases/cart/decrease_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/increase_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/remove_item_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/show_cart_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';
import 'package:clean_ecommerce/ui/common/widgets/cart/cart_details.dart';
import 'package:clean_ecommerce/ui/pages/bloc/cart/cart_bloc_page_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBlocPage extends StatelessWidget {
  final Cart? cart;

  const CartBlocPage({super.key, this.cart});

  @override
  Widget build(BuildContext context) {
    final repository = CartDataSource();
    final dialog = EcommerceDialog(context);
    final presenter = CartBlocPagePresenter(cart);

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
    ShowCartDetailsUsecase(
      repository: CartDataSource(),
      presenter: presenter,
      cart: cart,
    ).execute();

    return BlocProvider(
      create: (_) => presenter,
      child: BlocBuilder<CartBlocPagePresenter, CartDetailsState>(
        builder: (context, state) {
          return CartDetails(
            increaseItem: increaseItem,
            decreaseItem: decreaseItem,
            removeItem: removeItem,
            state: presenter.state,
          );
        },
      ),
    );
  }
}
