import 'package:clean_ecommerce/ui/app_config.dart';
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
import 'package:provider/provider.dart';

class MvvmRouter extends StatelessWidget {
  final AppDataSource dataSource;
  const MvvmRouter({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return AppRouter(
      dataSource: dataSource,
      flavor: Flavor.mvvm,
      listingScreenBuilder:
          (context) => ListingView(
            viewModel: ListingViewModel(
              repository: context.read(),
              dialog: EcommerceDialog(context),
            ),
          ),
      cartScreenBuilder:
          (context) => CartView(
            viewModel: CartViewModel(
              repository: context.read(),
              dialog: EcommerceDialog(context),
              stockRepository: context.read(),
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
          cartRepository: context.read(),
          stockRepository: context.read(),
          repository: context.read(),
        );
        return ProductView(viewModel: viewModel);
      },
    );
  }
}
