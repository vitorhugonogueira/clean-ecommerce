import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/models/item.dart';
import 'package:clean_ecommerce/domain/states/cart_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/cart/decrease_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/increase_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/remove_item_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/show_cart_details_usecase.dart';
import 'package:clean_ecommerce/ui/cart/cart_details_screen_presenter.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/app_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/clean_scaffold/clean_scaffold.dart';
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
  bool _inProgress = false;
  bool _isUpdatingItem = false;

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
      onInProgressChanged: (inProgress) {
        if (!mounted) return;
        setState(() {
          _inProgress = inProgress;
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
    if (_isUpdatingItem || _state.cart == null || !mounted) {
      return;
    }
    setState(() => _isUpdatingItem = true);
    try {
      await _increaseItemUseCase.execute(
        productId: productId,
        cart: _state.cart!,
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdatingItem = false);
      }
    }
  }

  Future<void> _decreaseQuantity(String productId) async {
    if (_isUpdatingItem || _state.cart == null || !mounted) {
      return;
    }
    setState(() => _isUpdatingItem = true);
    try {
      // Prevent quantity from going below 1 with decrease,
      // or remove if it's the last one.
      // The use case itself handles removal if quantity becomes 0.
      await _decreaseItemUseCase.execute(
        productId: productId,
        cart: _state.cart!,
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdatingItem = false);
      }
    }
  }

  Future<void> _removeItem(String productId) async {
    if (_isUpdatingItem || _state.cart == null || !mounted) {
      return;
    }
    setState(() => _isUpdatingItem = true);
    try {
      await _removeItemUseCase.execute(
        productId: productId,
        cart: _state.cart!,
      );
    } finally {
      if (mounted) {
        // If the cart becomes empty, the presenter should update the state,
        // and _buildBodyContent will show the "empty cart" message.
        setState(() => _isUpdatingItem = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CleanScaffold(
      title: 'Bag',
      navigator: AppNavigator(context),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    if (_inProgress) {
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

    // If cart has items, display them in a ListView
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return _buildCartItemTile(item);
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
    );
  }

  Widget _buildCartItemTile(Item item) {
    final product = item.product;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: SizedBox(
        width: 60,
        height: 60,
        child:
            product.imageUrl.isNotEmpty
                ? Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (ctx, err, st) => const Icon(Icons.image_not_supported),
                )
                : const Icon(Icons.image_not_supported),
      ),
      title: Text(product.name, style: textTheme.titleMedium),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed:
                _isUpdatingItem ? null : () => _decreaseQuantity(product.id),
            tooltip: 'Decrease quantity',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${item.quantity}', style: textTheme.bodyLarge),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed:
                _isUpdatingItem ? null : () => _increaseQuantity(product.id),
            tooltip: 'Increase quantity',
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        tooltip: 'Remove item',
        onPressed: _isUpdatingItem ? null : () => _removeItem(product.id),
      ),
    );
  }
}
