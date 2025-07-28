import 'package:clean_ecommerce/data/data_sources/product_listing_data_source.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_products_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/states/product_listing_state.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_listing.dart';
import 'package:clean_ecommerce/ui/pages/bloc/listing/listing_bloc_page_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListingBlocPage extends StatelessWidget {
  final datasource = ProductListingDataSource();
  final presenter = ListingBlocPagePresenter();
  ListingBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usecase = ShowProductsUseCase(
      repository: datasource,
      presenter: presenter,
      dialog: EcommerceDialog(context),
    )..execute();

    return BlocProvider(
      create: (_) => presenter,
      child: BlocBuilder<ListingBlocPagePresenter, ProductListingState>(
        builder: (context, state) {
          return ProductListing(
            state: state,
            fetchProducts: usecase.execute,
            navigator: EcommerceNavigator(context),
          );
        },
      ),
    );
  }
}
