import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/usecases/product/add_product_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/states/product_details_state.dart';
import 'package:clean_ecommerce/ui/common/widgets/ecommerce_scaffold.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_image.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final String productId;
  final BuildContext context;
  final ProductDetailsState state;
  final ShowProductDetailsUseCase showDetailsUseCase;
  final AddProductToCartUseCase addProductToCartUseCase;

  const ProductDetails({
    super.key,
    required this.context,
    required this.productId,
    required this.state,
    required this.showDetailsUseCase,
    required this.addProductToCartUseCase,
  });

  _fetchProductDetails() {
    showDetailsUseCase.execute(productId: productId, product: state.product);
  }

  _add({required bool continueShopping}) {
    addProductToCartUseCase.execute(
      state.product!,
      quantity: 1,
      continueShopping: continueShopping,
    );
  }

  _handleAddToCart() => _add(continueShopping: true);
  _handleToBuy() => _add(continueShopping: false);

  @override
  Widget build(BuildContext context) {
    var title = state.product?.name ?? 'Product Details';
    if (state.isLoading) {
      title = '';
    }
    final navigator = EcommerceNavigator(
      context,
      cartGoBackCallback: _fetchProductDetails,
    );

    return CleanScaffold(
      title: title,
      goCart: navigator.goCart,
      body: _buildBodyContent(),
      context: context,
    );
  }

  Widget _buildBodyContent() {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.product == null) {
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

    final product = state.product!;
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
        Text('Available in stock: ${state.stock}', style: textTheme.bodyLarge),
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
          onPressed: state.isDisabled ? null : _handleToBuy,
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
          onPressed: state.isDisabled ? null : _handleAddToCart,
          child: const Text('Add to bag'),
        ),
      ],
    );
  }
}
