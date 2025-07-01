import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/product_details_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/models/product.dart';
import 'package:clean_ecommerce/domain/states/product_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/cart/add_item_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/app_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/clean_scaffold/clean_scaffold.dart';
import 'package:clean_ecommerce/ui/product/details/product_details_screen_presenter.dart';
import 'package:clean_ecommerce/ui/product/widgets/product_image.dart';
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

  @override
  Widget build(BuildContext context) {
    var title = _state.product?.name ?? 'Product Details';
    if (_isLoadingDetails) {
      title = '';
    }

    return CleanScaffold(
      title: title,
      navigator: AppNavigator(context),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _contentForLargeScreen(product, textTheme, colorScheme);
          } else {
            return _contentForSmallScreen(product, textTheme, colorScheme);
          }
        },
      ),
    );
  }

  Widget _contentForSmallScreen(
    Product product,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 500) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ProductImage(product: product),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ProductImage(product: product),
            );
          },
        ),

        const SizedBox(height: 24),

        _buildDetails(product, textTheme, colorScheme),
        const SizedBox(height: 36),

        _buildActions(textTheme, colorScheme),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _contentForLargeScreen(
    Product product,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 120.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ProductImage(product: product),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDetails(product, textTheme, colorScheme),
                const SizedBox(height: 36),
                _buildActions(textTheme, colorScheme),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(
    Product product,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(product.description, style: textTheme.bodyLarge),
        const SizedBox(height: 8),

        Text(
          product.priceLabel,
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 36),
        Text('Available in stock: ${_state.stock}', style: textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildActions(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
          child: const Text('Add to bag'),
        ),
      ],
    );
  }
}
