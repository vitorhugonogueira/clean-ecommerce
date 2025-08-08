import 'package:clean_ecommerce/domain/usecases/product/show_products_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_listing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'listing_provider_page_presenter.dart';

class ListingProviderPage extends StatelessWidget {
  final _presenter = ListingProviderPagePresenter();
  ListingProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usecase = ShowProductsUseCase(
      repository: context.read(),
      presenter: _presenter,
      dialog: EcommerceDialog(context),
    );
    usecase.execute();

    return ChangeNotifierProvider<ListingProviderPagePresenter>(
      create: (_) => _presenter,
      child: Consumer<ListingProviderPagePresenter>(
        builder: (context, presenter, child) {
          return ProductListing(
            state: presenter.state,
            fetchProducts: usecase.execute,
            navigator: EcommerceNavigator(context),
          );
        },
      ),
    );
  }
}
