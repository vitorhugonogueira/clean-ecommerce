import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/cart/decrease_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/increase_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/remove_item_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/show_cart_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/widgets/cart/cart_details.dart';
import 'package:clean_ecommerce/ui/pages/state/cart/cart_state_page_presenter.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:flutter/material.dart';

class CartStatePage extends StatefulWidget {
  final Cart? cart;

  const CartStatePage({super.key, this.cart});

  @override
  State<CartStatePage> createState() => _CartStatePageState();
}

class _CartStatePageState extends State<CartStatePage> {
  late ShowCartDetailsUsecase _showDetailsUseCase;
  late IncreaseCartItemUsecase _increaseItemUseCase;
  late DecreaseCartItemUsecase _decreaseItemUseCase;
  late RemoveItemToCartUseCase _removeItemUseCase;
  CartDetailsState _state = CartDetailsState();

  @override
  void initState() {
    super.initState();
    final presenter = CartStatePagePresenter(
      initialState: _state,
      onStateChanged: (newState) {
        if (!mounted) return;
        setState(() {
          _state = newState;
        });
      },
    );
    final repository = CartDataSource();
    final dialog = EcommerceDialog(context);

    _showDetailsUseCase = ShowCartDetailsUsecase(
      repository: CartDataSource(),
      presenter: presenter,
      cart: widget.cart,
    );
    _increaseItemUseCase = IncreaseCartItemUsecase(
      cartRepository: repository,
      dialog: dialog,
      presenter: presenter,
      stockRepository: StockDataSource(),
    );
    _decreaseItemUseCase = DecreaseCartItemUsecase(
      cartRepository: repository,
      dialog: dialog,
      presenter: presenter,
    );
    _removeItemUseCase = RemoveItemToCartUseCase(
      cartRepository: repository,
      dialog: dialog,
      presenter: presenter,
    );

    _showDetailsUseCase.execute();
  }

  @override
  Widget build(BuildContext context) {
    return CartDetails(
      increaseItem: _increaseItemUseCase,
      decreaseItem: _decreaseItemUseCase,
      removeItem: _removeItemUseCase,
      state: _state,
    );
  }
}
