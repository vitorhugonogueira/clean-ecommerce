import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_listing.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/listing/listing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListingView extends StatelessWidget {
  final ListingViewModel viewModel;
  const ListingView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final navigator = EcommerceNavigator(context);

    return ChangeNotifierProvider<ListingViewModel>(
      create: (_) => viewModel,
      child: Consumer<ListingViewModel>(
        builder: (context, vm, child) {
          return ProductListing(
            state: vm.state,
            fetchProducts: vm.fetchProducts,
            navigator: navigator,
          );
        },
      ),
    );
  }
}
