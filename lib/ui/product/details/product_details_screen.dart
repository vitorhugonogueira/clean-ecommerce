import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/product_details_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/states/product_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/cart/add_item_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/app_navigator.dart';
import 'package:clean_ecommerce/ui/product/details/product_details_screen_presenter.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ShowProductDetailsUseCase _showDetailsUseCase;
  late AddItemToCartUseCase _addItemToCartUseCase;
  late AppNavigator _navigator;

  ProductDetailsState _state = ProductDetailsState();
  bool _isLoadingDetails = false;
  bool _disabledForActions = false;

  @override
  void initState() {
    super.initState();

    final dataSource = ProductDetailsDataSource();
    final cartDataSource = CartDataSource();
    final stockDataSource = StockDataSource();
    final dialog = EcommerceDialog(context);
    _navigator = AppNavigator(context);

    final presenter = ProductDetailsScreenPresenter(
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
          _isLoadingDetails = inProgress;
        });
      },
    );

    _showDetailsUseCase = ShowProductDetailsUseCase(
      repository: dataSource,
      presenter: presenter,
      dialog: dialog,
      cartRepository: cartDataSource,
      stockRepository: stockDataSource,
    );

    _addItemToCartUseCase = AddItemToCartUseCase(
      cartRepository: cartDataSource,
      dialog: dialog,
      navigator: _navigator,
      presenter: presenter,
      stockRepository: stockDataSource,
    );

    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    await _showDetailsUseCase.execute(productId: widget.productId);
  }

  Future<void> _add({required bool continueShopping}) async {
    if (_disabledForActions) {
      return;
    }

    setState(() => _disabledForActions = true);
    await _addItemToCartUseCase.execute(
      productState: _state,
      quantity: 1,
      continueShopping: continueShopping,
    );
    setState(() => _disabledForActions = false);
  }

  Future<void> _handleAddToCart() async {
    _add(continueShopping: true);
  }

  Future<void> _handleToBuy() async {
    _add(continueShopping: false);
  }

  bool isDisabledFroActions() {
    return _disabledForActions || _state.stock <= 0;
  }

  void _goCart() {
    _navigator.goCart();
  }

  @override
  Widget build(BuildContext context) {
    var title = _state.product?.name ?? 'Product Details';
    if (_isLoadingDetails) {
      title = 'Loading...';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(onPressed: _goCart, icon: const Icon(Icons.shopping_cart)),
          const SizedBox(width: 30),
        ],
      ),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoadingDetails) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_state.product == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load product details.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: _fetchProductDetails,
            ),
          ],
        ),
      );
    }

    final product = _state.product!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (product.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                product.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : const Center(
                        heightFactor: 2,
                        child: CircularProgressIndicator(),
                      );
                },
                errorBuilder: (context, error, stack) {
                  return Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 24),

          Text(product.name, style: textTheme.headlineMedium),
          const SizedBox(height: 8),

          Text('Stock:: ${_state.stock}', style: textTheme.headlineMedium),
          const SizedBox(height: 8),

          Text(
            product.priceLabel,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 24),

          Text('Description', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(product.description, style: textTheme.bodyLarge),
          const SizedBox(height: 32),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: textTheme.titleMedium,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            onPressed: isDisabledFroActions() ? null : _handleToBuy,
            child: const Text('Buy'),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: textTheme.titleMedium,
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
            ),
            onPressed: isDisabledFroActions() ? null : _handleAddToCart,
            child: const Text('Add to cart'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
