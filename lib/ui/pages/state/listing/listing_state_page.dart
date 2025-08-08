import 'package:clean_ecommerce/domain/usecases/product/show_products_usecase.dart';
import 'package:clean_ecommerce/ui/common/states/product_listing_state.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_listing.dart';
import 'package:clean_ecommerce/ui/pages/state/listing/listing_state_page_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = EcommerceNavigator(context);
    final dialog = EcommerceDialog(context);
    final presenter = ListingStatePagePresenter(
      onStateChanged: (state) {
        setState(() {
          _state = state;
        });
      },
    );

    _useCase = ShowProductsUseCase(
      repository: context.read(),
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
    return ProductListing(
      state: _state,
      fetchProducts: _fetchProducts,
      navigator: _navigator,
    );
  }
}
