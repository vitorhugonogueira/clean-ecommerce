import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/product_details_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/product_listing_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/ui/app_flavor.dart';
import 'package:clean_ecommerce/ui/app_router.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/cart/cart_view.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/cart/cart_view_model.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/listing/listing_view.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/listing/listing_view_model.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/product/product_view.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/product/product_view_model.dart';
import 'package:flutter/material.dart';

class MvvmRouter extends StatelessWidget {
  const MvvmRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return AppRouter(
      flavor: Flavor.mvvm,
      listingScreenBuilder:
          (context) => ListingView(
            viewModel: ListingViewModel(
              repository: ProductListingDataSource(),
              dialog: EcommerceDialog(context),
            ),
          ),
      cartScreenBuilder:
          (context) => CartView(
            viewModel: CartViewModel(
              repository: CartDataSource(),
              dialog: EcommerceDialog(context),
              stockRepository: StockDataSource(),
            ),
          ),
      productScreenBuilder: (context, String id) {
        ProductViewModel? viewModel;
        viewModel = ProductViewModel(
          productId: id,
          dialog: EcommerceDialog(context),
          navigator: EcommerceNavigator(
            context,
            cartGoBackCallback:
                () => viewModel?.load(
                  productId: id,
                  product: viewModel.state.product,
                ),
          ),
          cartRepository: CartDataSource(),
          stockRepository: StockDataSource(),
          repository: ProductDetailsDataSource(),
        );
        return ProductView(viewModel: viewModel);
      },
    );
  }
}
