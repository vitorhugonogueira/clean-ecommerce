import 'package:clean_ecommerce/ui/common/widgets/cart/cart_details.dart';
import 'package:clean_ecommerce/ui/pages/mvvm/cart/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  final CartViewModel viewModel;

  const CartView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartViewModel>(
      create: (_) => viewModel,
      child: Consumer<CartViewModel>(
        builder: (context, vm, child) {
          return CartDetails(
            state: vm.state,
            increase: vm.increase,
            decrease: vm.decrease,
            remove: vm.remove,
          );
        },
      ),
    );
  }
}
