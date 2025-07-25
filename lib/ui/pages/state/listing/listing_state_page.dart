import 'package:clean_ecommerce/data/data_sources/product_listing_data_source.dart';
import 'package:clean_ecommerce/ui/common/states/product_listing_state.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_products_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/ecommerce_scaffold.dart';
import 'package:clean_ecommerce/ui/pages/state/listing/listing_state_page_presenter.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_card.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_listing_reload_button.dart';
import 'package:flutter/material.dart';

class ListingStatePage extends StatefulWidget {
  const ListingStatePage({super.key});

  @override
  State<ListingStatePage> createState() => _ListingStatePageState();
}

class _ListingStatePageState extends State<ListingStatePage> {
  late ShowProductsUseCase _useCase;
  late EcommerceNavigator _navigator;
  ProductListingState _state = ProductListingState();

  @override
  void initState() {
    super.initState();
    _navigator = EcommerceNavigator(context);
    final repository = ProductListingDataSource();
    final dialog = EcommerceDialog(context);
    final presenter = ProductListingScreenPresenter(
      onStateChanged: (state) {
        setState(() {
          _state = state;
        });
      },
    );

    _useCase = ShowProductsUseCase(
      repository: repository,
      presenter: presenter,
      dialog: dialog,
    );
    _useCase.execute();
  }

  void _fetchProducts() async {
    if (_state.isLoading) {
      return;
    }
    _useCase.execute();
  }

  @override
  Widget build(BuildContext context) {
    return CleanScaffold(
      context: context,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_state.pagination.products.isNotEmpty)
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
                    itemCount: _state.pagination.products.length,
                    itemBuilder: (context, index) {
                      final product = _state.pagination.products[index];
                      return ProductCard(
                        product: product,
                        onTap: _navigator.goDetails,
                      );
                    },
                  ),
                ),
              ),
            if (_state.pagination.products.isEmpty && !_state.isLoading)
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No products found.'),
                      const SizedBox(height: 16),
                      ProductListingReloadButton(
                        onPressed: _fetchProducts,
                        inProgress: _state.isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            if (_state.isLoading && _state.pagination.products.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
