import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_image.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final Item item;
  final CartDetailsState state;
  final Function(Item item) increase;
  final Function(Item item) decrease;
  final Function(Item item) remove;

  const CartItem({
    super.key,
    required this.item,
    required this.state,
    required this.increase,
    required this.decrease,
    required this.remove,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 60,
              height: 60,
              child: ProductImage(product: product),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed:
                            state.isValidatingAction
                                ? null
                                : () => decrease(item),
                        tooltip: 'Decrease quantity',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${item.quantity}',
                          style: textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed:
                            state.isValidatingAction
                                ? null
                                : () => increase(item),
                        tooltip: 'Increase quantity',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.secondary),
              tooltip: 'Remove item',
              onPressed: state.isValidatingAction ? null : () => remove(item),
            ),
          ),
        ],
      ),
    );
  }
}
