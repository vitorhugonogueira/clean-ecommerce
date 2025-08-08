import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/states/product_details_state.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_details.dart';
import 'package:clean_ecommerce/ui/pages/bloc/product/product_bloc_page_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBlocPage extends StatelessWidget {
  final String productId;

  const ProductBlocPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    ProductBlocPagePresenter? presenter;
    presenter = ProductBlocPagePresenter(
      productId,
      repository: context.read(),
      stockRepository: context.read(),
      cartRepository: context.read(),
      navigator: EcommerceNavigator(
        context,
        cartGoBackCallback: () {
          presenter?.usecase.execute(
            productId: productId,
            product: presenter.state.product,
          );
        },
      ),
      dialog: EcommerceDialog(context),
    );

    return BlocProvider(
      create: (_) => presenter!,
      child: BlocBuilder<ProductBlocPagePresenter, ProductDetailsState>(
        builder: (context, state) {
          return ProductDetails(
            context: context,
            productId: productId,
            state: state,
            load: presenter!.usecase.execute,
            addProduct: presenter.addProductUsecase.execute,
          );
        },
      ),
    );
  }
}
