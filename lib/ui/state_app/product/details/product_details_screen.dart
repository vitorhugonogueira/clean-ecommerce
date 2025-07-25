import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/product_details_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/ui/common/states/product_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/product/add_product_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/state_app/state_app_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/ecommerce_scaffold.dart';
import 'package:clean_ecommerce/ui/state_app/product/details/product_details_screen_presenter.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_image.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ShowProductDetailsUseCase _showDetailsUseCase;
  late AddProductToCartUseCase _addItemToCartUseCase;
  late StateAppNavigator _navigator;
  late ProductDetailsState _state;

  @override
  void initState() {
    super.initState();

    final dataSource = ProductDetailsDataSource();
    final cartDataSource = CartDataSource();
    final stockDataSource = StockDataSource();
    final dialog = EcommerceDialog(context);
    _navigator = StateAppNavigator(
      context,
      cartGoBackCallback: _fetchProductDetails,
    );
    final presenter = ProductDetailsScreenPresenter(
      onStateChanged: (newState) {
        if (!mounted) return;
        setState(() {
          _state = newState;
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
    _addItemToCartUseCase = AddProductToCartUseCase(
      cartRepository: cartDataSource,
      dialog: dialog,
      navigator: _navigator,
      presenter: presenter,
      stockRepository: stockDataSource,
    );

    _fetchProductDetails();
  }

  _fetchProductDetails() {
    _showDetailsUseCase.execute(
      productId: widget.productId,
      product: _state.product,
    );
  }

  _add({required bool continueShopping}) {
    _addItemToCartUseCase.execute(
      _state.product!,
      quantity: 1,
      continueShopping: continueShopping,
    );
  }

  _handleAddToCart() => _add(continueShopping: true);
  _handleToBuy() => _add(continueShopping: false);

  @override
  Widget build(BuildContext context) {
    var title = _state.product?.name ?? 'Product Details';
    if (_state.isLoading) {
      title = '';
    }

    return CleanScaffold(
      title: title,
      goCart: _navigator.goCart,
      body: _buildBodyContent(),
      context: context,
    );
  }

  Widget _buildBodyContent() {
    if (_state.isLoading) {
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
        const SizedBox(height: 48),
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
          onPressed: _state.isDisabled ? null : _handleToBuy,
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
          onPressed: _state.isDisabled ? null : _handleAddToCart,
          child: const Text('Add to bag'),
        ),
      ],
    );
  }
}
