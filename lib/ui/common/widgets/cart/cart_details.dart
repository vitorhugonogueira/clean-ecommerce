import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';
import 'package:clean_ecommerce/ui/common/widgets/cart/cart_item.dart';
import 'package:clean_ecommerce/ui/common/widgets/ecommerce_scaffold.dart';
import 'package:flutter/material.dart';

class CartDetails extends StatelessWidget {
  final Function(Item item) increase;
  final Function(Item item) decrease;
  final Function(Item item) remove;
  final CartDetailsState state;

  const CartDetails({
    super.key,
    required this.increase,
    required this.decrease,
    required this.remove,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return CleanScaffold(
      title: 'Bag',
      body: _buildBodyContent(context),
      context: context,
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final cart = state.cart;

    if (cart.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Your bag is empty.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), // Go back
              child: const Text('Continue shopping'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total: ${cart.totalLabel}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return CartItem(
                    item: item,
                    state: state,
                    increase: increase,
                    decrease: decrease,
                    remove: remove,
                  );
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
