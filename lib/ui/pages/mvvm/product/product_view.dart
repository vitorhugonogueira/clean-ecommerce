import 'package:clean_ecommerce/ui/common/widgets/product/product_details.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/product/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  final ProductViewModel viewModel;

  const ProductView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductViewModel>(
      create: (_) => viewModel,
      child: Consumer<ProductViewModel>(
        builder: (context, vm, child) {
          return ProductDetails(
            state: vm.state,
            addProduct: vm.addProductToCart,
            context: context,
            load: vm.load,
            productId: vm.productId,
          );
        },
      ),
    );
  }
}
