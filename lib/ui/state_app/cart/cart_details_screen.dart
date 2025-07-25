import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/cart/decrease_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/increase_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/remove_item_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/show_cart_details_usecase.dart';
import 'package:clean_ecommerce/ui/state_app/cart/cart_details_screen_presenter.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/widgets/ecommerce_scaffold.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_image.dart';
import 'package:flutter/material.dart';

class CartDetailsScreen extends StatefulWidget {
  final Cart? cart;

  const CartDetailsScreen({super.key, this.cart});

  @override
  State<CartDetailsScreen> createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {
  late ShowCartDetailsUsecase _showDetailsUseCase;
  late IncreaseCartItemUsecase _increaseItemUseCase;
  late DecreaseCartItemUsecase _decreaseItemUseCase;
  late RemoveItemToCartUseCase _removeItemUseCase;
  CartDetailsState _state = CartDetailsState();

  @override
  void initState() {
    super.initState();
    final presenter = CartDetailsScreenPresenter(
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

  Future<void> _increaseQuantity(String productId) async {
    if (_state.isValidatingAction || _state.cart == null || !mounted) {
      return;
    }
    await _increaseItemUseCase.execute(
      productId: productId,
      cart: _state.cart!,
    );
  }

  Future<void> _decreaseQuantity(String productId) async {
    if (_state.isValidatingAction || _state.cart == null || !mounted) {
      return;
    }
    await _decreaseItemUseCase.execute(
      productId: productId,
      cart: _state.cart!,
    );
  }

  Future<void> _removeItem(String productId) async {
    if (_state.isValidatingAction || _state.cart == null || !mounted) {
      return;
    }
    await _removeItemUseCase.execute(productId: productId, cart: _state.cart!);
  }

  @override
  Widget build(BuildContext context) {
    return CleanScaffold(
      title: 'Bag',
      body: _buildBodyContent(context),
      context: context,
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    if (_state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final cart = _state.cart;

    if (cart == null || cart.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Your bag is empty.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), // Go back
              child: const Text('Continue shopping'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total: ${cart.totalLabel}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return _buildCartItemCard(item);
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItemCard(Item item) {
    final product = item.product;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 60,
              height: 60,
              child: ProductImage(product: product),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed:
                            _state.isValidatingAction
                                ? null
                                : () => _decreaseQuantity(product.id),
                        tooltip: 'Decrease quantity',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${item.quantity}',
                          style: textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed:
                            _state.isValidatingAction
                                ? null
                                : () => _increaseQuantity(product.id),
                        tooltip: 'Increase quantity',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.secondary),
              tooltip: 'Remove item',
              onPressed:
                  _state.isValidatingAction
                      ? null
                      : () => _removeItem(product.id),
            ),
          ),
        ],
      ),
    );
  }
}
