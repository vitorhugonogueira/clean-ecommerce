import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/states/product_listing_state.dart';
import 'package:clean_ecommerce/ui/common/widgets/ecommerce_scaffold.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_card.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_listing_reload_button.dart';
import 'package:flutter/material.dart';

class ProductListing extends StatelessWidget {
  final ProductListingState state;
  final Function() fetchProducts;
  final EcommerceNavigator navigator;

  const ProductListing({
    super.key,
    required this.state,
    required this.fetchProducts,
    required this.navigator,
  });

  @override
  Widget build(BuildContext context) {
    return CleanScaffold(
      context: context,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (state.pagination.products.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 120.0),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250.0,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: state.pagination.products.length,
                    itemBuilder: (context, index) {
                      final product = state.pagination.products[index];
                      return ProductCard(
                        product: product,
                        onTap: navigator.goDetails,
                      );
                    },
                  ),
                ),
              ),
            if (state.pagination.products.isEmpty && !state.isLoading)
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No products found.'),
                      const SizedBox(height: 16),
                      ProductListingReloadButton(
                        onPressed: fetchProducts,
                        inProgress: state.isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            if (state.isLoading && state.pagination.products.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
